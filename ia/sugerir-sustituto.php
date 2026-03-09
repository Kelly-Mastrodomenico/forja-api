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

// Validar que lleguen los datos necesarios
if (!isset($datos['ejercicio']) || empty(trim($datos['ejercicio']))) {
    http_response_code(400);
    echo json_encode(["error" => "El campo 'ejercicio' es obligatorio"]);
    exit();
}

$ejercicio      = trim($datos['ejercicio']);
$grupoMuscular  = isset($datos['grupo_muscular']) ? trim($datos['grupo_muscular']) : 'no especificado';

try {
    // Obtener patologías del usuario para sugerir un sustituto seguro
    $stmt = $pdo->prepare("
        SELECT GROUP_CONCAT(p.patologia) as condiciones
        FROM usuario_patologias p
        WHERE p.usuario_id = :id
    ");
    $stmt->bindValue(':id', $usuario['id']);
    $stmt->execute();
    $resultado    = $stmt->fetch();
    $condiciones  = ($resultado['condiciones'] && $resultado['condiciones'] !== 'ninguna')
        ? $resultado['condiciones']
        : 'ninguna';

    $prompt = "Eres un entrenador personal experto con conocimiento clínico.

El usuario quiere cambiar el ejercicio: \"{$ejercicio}\" (grupo muscular: {$grupoMuscular}).

Condiciones de salud del usuario: {$condiciones}

Proporciona UN SOLO ejercicio sustituto que:
1. Trabaje el mismo grupo muscular ({$grupoMuscular})
2. Sea seguro para las condiciones de salud listadas
3. Sea de dificultad similar
4. Pueda hacerse en un gimnasio estándar

Responde ÚNICAMENTE con el nombre del ejercicio sustituto en español, sin explicaciones, sin puntos, sin texto adicional.
Ejemplo de respuesta correcta: Press en máquina pecho
Ejemplo incorrecto: Te recomiendo hacer Press en máquina pecho porque...";

    $apiKey = obtenerApiKey();
    $url    = "https://api.groq.com/openai/v1/chat/completions";

    $datosPeticion = [
        "model"    => "llama-3.3-70b-versatile",
        "messages" => [
            [
                "role"    => "system",
                "content" => "Eres un entrenador experto. Respondes ÚNICAMENTE con el nombre del ejercicio sustituto, sin explicaciones ni texto adicional."
            ],
            [
                "role"    => "user",
                "content" => $prompt
            ]
        ],
        "temperature" => 0.5,
        "max_tokens"  => 50  // Solo necesita devolver un nombre corto
    ];

    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($datosPeticion));
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        'Content-Type: application/json',
        'Authorization: Bearer ' . $apiKey
    ]);
    curl_setopt($ch, CURLOPT_TIMEOUT, 30);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);

    $respuestaCurl = curl_exec($ch);
    $errorCurl     = curl_error($ch);
    $httpCode      = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);

    if ($errorCurl) {
        http_response_code(500);
        echo json_encode(["error" => "Error de conexión: " . $errorCurl]);
        exit();
    }

    if ($httpCode === 429) {
        http_response_code(429);
        echo json_encode(["error" => "Límite de IA alcanzado. Intenta en unos segundos."]);
        exit();
    }

    $respuestaJSON = json_decode($respuestaCurl, true);
    $textoIA       = $respuestaJSON['choices'][0]['message']['content'] ?? null;

    if (!$textoIA) {
        http_response_code(500);
        echo json_encode(["error" => "La IA no devolvió respuesta"]);
        exit();
    }

    // Limpiar la respuesta — quitar puntos, saltos de línea, comillas
    $sustituto = trim($textoIA);
    $sustituto = str_replace(['"', "'", "\n", "\r", "."], '', $sustituto);
    $sustituto = trim($sustituto);

    echo json_encode([
        "sustituto"        => $sustituto,
        "ejercicio_original" => $ejercicio,
        "grupo_muscular"   => $grupoMuscular,
        "condiciones_consideradas" => $condiciones
    ], JSON_UNESCAPED_UNICODE);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(["error" => $e->getMessage()]);
}