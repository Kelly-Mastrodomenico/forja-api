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

if (!isset($datos['imagen_base64']) || empty($datos['imagen_base64'])) {
    http_response_code(400);
    echo json_encode(["error" => "Imagen requerida"]);
    exit();
}

$imagenBase64 = $datos['imagen_base64'];
$tipoImagen = isset($datos['tipo_imagen']) ? $datos['tipo_imagen'] : 'image/jpeg';

$prompt = "Analiza esta imagen de una etiqueta nutricional de un producto alimenticio.
Extrae la información nutricional y devuelve ÚNICAMENTE un objeto JSON válido con esta estructura:

{
  \"nombre_producto\": null,
  \"marca\": null,
  \"porcion_gramos\": null,
  \"calorias_porcion\": null,
  \"calorias_100g\": null,
  \"proteinas_100g\": null,
  \"carbohidratos_100g\": null,
  \"azucares_100g\": null,
  \"grasas_100g\": null,
  \"grasas_saturadas_100g\": null,
  \"fibra_100g\": null,
  \"sodio_100g\": null,
  \"ingredientes_destacados\": null,
  \"alertas\": null
}

Reglas:
- Solo números para valores numéricos, sin unidades
- nombre_producto y marca como texto
- ingredientes_destacados: lista de ingredientes principales separados por coma
- alertas: si detectas ingredientes problemáticos como jarabe de maíz de alta fructosa, aceite hidrogenado, colorantes artificiales, conservantes, escríbelos aquí. Si no hay alertas pon null
- Si un valor no aparece en la etiqueta déjalo como null
- No agregues explicaciones, solo el JSON puro";

try {
    $apiKey = obtenerApiKey();
    $url = "https://api.groq.com/openai/v1/chat/completions";

    $mensajes = [
        [
            "role" => "user",
            "content" => [
                [
                    "type" => "image_url",
                    "image_url" => ["url" => "data:{$tipoImagen};base64,{$imagenBase64}"]
                ],
                ["type" => "text", "text" => $prompt]
            ]
        ]
    ];

    $datosPeticion = [
        "model" => "meta-llama/llama-4-scout-17b-16e-instruct",
        "messages" => $mensajes,
        "temperature" => 0.1,
        "max_tokens" => 1024
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
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    $errorCurl = curl_error($ch);
    curl_close($ch);

    if ($errorCurl) {
        http_response_code(500);
        echo json_encode(["error" => "Error de conexión: " . $errorCurl]);
        exit();
    }

    if ($httpCode == 429) {
        http_response_code(429);
        echo json_encode(["error" => "Límite de IA alcanzado. Intenta en unos segundos."]);
        exit();
    }

    $respuesta = json_decode($resultado, true);
    $textoIA = $respuesta['choices'][0]['message']['content'] ?? null;

    if (!$textoIA) {
        http_response_code(500);
        echo json_encode(["error" => "La IA no pudo procesar la imagen"]);
        exit();
    }

    $textoLimpio = preg_replace('/```json|```/i', '', $textoIA);
    $textoLimpio = trim($textoLimpio);
    $datosEtiqueta = json_decode($textoLimpio, true);

    if (!$datosEtiqueta) {
        http_response_code(500);
        echo json_encode(["error" => "No se pudieron extraer los datos", "raw" => $textoIA]);
        exit();
    }

    echo json_encode([
        "mensaje" => "Etiqueta analizada correctamente",
        "datos" => $datosEtiqueta
    ], JSON_UNESCAPED_UNICODE);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(["error" => $e->getMessage()]);
}