<?php
require_once '../config/database.php';
require_once '../config/ia.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(["error" => "Método no permitido"]);
    exit();
}

$pdo = conectarDB();
$usuario = validarToken($pdo);
$datos = json_decode(file_get_contents("php://input"), true);
$tipo = isset($datos['tipo']) ? $datos['tipo'] : 'semanal';

try {
    // Obtener perfil completo
    $stmt = $pdo->prepare("
        SELECT u.nombre, u.sexo, u.fecha_nacimiento, u.altura_cm,
               u.peso_actual, u.peso_objetivo, u.grasa_objetivo,
               u.objetivo, u.dias_entrenamiento, u.nivel,
               u.tiene_ciclo, GROUP_CONCAT(p.patologia) as condiciones
        FROM usuarios u
        LEFT JOIN usuario_patologias p ON p.usuario_id = u.id
        WHERE u.id = :id
        GROUP BY u.id
    ");
    $stmt->bindValue(':id', $usuario['id']);
    $stmt->execute();
    $perfil = $stmt->fetch();

    // Calcular edad
    $edad = date_diff(date_create($perfil['fecha_nacimiento']), date_create('today'))->y;

    $condiciones = $perfil['condiciones'] && $perfil['condiciones'] !== 'ninguna'
        ? $perfil['condiciones']
        : 'ninguna';

    $pesoObjetivo = $perfil['peso_objetivo'] ? "Peso objetivo: {$perfil['peso_objetivo']} kg." : '';
    $grasaObjetivo = $perfil['grasa_objetivo'] ? "Grasa corporal objetivo: {$perfil['grasa_objetivo']}%." : '';

$prompt = "Actúa como un Sistema de Inteligencia Artificial de Grado Clínico especializado en Nutrición Deportiva y Ciencias del Ejercicio (basado en estándares ISSN, ACSM y NSCA).

Tu objetivo es generar una planificación de entrenamiento para:
- Usuario: {$perfil['nombre']} ({$perfil['sexo']}, {$edad} años)
- Antropometría: {$perfil['altura_cm']} cm, {$perfil['peso_actual']} kg
- Objetivo: {$perfil['objetivo']}. {$pesoObjetivo} {$grasaObjetivo}
- Disponibilidad: {$perfil['dias_entrenamiento']} días/semana. Nivel: {$perfil['nivel']}
- Condiciones de salud: {$condiciones}
- Ciclo menstrual activo: " . ($perfil['tiene_ciclo'] ? 'Sí' : 'No') . "

REGLAS DE SEGURIDAD BIOMECÁNICA (OBLIGATORIO):
- dolor_lumbar: priorizar estabilización de core, evitar cargas axiales extremas. Sustituir sentadilla con barra por Goblet Squat o prensa.
- dolor_rodilla: limitar rango de movimiento, priorizar cadena posterior, evitar extensiones de rodilla con carga alta.
- lesion_hombro: evitar press por encima de la cabeza, sustituir por variantes neutras o de empuje horizontal.
- tendinitis: reducir volumen en ejercicios de la zona afectada, priorizar trabajo excéntrico.
- Si tiene ciclo menstrual activo y es fase lútea probable (días 15-28): reducir RPE objetivo en 1-2 puntos.

Responde ÚNICAMENTE con JSON puro válido, sin texto antes ni después, sin markdown:

// Dentro de $prompt, reemplaza el ejemplo de ejercicio por este:
{
  \"rutina\": [
    {
      \"dia\": 1,
      \"nombre\": \"Pecho y Tríceps\",
      \"grupo_muscular\": \"pecho, triceps\",
      \"justificacion_clinica\": \"Nota breve sobre ajustes\",
      \"ejercicios\": [
        {
          \"nombre_espanol\": \"Press de banca\",
          \"nombre_ingles\": \"barbell bench press\",
          \"series\": 4,
          \"repeticiones\": \"8-10\",
          \"rir\": 2,
          \"descanso\": \"90s\",
          \"sustituto_lesion\": \"Press en máquina si hay dolor de hombro\",
          \"tecnica_clave\": \"Tempo 3-0-2, escápulas retraídas\"
        }
      ]
    }
  ]
}

Genera exactamente {$perfil['dias_entrenamiento']} días. Cada día entre 4 y 6 ejercicios. Solo JSON puro.";

    $apiKey = obtenerApiKey();
    $url = "https://api.groq.com/openai/v1/chat/completions";

    $datosPeticion = [
        "model" => "llama-3.3-70b-versatile",
        "messages" => [
            ["role" => "system", "content" => "Eres un entrenador experto. Respondes ÚNICAMENTE con JSON válido, sin texto adicional, sin markdown, sin explicaciones."],
            ["role" => "user", "content" => $prompt]
        ],
        "temperature" => 0.7,
        "max_tokens" => 3000
    ];

    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($datosPeticion));
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        'Content-Type: application/json',
        'Authorization: Bearer ' . $apiKey
    ]);
    curl_setopt($ch, CURLOPT_TIMEOUT, 60);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);

    $resultado = curl_exec($ch);
    $errorCurl = curl_error($ch);
    curl_close($ch);

    if ($errorCurl) {
        http_response_code(500);
        echo json_encode(["error" => "Error de conexión: " . $errorCurl]);
        exit();
    }

    $respuesta = json_decode($resultado, true);
    $textoIA = $respuesta['choices'][0]['message']['content'] ?? '';

    // Extraer JSON de forma más robusta
    $inicioPos = strpos($textoIA, '{');
    $finPos = strrpos($textoIA, '}');
    if ($inicioPos !== false && $finPos !== false) {
        $textoLimpio = substr($textoIA, $inicioPos, $finPos - $inicioPos + 1);
    } else {
        $textoLimpio = $textoIA;
    }

    $rutinaJSON = json_decode($textoLimpio, true);

    if (!$rutinaJSON || !isset($rutinaJSON['rutina'])) {
        http_response_code(500);
        echo json_encode(["error" => "La IA no devolvió el formato esperado", "raw" => $textoIA]);
        exit();
    }

    echo json_encode([
        "rutina" => $rutinaJSON['rutina'],
        "perfil_usado" => [
            "objetivo" => $perfil['objetivo'],
            "nivel" => $perfil['nivel'],
            "condiciones" => $condiciones
        ]
    ], JSON_UNESCAPED_UNICODE);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(["error" => $e->getMessage()]);
}