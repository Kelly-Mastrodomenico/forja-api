<?php
require_once '../config/database.php';
require_once '../config/ia.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(["error" => "Método no permitido"]);
    exit();
}

$pdo     = conectarDB();
$usuario = validarToken($pdo);
$datos   = json_decode(file_get_contents("php://input"), true);
$tipo    = (isset($datos['tipo']) && $datos['tipo'] === 'mensual') ? 'mensual' : 'semanal';

$NOMBRES_DIAS = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];

// ── Días seleccionados por el usuario ─────────────────────────────────────────
$diasSemana = null;
if (isset($datos['dias_semana']) && is_array($datos['dias_semana']) && count($datos['dias_semana']) > 0) {
    $diasSemana = array_values(array_filter($datos['dias_semana'], fn($d) => is_int($d) && $d >= 0 && $d <= 6));
    sort($diasSemana);
}

// ─────────────────────────────────────────────────────────────────────────────
// FUNCIÓN: llamar a Groq
// ─────────────────────────────────────────────────────────────────────────────
function llamarGroq(string $sistemaPrompt, string $usuarioPrompt, int $maxTokens, string $apiKey): ?string {
    $url = "https://api.groq.com/openai/v1/chat/completions";
    $ch  = curl_init($url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode([
        "model"       => "llama-3.3-70b-versatile",
        "messages"    => [
            ["role" => "system", "content" => $sistemaPrompt],
            ["role" => "user",   "content" => $usuarioPrompt],
        ],
        "temperature" => 0.6,
        "max_tokens"  => $maxTokens,
    ]));
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        'Content-Type: application/json',
        'Authorization: Bearer ' . $apiKey,
    ]);
    curl_setopt($ch, CURLOPT_TIMEOUT, 90);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);

    $resultado  = curl_exec($ch);
    $errorCurl  = curl_error($ch);
    $httpCode   = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);

    if ($errorCurl || $httpCode === 429) return null;

    return json_decode($resultado, true)['choices'][0]['message']['content'] ?? null;
}

// ─────────────────────────────────────────────────────────────────────────────
// FUNCIÓN: extraer JSON limpio del texto de la IA
// ─────────────────────────────────────────────────────────────────────────────
function extraerJSON(string $texto): ?array {
    $ini = strpos($texto, '{');
    if ($ini === false) $ini = strpos($texto, '[');
    $fin = strrpos($texto, '}');
    if ($fin === false) $fin = strrpos($texto, ']');
    if ($ini === false || $fin === false) return null;
    return json_decode(substr($texto, $ini, $fin - $ini + 1), true) ?: null;
}

// ─────────────────────────────────────────────────────────────────────────────
// FUNCIÓN: calcular fase hormonal
// ─────────────────────────────────────────────────────────────────────────────
function calcularFaseHormonal(?string $fechaUltimoCiclo, int $duracionCiclo): ?string {
    if (!$fechaUltimoCiclo) return null;
    $inicio    = new DateTime($fechaUltimoCiclo);
    $hoy       = new DateTime();
    $diff      = $inicio->diff($hoy)->days;
    $diaActual = $diff % $duracionCiclo;
    if ($diaActual <= 5)  return 'menstrual';
    if ($diaActual <= 13) return 'folicular';
    if ($diaActual <= 16) return 'ovulatoria';
    return 'lutea';
}

