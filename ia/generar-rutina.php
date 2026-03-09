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

// ── NUEVO: recibir días reales seleccionados por el usuario ────────────────
// Ej: [0,1,2,4,5] = Lun, Mar, Mie, Vie, Sáb
$NOMBRES_DIAS = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];

$diasSemana = null;
if (isset($datos['dias_semana']) && is_array($datos['dias_semana']) && count($datos['dias_semana']) > 0) {
    $diasSemana = array_values(array_filter($datos['dias_semana'], fn($d) => is_int($d) && $d >= 0 && $d <= 6));
    sort($diasSemana);
}
// ──────────────────────────────────────────────────────────────────────────

try {
    // ── 1. Obtener perfil completo ─────────────────────────────────────────
    $stmt = $pdo->prepare("
        SELECT u.nombre, u.sexo, u.fecha_nacimiento, u.altura_cm,
               u.peso_actual, u.peso_objetivo, u.grasa_objetivo,
               u.objetivo, u.dias_entrenamiento, u.nivel,
               u.tiene_ciclo, u.duracion_ciclo,
               GROUP_CONCAT(p.patologia SEPARATOR ', ') AS condiciones
        FROM usuarios u
        LEFT JOIN usuario_patologias p ON p.usuario_id = u.id
        WHERE u.id = :id
        GROUP BY u.id
    ");
    $stmt->bindValue(':id', $usuario['id']);
    $stmt->execute();
    $perfil = $stmt->fetch();

    $edad         = date_diff(date_create($perfil['fecha_nacimiento']), date_create('today'))->y;
    $condiciones  = ($perfil['condiciones'] && $perfil['condiciones'] !== 'ninguna') ? $perfil['condiciones'] : 'ninguna';
    $pesoObjetivo = $perfil['peso_objetivo']  ? "Peso objetivo: {$perfil['peso_objetivo']} kg." : '';
    $grasaObj     = $perfil['grasa_objetivo'] ? "Grasa objetivo: {$perfil['grasa_objetivo']}%." : '';

    // ── NUEVO: calcular días a usar ────────────────────────────────────────
    if ($diasSemana && count($diasSemana) > 0) {
        $numDias = count($diasSemana);
        // Actualizar dias_entrenamiento en perfil si cambió
        if ($numDias != (int)$perfil['dias_entrenamiento']) {
            $pdo->prepare("UPDATE usuarios SET dias_entrenamiento = :d WHERE id = :id")
                ->execute([':d' => $numDias, ':id' => $usuario['id']]);
            $perfil['dias_entrenamiento'] = $numDias;
        }
    } else {
        // Sin días específicos: usar los N primeros días de la semana según el perfil
        $numDias    = (int)($perfil['dias_entrenamiento'] ?? 3);
        $diasSemana = range(0, $numDias - 1);
    }

    // Construir descripción de días para el prompt
    // dia_numero (1..N) → nombre real del día
    $descripcionDias = [];
    foreach ($diasSemana as $i => $diaSemanaIdx) {
        $descripcionDias[] = "Día " . ($i + 1) . " = {$NOMBRES_DIAS[$diaSemanaIdx]} (dia_semana: {$diaSemanaIdx})";
    }
    $diasDescStr = implode(" | ", $descripcionDias);
    // ──────────────────────────────────────────────────────────────────────

    // ── 2. Cargar biblioteca de ejercicios ─────────────────────────────────
    $stmtEj = $pdo->query("SELECT id, nombre, categoria, enfoque_muscular, riesgo, sustitucion_id FROM ejercicios ORDER BY categoria");
    $biblioteca = $stmtEj->fetchAll();
    $idsValidos = array_column($biblioteca, 'id');

    $bibliotecaCompacta = array_map(fn($e) => [
        'id'         => $e['id'],
        'nombre'     => $e['nombre'],
        'categoria'  => $e['categoria'],
        'enfoque'    => $e['enfoque_muscular'],
        'riesgo'     => $e['riesgo'],
        'sustitucion'=> $e['sustitucion_id'],
    ], $biblioteca);

    $bibliotecaJson = json_encode($bibliotecaCompacta, JSON_UNESCAPED_UNICODE);

    // ── 3. Construir prompt ────────────────────────────────────────────────
    $sistemaPrompt = "Eres un Sistema de Inteligencia Deportiva y Clínica. Generas planes de entrenamiento basados en evidencia científica (ACSM, NSCA, ISSN).

REGLAS OBLIGATORIAS:
1. SOLO puedes usar los IDs exactos de la BIBLIOTECA proporcionada. Nunca inventes IDs.
2. Si el usuario tiene lesiones, usa el campo 'sustitucion' del ejercicio afectado en lugar del original.
3. BIOTIPO: hombres → priorizar pecho, espalda y hombros; mujeres → priorizar cadena posterior, glúteo, isquiotibiales y salud hormonal.
4. Si tiene ciclo menstrual activo: bajar intensidad (RIR +1) en días 15-28 del ciclo.
5. En planes mensuales: semana 4 = deload obligatorio (mismos ejercicios, series reducidas al 50%).
6. Responde ÚNICAMENTE con JSON puro válido, sin markdown, sin texto adicional.
7. IMPORTANTE: cada día del plan DEBE incluir el campo \"dia_semana\" con el valor numérico exacto indicado en DÍAS DE ENTRENAMIENTO.";

    $usuarioPrompt = "Genera un plan de entrenamiento {$tipo} para:

PERFIL:
- Sexo: {$perfil['sexo']} | Edad: {$edad} años
- Medidas: {$perfil['altura_cm']} cm, {$perfil['peso_actual']} kg
- Objetivo: {$perfil['objetivo']}. {$pesoObjetivo} {$grasaObj}
- Nivel: {$perfil['nivel']} | Días: {$perfil['dias_entrenamiento']}/semana
- Condiciones de salud: {$condiciones}
- Ciclo menstrual: " . ($perfil['tiene_ciclo'] ? "Sí ({$perfil['duracion_ciclo']} días)" : 'No') . "

DÍAS DE ENTRENAMIENTO (incluir dia_semana exacto en cada día):
{$diasDescStr}

BIBLIOTECA DE EJERCICIOS (usa solo estos IDs):
{$bibliotecaJson}

FORMATO REQUERIDO (JSON puro):
{
  \"tipo_plan\": \"{$tipo}\",
  \"periodizacion\": \"Explicación científica breve del enfoque del plan\",
  \"semanas\": [
    {
      \"semana_numero\": 1,
      \"es_deload\": false,
      \"dias\": [
        {
          \"dia_numero\": 1,
          \"dia_semana\": 0,
          \"dia_nombre\": \"Lunes: Tren Inferior\",
          \"grupo_muscular\": \"piernas, glúteo\",
          \"justificacion_clinica\": \"Ajuste clínico si aplica, o vacío\",
          \"ejercicios\": [
            {
              \"id\": \"sentadilla_hack_maquina\",
              \"series\": 4,
              \"reps\": \"10-12\",
              \"rir\": 2,
              \"descanso\": \"90s\",
              \"nota_tecnica\": \"Pausa de 1s en el fondo\"
            }
          ]
        }
      ]
    }
  ]
}

