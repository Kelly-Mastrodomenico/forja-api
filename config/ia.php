<?php
function obtenerApiKey() {
    $lineas = file(__DIR__ . '/../.env', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
    foreach ($lineas as $linea) {
        if (str_starts_with($linea, 'GROQ_API_KEY=')) {
            return trim(substr($linea, strlen('GROQ_API_KEY=')));
        }
    }
    return null;
}

function llamarIA($prompt) {
    $apiKey = obtenerApiKey();

    if (!$apiKey) {
        return ["error" => "API key no configurada"];
    }

    $url = "https://api.groq.com/openai/v1/chat/completions";

    $datos = [
        "model" => "llama-3.3-70b-versatile",
        "messages" => [
            [
                "role" => "system",
                "content" => "Eres un entrenador personal y nutricionista deportivo experto. Respondes siempre en español con planes detallados, prácticos y basados en evidencia científica."
            ],
            [
                "role" => "user",
                "content" => $prompt
            ]
        ],
        "temperature" => 0.7,
        "max_tokens" => 8192
    ];

    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($datos));
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
        return ["error" => "Error de conexión: " . $errorCurl];
    }

    // Manejo de rate limit
    if ($httpCode == 429) {
        return ["error" => "Límite de IA alcanzado. Intenta de nuevo en unos segundos."];
    }

    $respuesta = json_decode($resultado, true);
    $texto = $respuesta['choices'][0]['message']['content'] ?? null;

    if (!$texto) {
        return ["error" => "Sin respuesta", "raw" => $respuesta];
    }

    return ["respuesta" => $texto];
}