try {
    $apiKey = obtenerApiKey();

    // ── 1. Obtener perfil completo ──────────────────────────────────────────
    $stmt = $pdo->prepare("
        SELECT u.nombre, u.sexo, u.fecha_nacimiento, u.altura_cm,
               u.peso_actual, u.peso_objetivo, u.grasa_objetivo,
               u.objetivo, u.dias_entrenamiento, u.nivel,
               u.tiene_ciclo, u.duracion_ciclo, u.fecha_ultimo_ciclo,
               u.tipo_dieta, u.alergias, u.alimentos_no_gusta, u.alimentos_favoritos,
               COALESCE(u.comidas_diarias, 5) AS comidas_diarias,
               GROUP_CONCAT(p.patologia SEPARATOR ', ') AS condiciones
        FROM usuarios u
        LEFT JOIN usuario_patologias p ON p.usuario_id = u.id
        WHERE u.id = :id
        GROUP BY u.id
    ");
    $stmt->bindValue(':id', $usuario['id']);
    $stmt->execute();
    $perfil = $stmt->fetch();

    $edad        = date_diff(date_create($perfil['fecha_nacimiento']), date_create('today'))->y;
    $condiciones = ($perfil['condiciones'] && $perfil['condiciones'] !== 'ninguna') ? $perfil['condiciones'] : 'ninguna';
    $pesoObj     = $perfil['peso_objetivo']  ? "Peso objetivo: {$perfil['peso_objetivo']} kg." : '';
    $grasaObj    = $perfil['grasa_objetivo'] ? "Grasa objetivo: {$perfil['grasa_objetivo']}%." : '';

    // Preferencias alimentarias
    $tipoDieta     = $perfil['tipo_dieta']          ?: 'omnivora';
    $alergias      = $perfil['alergias']             ? json_decode($perfil['alergias'], true)             : [];
    $noGusta       = $perfil['alimentos_no_gusta']   ? json_decode($perfil['alimentos_no_gusta'], true)   : [];
    $favoritos     = $perfil['alimentos_favoritos']  ? json_decode($perfil['alimentos_favoritos'], true)  : [];
    $alergiasStr   = !empty($alergias)  ? implode(', ', $alergias)  : 'ninguna';
    $noGustaStr    = !empty($noGusta)   ? implode(', ', $noGusta)   : 'ninguno';
    $favoritosStr  = !empty($favoritos) ? implode(', ', $favoritos) : 'sin preferencia especial';

    // Fase hormonal
    $faseHormonal = null;
    if ($perfil['tiene_ciclo'] && $perfil['fecha_ultimo_ciclo']) {
        $faseHormonal = calcularFaseHormonal($perfil['fecha_ultimo_ciclo'], (int)($perfil['duracion_ciclo'] ?? 28));
    }

    // ── 2. Calcular días a usar ─────────────────────────────────────────────
    if ($diasSemana && count($diasSemana) > 0) {
        $numDias = count($diasSemana);
        $pdo->prepare("UPDATE usuarios SET dias_entrenamiento = :d WHERE id = :id")
            ->execute([':d' => $numDias, ':id' => $usuario['id']]);
        $perfil['dias_entrenamiento'] = $numDias;
    } else {
        $numDias    = (int)($perfil['dias_entrenamiento'] ?? 3);
        $diasSemana = range(0, $numDias - 1);
    }

    // Descripción días para el prompt
    $descripcionDias = [];
    foreach ($diasSemana as $i => $dIdx) {
        $descripcionDias[] = "Día " . ($i + 1) . " = {$NOMBRES_DIAS[$dIdx]} (dia_semana: {$dIdx})";
    }
    $diasDescStr = implode(" | ", $descripcionDias);

    // ── 3. Cargar biblioteca de ejercicios ──────────────────────────────────
    $stmtEj     = $pdo->query("SELECT id, nombre, categoria, enfoque_muscular, riesgo, sustitucion_id FROM ejercicios ORDER BY categoria");
    $biblioteca = $stmtEj->fetchAll();
    $idsValidos = array_column($biblioteca, 'id');
    $bibJson    = json_encode(array_map(fn($e) => [
        'id'          => $e['id'],
        'nombre'      => $e['nombre'],
        'categoria'   => $e['categoria'],
        'enfoque'     => $e['enfoque_muscular'],
        'riesgo'      => $e['riesgo'],
        'sustitucion' => $e['sustitucion_id'],
    ], $biblioteca), JSON_UNESCAPED_UNICODE);

    // ════════════════════════════════════════════════════════════════════════
    // PROMPT 1: GENERAR RUTINA
    // ════════════════════════════════════════════════════════════════════════
    $sistemaRutina = "Eres un Sistema de Inteligencia Deportiva y Clínica. Generas planes de entrenamiento basados en evidencia científica (ACSM, NSCA, ISSN).
REGLAS:
1. SOLO usa IDs exactos de la BIBLIOTECA. Nunca inventes IDs.
2. Si hay lesiones usa el campo 'sustitucion' en lugar del ejercicio afectado.
3. Mujeres: priorizar cadena posterior, glúteo, isquiotibiales.
4. Ciclo activo: RIR +1 en días 15-28.
5. Plan mensual: semana 4 = deload (mismos ejercicios, series al 50%).
6. Cada día debe incluir campo dia_semana con el valor exacto indicado.
7. Responde ÚNICAMENTE con JSON puro válido.";

    $usuarioRutina = "Genera plan {$tipo} para:
PERFIL: Sexo: {$perfil['sexo']} | Edad: {$edad} | {$perfil['altura_cm']}cm, {$perfil['peso_actual']}kg
Objetivo: {$perfil['objetivo']}. {$pesoObj} {$grasaObj}
Nivel: {$perfil['nivel']} | Condiciones: {$condiciones}
Ciclo: " . ($perfil['tiene_ciclo'] ? "Sí ({$perfil['duracion_ciclo']} días)" : 'No') . "

DÍAS: {$diasDescStr}

BIBLIOTECA: {$bibJson}

FORMATO JSON:
{\"tipo_plan\":\"{$tipo}\",\"periodizacion\":\"...\",\"semanas\":[{\"semana_numero\":1,\"es_deload\":false,\"dias\":[{\"dia_numero\":1,\"dia_semana\":0,\"dia_nombre\":\"Lunes: Tren Inferior\",\"grupo_muscular\":\"piernas\",\"justificacion_clinica\":\"\",\"ejercicios\":[{\"id\":\"sentadilla_hack_maquina\",\"series\":4,\"reps\":\"10-12\",\"rir\":2,\"descanso\":\"90s\",\"nota_tecnica\":\"Pausa 1s\"}]}]}]}

Genera " . ($tipo === 'mensual' ? '4 semanas' : '1 semana') . " con {$numDias} días/semana. 4-6 ejercicios/día. Solo JSON.";

    $textoRutina = llamarGroq($sistemaRutina, $usuarioRutina, ($tipo === 'mensual') ? 8000 : 3000, $apiKey);
    if (!$textoRutina) {
        http_response_code(500);
        echo json_encode(["error" => "Error al generar la rutina con IA"]);
        exit();
    }
    $planRutina = extraerJSON($textoRutina);
    if (!$planRutina || !isset($planRutina['semanas'])) {
        http_response_code(500);
        echo json_encode(["error" => "Formato inesperado de la rutina", "raw" => $textoRutina]);
        exit();
    }

    // ── 4. Guardar rutina en BD ─────────────────────────────────────────────
    $mapaDias = [];
    foreach ($diasSemana as $i => $dIdx) {
        $mapaDias[$i + 1] = $dIdx;
    }

    $pdo->beginTransaction();
    try {
        // Desactivar plan anterior
        $pdo->prepare("UPDATE planes_entrenamiento SET activo = 0 WHERE usuario_id = :uid AND tipo_plan = :tipo AND activo = 1")
            ->execute([':uid' => $usuario['id'], ':tipo' => $tipo]);

        // Insertar cabecera
        $fechaFin = ($tipo === 'mensual') ? date('Y-m-d', strtotime('+28 days')) : date('Y-m-d', strtotime('+7 days'));
        $sP = $pdo->prepare("INSERT INTO planes_entrenamiento (usuario_id, tipo_plan, fecha_inicio, fecha_fin, periodizacion, activo) VALUES (:uid, :tipo, CURDATE(), :fin, :peri, 1)");
        $sP->bindValue(':uid',  $usuario['id']);
        $sP->bindValue(':tipo', $tipo);
        $sP->bindValue(':fin',  $fechaFin);
        $sP->bindValue(':peri', $planRutina['periodizacion'] ?? '');
        $sP->execute();
        $planId = $pdo->lastInsertId();

        // Insertar ejercicios
        $stmtD = $pdo->prepare("
            INSERT INTO plan_detalle (plan_id, semana_numero, dia_numero, dia_semana, nombre_dia, ejercicio_id, orden, series, repeticiones, rir, descanso, nota_tecnica)
            VALUES (:plan_id, :semana, :dia_num, :dia_semana, :dia_nombre, :ej_id, :orden, :series, :reps, :rir, :descanso, :nota)
        ");

        // Recopilar resumen de días para el prompt de dieta
        $resumenDias = [];

        foreach ($planRutina['semanas'] as $semana) {
            $semNum = (int)($semana['semana_numero'] ?? 1);
            foreach ($semana['dias'] as $dia) {
                $diaNum    = (int)($dia['dia_numero'] ?? 1);
                $diaNombre = $dia['dia_nombre'] ?? "Día {$diaNum}";
                $diaSmn    = isset($dia['dia_semana']) ? (int)$dia['dia_semana'] : ($mapaDias[$diaNum] ?? ($diaNum - 1));
                $grupoMuscular = $dia['grupo_muscular'] ?? '';

                // Solo semana 1 para el plan nutricional
                if ($semNum === 1 && !isset($resumenDias[$diaSmn])) {
                    $ejerciciosNombres = array_map(fn($e) => $e['id'], $dia['ejercicios'] ?? []);
                    $resumenDias[$diaSmn] = [
                        'dia_semana'     => $diaSmn,
                        'dia_nombre'     => $diaNombre,
                        'grupo_muscular' => $grupoMuscular,
                        'ejercicios'     => implode(', ', $ejerciciosNombres),
                    ];
                }

                $orden = 1;
                foreach ($dia['ejercicios'] as $ej) {
                    if (!in_array($ej['id'], $idsValidos)) continue;
                    $stmtD->bindValue(':plan_id',    $planId);
                    $stmtD->bindValue(':semana',     $semNum);
                    $stmtD->bindValue(':dia_num',    $diaNum);
                    $stmtD->bindValue(':dia_semana', $diaSmn);
                    $stmtD->bindValue(':dia_nombre', $diaNombre);
                    $stmtD->bindValue(':ej_id',      $ej['id']);
                    $stmtD->bindValue(':orden',      $orden);
                    $stmtD->bindValue(':series',     (int)($ej['series'] ?? 3));
                    $stmtD->bindValue(':reps',       $ej['reps'] ?? '10-12');
                    $stmtD->bindValue(':rir',        isset($ej['rir']) ? (int)$ej['rir'] : null, PDO::PARAM_INT);
                    $stmtD->bindValue(':descanso',   $ej['descanso'] ?? '60s');
                    $stmtD->bindValue(':nota',       $ej['nota_tecnica'] ?? null);
                    $stmtD->execute();
                    $orden++;
                }
            }
        }

        $pdo->commit();

    } catch (Exception $e) {
        $pdo->rollBack();
        throw $e;
    }

    // ════════════════════════════════════════════════════════════════════════
    // PROMPT 2: GENERAR DIETA por cada día de entrenamiento
    // ════════════════════════════════════════════════════════════════════════
    // Construir descripción de días de entrenamiento + días de descanso
    $todosDias = range(0, 6);
    $diasDescanso = array_values(array_diff($todosDias, $diasSemana));

    $faseCicloStr = $faseHormonal
        ? "Fase del ciclo menstrual actual: {$faseHormonal}."
        : "Sin ciclo menstrual activo.";

    $ajusteHormonal = '';
    if ($faseHormonal === 'lutea')      $ajusteHormonal = 'Fase lútea: +200 kcal, priorizar grasas saludables y aumentar hidratación.';
    if ($faseHormonal === 'menstrual')  $ajusteHormonal = 'Fase menstrual: -100 kcal, reducir inflamatorios, priorizar hierro.';
    if ($faseHormonal === 'ovulatoria') $ajusteHormonal = 'Fase ovulatoria: +100 kcal, máximo rendimiento.';
    if ($faseHormonal === 'folicular')  $ajusteHormonal = 'Fase folicular: óptima sensibilidad a insulina, buenos carbohidratos.';

    $resumenDiasJson = json_encode(array_values($resumenDias), JSON_UNESCAPED_UNICODE);
    $diasDescansoStr = !empty($diasDescanso)
        ? implode(', ', array_map(fn($d) => $NOMBRES_DIAS[$d], $diasDescanso))
        : 'ninguno';

    // ── Definir momentos según preferencia del usuario ──────────────────────
    $numComidas = max(3, min(6, (int)($perfil['comidas_diarias'] ?? 5)));

    $momentosEntreno = match($numComidas) {
        3 => ['desayuno', 'almuerzo', 'cena'],
        4 => ['desayuno', 'almuerzo', 'pre_entreno', 'cena'],
        5 => ['desayuno', 'media_manana', 'almuerzo', 'pre_entreno', 'cena'],
        6 => ['desayuno', 'media_manana', 'almuerzo', 'merienda', 'pre_entreno', 'cena'],
        default => ['desayuno', 'media_manana', 'almuerzo', 'pre_entreno', 'cena'],
    };
    $momentosDescanso = match($numComidas) {
        3 => ['desayuno', 'almuerzo', 'cena'],
        4 => ['desayuno', 'almuerzo', 'merienda', 'cena'],
        5 => ['desayuno', 'media_manana', 'almuerzo', 'merienda', 'cena'],
        6 => ['desayuno', 'media_manana', 'almuerzo', 'merienda', 'cena'],
        default => ['desayuno', 'almuerzo', 'merienda', 'cena'],
    };

    $horasMomentos = [
        'desayuno'     => '08:00',
        'media_manana' => '11:00',
        'almuerzo'     => '13:30',
        'merienda'     => '17:00',
        'pre_entreno'  => '18:30',
        'cena'         => '21:00',
    ];

    $descEntreno  = implode(' + ', array_map(fn($m) => "\"{$m}\" ({$horasMomentos[$m]})", $momentosEntreno));
    $descDescanso = implode(' + ', array_map(fn($m) => "\"{$m}\" ({$horasMomentos[$m]})", $momentosDescanso));
    $numEntreno   = count($momentosEntreno);
    $numDescanso  = count($momentosDescanso);

    // Ejemplo dinámico de comidas para el prompt (solo primeras 2 para no inflar tokens)
    $ejemploComidas = [];
    foreach (array_slice($momentosEntreno, 0, 2) as $m) {
        $ejemploComidas[] = "{\"momento\":\"{$m}\",\"nombre_comida\":\"Nombre de la comida\",\"hora_sugerida\":\"{$horasMomentos[$m]}\",\"ingredientes\":[{\"nombre\":\"Alimento\",\"cantidad_g\":100,\"unidad\":\"g\",\"peso_crudo\":true}],\"calorias\":400,\"proteinas\":30,\"carbos\":45,\"grasas\":10}";
    }
    $ejemploComidas[] = "... (resto de comidas hasta completar {$numEntreno})";
    $ejemploJson = implode(",\n        ", $ejemploComidas);

    $sistemaDieta = "Eres un nutricionista deportivo especializado en periodización nutricional y rendimiento atlético.
REGLAS ESTRICTAS:
1. Genera planes nutricionales REALES con alimentos concretos y cantidades en gramos.
2. Usa los alimentos favoritos del usuario cuando sea posible.
3. NUNCA uses alimentos de la lista de alergias ni de no_gusta.
4. Días de entrenamiento: +15% calorías, más carbohidratos.
5. Días de descanso: carbohidratos moderados, proteína alta.
6. Aplica el ajuste hormonal indicado si aplica.
7. USA EXACTAMENTE los momentos indicados — ni más ni menos.
8. Distribuye calorías y macros proporcionalmente entre todas las comidas del día.
9. Responde ÚNICAMENTE con JSON puro válido, sin markdown ni texto extra.";

    $usuarioDieta = "Genera plan nutricional para CADA DÍA de la semana (7 días):

PERFIL:
- Sexo: {$perfil['sexo']} | Edad: {$edad} | {$perfil['altura_cm']}cm, {$perfil['peso_actual']}kg
- Objetivo: {$perfil['objetivo']}. {$pesoObj} {$grasaObj}
- Nivel: {$perfil['nivel']} | Tipo de dieta: {$tipoDieta}
- Alergias: {$alergiasStr}
- No le gusta: {$noGustaStr}
- Favoritos: {$favoritosStr}
- {$faseCicloStr} {$ajusteHormonal}

PREFERENCIA DEL USUARIO: {$numComidas} comidas al día.

DÍAS DE ENTRENAMIENTO:
{$resumenDiasJson}

DÍAS DE DESCANSO: {$diasDescansoStr}

MOMENTOS OBLIGATORIOS — USA EXACTAMENTE ESTOS, EN ESTE ORDEN:
- Día ENTRENO ({$numEntreno} comidas): {$descEntreno}
- Día DESCANSO ({$numDescanso} comidas): {$descDescanso}

FORMATO JSON:
{
  \"dias\": [
    {
      \"dia_semana\": 0,
      \"tipo_dia\": \"entreno\",
      \"nombre_dia\": \"Lunes: Tren Inferior\",
      \"grupo_muscular\": \"piernas\",
      \"estrategia\": \"Descripción de la estrategia nutricional.\",
      \"estado_metabolico\": \"Anabólico Optimizado\",
      \"calorias_total\": 2450,
      \"proteinas_total\": 185,
      \"carbos_total\": 280,
      \"grasas_total\": 65,
      \"comidas\": [
        {$ejemploJson}
      ]
    }
  ]
}

Genera los 7 días. Días de descanso usan tipo_dia: \"descanso\". Solo JSON puro.";


    $textoDieta = llamarGroq($sistemaDieta, $usuarioDieta, 8000, $apiKey);

    $planNutricionalGuardado = false;
    $errDieta = null;

    if ($textoDieta) {
        $planDieta = extraerJSON($textoDieta);

        if ($planDieta && isset($planDieta['dias']) && is_array($planDieta['dias'])) {
            // ── Guardar plan nutricional en BD ──────────────────────────────
            $pdo->beginTransaction();
            try {
                // Borrar plan nutricional anterior vinculado al plan de entreno
                $pdo->prepare("DELETE FROM plan_nutricional WHERE usuario_id = :uid")
                    ->execute([':uid' => $usuario['id']]);

                $stmtPN = $pdo->prepare("
                    INSERT INTO plan_nutricional
                        (usuario_id, plan_entreno_id, dia_semana, tipo_dia, nombre_dia, grupo_muscular,
                         fase_hormonal, calorias_total, proteinas_total, carbos_total, grasas_total,
                         estrategia, estado_metabolico)
                    VALUES
                        (:uid, :plan_id, :dia_semana, :tipo_dia, :nombre_dia, :grupo_muscular,
                         :fase, :calorias, :proteinas, :carbos, :grasas,
                         :estrategia, :estado)
                ");

                $stmtPC = $pdo->prepare("
                    INSERT INTO plan_nutricional_comidas
                        (plan_nutricional_id, momento, nombre_comida, hora_sugerida, ingredientes, calorias, proteinas, carbos, grasas)
                    VALUES
                        (:pn_id, :momento, :nombre, :hora, :ingredientes, :calorias, :proteinas, :carbos, :grasas)
                ");

                foreach ($planDieta['dias'] as $dia) {
                    $diaSemana = (int)($dia['dia_semana'] ?? 0);

                    $stmtPN->bindValue(':uid',            $usuario['id']);
                    $stmtPN->bindValue(':plan_id',        $planId);
                    $stmtPN->bindValue(':dia_semana',     $diaSemana);
                    $stmtPN->bindValue(':tipo_dia',       $dia['tipo_dia'] ?? 'entreno');
                    $stmtPN->bindValue(':nombre_dia',     $dia['nombre_dia'] ?? null);
                    $stmtPN->bindValue(':grupo_muscular', $dia['grupo_muscular'] ?? null);
                    $stmtPN->bindValue(':fase',           $faseHormonal);
                    $stmtPN->bindValue(':calorias',       (float)($dia['calorias_total'] ?? 0));
                    $stmtPN->bindValue(':proteinas',      (float)($dia['proteinas_total'] ?? 0));
                    $stmtPN->bindValue(':carbos',         (float)($dia['carbos_total'] ?? 0));
                    $stmtPN->bindValue(':grasas',         (float)($dia['grasas_total'] ?? 0));
                    $stmtPN->bindValue(':estrategia',     $dia['estrategia'] ?? null);
                    $stmtPN->bindValue(':estado',         $dia['estado_metabolico'] ?? null);
                    $stmtPN->execute();
                    $pnId = $pdo->lastInsertId();

                    // Guardar comidas
                    foreach (($dia['comidas'] ?? []) as $comida) {
                        $stmtPC->bindValue(':pn_id',       $pnId);
                        $stmtPC->bindValue(':momento',     $comida['momento'] ?? 'almuerzo');
                        $stmtPC->bindValue(':nombre',      $comida['nombre_comida'] ?? 'Comida');
                        $stmtPC->bindValue(':hora',        $comida['hora_sugerida'] ?? null);
                        $stmtPC->bindValue(':ingredientes',json_encode($comida['ingredientes'] ?? [], JSON_UNESCAPED_UNICODE));
                        $stmtPC->bindValue(':calorias',    isset($comida['calorias'])  ? (float)$comida['calorias']  : null);
                        $stmtPC->bindValue(':proteinas',   isset($comida['proteinas']) ? (float)$comida['proteinas'] : null);
                        $stmtPC->bindValue(':carbos',      isset($comida['carbos'])    ? (float)$comida['carbos']    : null);
                        $stmtPC->bindValue(':grasas',      isset($comida['grasas'])    ? (float)$comida['grasas']    : null);
                        $stmtPC->execute();
                    }
                }

                $pdo->commit();
                $planNutricionalGuardado = true;

            } catch (Exception $e) {
                $pdo->rollBack();
                $errDieta = $e->getMessage();
            }
        } else {
            $errDieta = 'Formato inesperado del plan de dieta';
        }
    } else {
        $errDieta = 'No se pudo generar la dieta con IA';
    }

    // ── 5. Respuesta final ──────────────────────────────────────────────────
    echo json_encode([
        "plan_id"                  => $planId,
        "tipo"                     => $tipo,
        "dias_semana"              => $diasSemana,
        "periodizacion"            => $planRutina['periodizacion'] ?? '',
        "semanas"                  => $planRutina['semanas'],
        "plan_nutricional_guardado"=> $planNutricionalGuardado,
        "dieta_error"              => $errDieta,
        "perfil_usado"             => [
            "objetivo"    => $perfil['objetivo'],
            "nivel"       => $perfil['nivel'],
            "condiciones" => $condiciones,
            "num_dias"    => $numDias,
            "tipo_dieta"  => $tipoDieta,
        ],
    ], JSON_UNESCAPED_UNICODE);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(["error" => $e->getMessage()]);
}