Genera " . ($tipo === 'mensual' ? '4 semanas' : '1 semana') . " con exactamente {$perfil['dias_entrenamiento']} días de entrenamiento por semana. Cada día: 4-6 ejercicios. Solo JSON puro.";

    // ── 4. Llamar a Groq ───────────────────────────────────────────────────
    $apiKey = obtenerApiKey();
    $url    = "https://api.groq.com/openai/v1/chat/completions";

    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode([
        "model"       => "llama-3.3-70b-versatile",
        "messages"    => [
            ["role" => "system", "content" => $sistemaPrompt],
            ["role" => "user",   "content" => $usuarioPrompt]
        ],
        "temperature" => 0.6,
        "max_tokens"  => ($tipo === 'mensual') ? 8000 : 3000
    ]));
    curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json', 'Authorization: Bearer ' . $apiKey]);
    curl_setopt($ch, CURLOPT_TIMEOUT, 90);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);

    $resultado = curl_exec($ch);
    $errorCurl = curl_error($ch);
    $httpCode  = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);

    if ($errorCurl) { http_response_code(500); echo json_encode(["error" => "Error curl: $errorCurl"]); exit(); }
    if ($httpCode === 429) { http_response_code(429); echo json_encode(["error" => "Límite de IA alcanzado."]); exit(); }

    $textoIA = json_decode($resultado, true)['choices'][0]['message']['content'] ?? '';

    // Limpiar y parsear JSON
    $ini = strpos($textoIA, '{');
    $fin = strrpos($textoIA, '}');
    if ($ini === false || $fin === false) {
        http_response_code(500);
        echo json_encode(["error" => "La IA no devolvió JSON", "raw" => $textoIA]);
        exit();
    }
    $planJSON = json_decode(substr($textoIA, $ini, $fin - $ini + 1), true);
    if (!$planJSON || !isset($planJSON['semanas'])) {
        http_response_code(500);
        echo json_encode(["error" => "Formato inesperado de la IA", "raw" => $textoIA]);
        exit();
    }

    // ── NUEVO: mapa de seguridad dia_numero → dia_semana ──────────────────
    // Por si la IA no devuelve el campo dia_semana en algún día
    $mapaDias = [];
    foreach ($diasSemana as $i => $diaSemanaIdx) {
        $mapaDias[$i + 1] = $diaSemanaIdx; // dia_numero 1 → índice real
    }
    // ──────────────────────────────────────────────────────────────────────

    // ── 5. Guardar en BD con transacción ───────────────────────────────────
    $pdo->beginTransaction();
    try {
        // Desactivar plan anterior del mismo tipo
        $s = $pdo->prepare("UPDATE planes_entrenamiento SET activo = 0 WHERE usuario_id = :uid AND tipo_plan = :tipo AND activo = 1");
        $s->bindValue(':uid',  $usuario['id']);
        $s->bindValue(':tipo', $tipo);
        $s->execute();

        // Insertar cabecera
        $fechaFin = ($tipo === 'mensual') ? date('Y-m-d', strtotime('+28 days')) : date('Y-m-d', strtotime('+7 days'));
        $s = $pdo->prepare("INSERT INTO planes_entrenamiento (usuario_id, tipo_plan, fecha_inicio, fecha_fin, periodizacion, activo) VALUES (:uid, :tipo, CURDATE(), :fin, :peri, 1)");
        $s->bindValue(':uid',  $usuario['id']);
        $s->bindValue(':tipo', $tipo);
        $s->bindValue(':fin',  $fechaFin);
        $s->bindValue(':peri', $planJSON['periodizacion'] ?? '');
        $s->execute();
        $planId = $pdo->lastInsertId();

        // ── NUEVO: INSERT ahora incluye dia_semana ─────────────────────────
        $stmtD = $pdo->prepare("
            INSERT INTO plan_detalle
                (plan_id, semana_numero, dia_numero, dia_semana, nombre_dia, ejercicio_id, orden, series, repeticiones, rir, descanso, nota_tecnica)
            VALUES
                (:plan_id, :semana, :dia_num, :dia_semana, :dia_nombre, :ej_id, :orden, :series, :reps, :rir, :descanso, :nota)
        ");

        foreach ($planJSON['semanas'] as $semana) {
            $semNum = (int)($semana['semana_numero'] ?? 1);
            foreach ($semana['dias'] as $dia) {
                $diaNum    = (int)($dia['dia_numero'] ?? 1);
                $diaNombre = $dia['dia_nombre'] ?? "Día {$diaNum}";

                // dia_semana: lo que devolvió la IA, con fallback al mapa
                $diaSemanaGuardar = isset($dia['dia_semana'])
                    ? (int)$dia['dia_semana']
                    : ($mapaDias[$diaNum] ?? ($diaNum - 1));

                $orden = 1;
                foreach ($dia['ejercicios'] as $ej) {
                    if (!in_array($ej['id'], $idsValidos)) continue;
                    $stmtD->bindValue(':plan_id',    $planId);
                    $stmtD->bindValue(':semana',     $semNum);
                    $stmtD->bindValue(':dia_num',    $diaNum);
                    $stmtD->bindValue(':dia_semana', $diaSemanaGuardar);
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

    echo json_encode([
        "plan_id"       => $planId,
        "tipo"          => $tipo,
        "dias_semana"   => $diasSemana,
        "periodizacion" => $planJSON['periodizacion'] ?? '',
        "semanas"       => $planJSON['semanas'],
        "perfil_usado"  => ["objetivo" => $perfil['objetivo'], "nivel" => $perfil['nivel'], "condiciones" => $condiciones]
    ], JSON_UNESCAPED_UNICODE);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(["error" => $e->getMessage()]);
}