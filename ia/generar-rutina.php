<?php
require_once '../config/database.php';
require_once '../config/ia.php';

// Debug temporal
$headers = getallheaders();
error_log("Headers recibidos: " . json_encode($headers));
$auth = isset($headers['Authorization']) ? $headers['Authorization'] : 'NO ENCONTRADO';
error_log("Authorization: " . $auth);

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(["error" => "Método no permitido"]);
    exit();
}

$pdo = conectarDB();
$usuario = validarToken($pdo);

$datos = json_decode(file_get_contents("php://input"), true);

$tipoRutina = isset($datos['tipo']) ? $datos['tipo'] : 'semanal';
$tiposValidos = ['diaria', 'semanal', 'mensual'];
if (!in_array($tipoRutina, $tiposValidos)) {
    http_response_code(400);
    echo json_encode(["error" => "Tipo de rutina no válido"]);
    exit();
}

try {
    // Traer datos completos del usuario
    $stmt = $pdo->prepare("
        SELECT u.*, GROUP_CONCAT(p.patologia) as patologias
        FROM usuarios u
        LEFT JOIN usuario_patologias p ON p.usuario_id = u.id
        WHERE u.id = :id
        GROUP BY u.id
    ");
    $stmt->bindValue(':id', $usuario['id']);
    $stmt->execute();
    $datosUsuario = $stmt->fetch();

    // Traer última medida
    $stmtMedida = $pdo->prepare("
        SELECT * FROM medidas
        WHERE usuario_id = :id
        ORDER BY fecha DESC
        LIMIT 1
    ");
    $stmtMedida->bindValue(':id', $usuario['id']);
    $stmtMedida->execute();
    $ultimaMedida = $stmtMedida->fetch();

    // Calcular edad
    $fechaNac = new DateTime($datosUsuario['fecha_nacimiento']);
    $hoy = new DateTime();
    $edad = $fechaNac->diff($hoy)->y;

    // Alimentos favoritos del usuario
    $stmtAlimentos = $pdo->prepare("
        SELECT nombre, marca FROM alimentos
        WHERE usuario_id = :id
        ORDER BY id DESC LIMIT 20
    ");
    $stmtAlimentos->bindValue(':id', $usuario['id']);
    $stmtAlimentos->execute();
    $alimentos = $stmtAlimentos->fetchAll();
    $listadoAlimentos = implode(', ', array_map(fn($a) => $a['nombre'] . ($a['marca'] ? " ({$a['marca']})" : ''), $alimentos));

    // Construir el prompt
    $objetivo = str_replace('_', ' ', $datosUsuario['objetivo']);
    $patologias = $datosUsuario['patologias'] ?? 'ninguna';
    $tieneCiclo = $datosUsuario['tiene_ciclo'] ? 'Sí' : 'No';

    $medidas = '';
    if ($ultimaMedida) {
        $medidas = "
MEDIDAS CORPORALES ACTUALES:
- Peso: {$ultimaMedida['peso_kg']} kg
- Grasa corporal: {$ultimaMedida['grasa_corporal']}%
- Masa muscular: {$ultimaMedida['masa_muscular']} kg
- IMC: {$ultimaMedida['imc']}
- Cintura: {$ultimaMedida['cintura_cm']} cm
- Cadera: {$ultimaMedida['cadera_cm']} cm";
    }

    $alimentosTexto = $listadoAlimentos ? "ALIMENTOS HABITUALES DEL USUARIO: $listadoAlimentos" : '';

    $prompt = "
Actúa como un médico especialista en nutrición deportiva, recomposición corporal e hipertrofia y preparador físico profesional, usando exclusivamente evidencia científica actual (ISSN, ACSM, NSCA).

No quiero explicaciones teóricas largas. Quiero decisiones prácticas, estructuradas y justificadas brevemente.

DATOS PERSONALES:
- Nombre: {$datosUsuario['nombre']}
- Sexo: {$datosUsuario['sexo']}
- Edad: {$edad} años
- Altura: {$datosUsuario['altura_cm']} cm
- Nivel: {$datosUsuario['nivel']}
- Días de entrenamiento: {$datosUsuario['dias_entrenamiento']} días por semana
- Objetivo: {$objetivo}
- Patologías: {$patologias}
- Tiene ciclo menstrual: {$tieneCiclo}
{$medidas}
{$alimentosTexto}

Genera un plan {$tipoRutina} completo con este formato exacto:

## PLAN NUTRICIONAL
- Calorías totales y macros (proteínas/carbohidratos/grasas en gramos)
- Plan de comidas con cantidades exactas en gramos
- Timing nutricional (cuándo comer respecto al entreno)

## PLAN DE ENTRENAMIENTO
- Rutina completa para {$datosUsuario['dias_entrenamiento']} días
- Por cada ejercicio: series, repeticiones, RIR, descanso
- Orden de ejercicios por día

## PLAN DE CARDIO
- Tipo, duración e intensidad

## PROGRESIÓN
- Cómo progresar semana a semana

## INDICACIONES PRÁCTICAS
- 3 puntos clave para este usuario específico

Al final pídeme que te envíe: peso actualizado, medidas, rendimiento y sensaciones para continuar el seguimiento.
";

    $resultado = llamarIA($prompt);

    if (isset($resultado['error'])) {
        http_response_code(500);
        echo json_encode(["error" => $resultado['error']]);
        exit();
    }

    // Guardar la rutina en la base de datos
    $stmtGuardar = $pdo->prepare("
        INSERT INTO rutinas (usuario_id, tipo, contenido_json, prompt_usado)
        VALUES (:uid, :tipo, :contenido, :prompt)
    ");
    $stmtGuardar->bindValue(':uid', $usuario['id']);
    $stmtGuardar->bindValue(':tipo', $tipoRutina);
    $stmtGuardar->bindValue(':contenido', json_encode(['texto' => $resultado['respuesta']]));
    $stmtGuardar->bindValue(':prompt', $prompt);
    $stmtGuardar->execute();

    $rutinaId = $pdo->lastInsertId();

    echo json_encode([
        "rutina_id" => $rutinaId,
        "tipo" => $tipoRutina,
        "contenido" => $resultado['respuesta']
    ], JSON_UNESCAPED_UNICODE);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["error" => "Error de base de datos: " . $e->getMessage()]);
}