<?php
require_once '../config/database.php';

$pdo = conectarDB();
$usuario = validarToken($pdo);

$datos = json_decode(file_get_contents("php://input"), true);

if (!isset($datos['nombre_ingles']) || empty($datos['nombre_ingles'])) {
    http_response_code(400);
    echo json_encode(["error" => "nombre_ingles requerido"]);
    exit();
}

$nombreIngles = strtolower(trim($datos['nombre_ingles']));
$nombreEspanol = isset($datos['nombre_espanol']) ? $datos['nombre_espanol'] : null;

try {
    // Buscar en caché primero
    $stmt = $pdo->prepare("SELECT gif_url FROM ejercicios_imagenes WHERE nombre_ingles = :nombre LIMIT 1");
    $stmt->bindValue(':nombre', $nombreIngles);
    $stmt->execute();
    $cache = $stmt->fetch();

    if ($cache && $cache['gif_url']) {
        echo json_encode(["gif_url" => $cache['gif_url'], "fuente" => "cache"]);
        exit();
    }

    // No está en caché — buscar en ExerciseDB
    $query = rawurlencode($nombreIngles);
    $url = "https://exercisedb-api.vercel.app/api/v1/exercises/search?query={$query}&limit=1";

    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_TIMEOUT, 10);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($ch, CURLOPT_HTTPHEADER, ['Accept: application/json']);
    $resultado = curl_exec($ch);
    $errorCurl = curl_error($ch);
    curl_close($ch);

    if ($errorCurl) {
        echo json_encode(["gif_url" => null, "error" => "Sin conexión a ExerciseDB"]);
        exit();
    }

    $datos_api = json_decode($resultado, true);
    $gifUrl = $datos_api['exercises'][0]['gifUrl'] ?? null;

    // Guardar en caché aunque sea null para no repetir llamadas fallidas
    $stmtInsert = $pdo->prepare("
        INSERT INTO ejercicios_imagenes (nombre_ingles, nombre_espanol, gif_url)
        VALUES (:ingles, :espanol, :gif)
        ON DUPLICATE KEY UPDATE gif_url = :gif
    ");
    $stmtInsert->bindValue(':ingles', $nombreIngles);
    $stmtInsert->bindValue(':espanol', $nombreEspanol);
    $stmtInsert->bindValue(':gif', $gifUrl);
    $stmtInsert->execute();

    echo json_encode(["gif_url" => $gifUrl, "fuente" => "api"]);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["error" => $e->getMessage()]);
}