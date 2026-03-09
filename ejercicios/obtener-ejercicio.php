<?php
require_once '../config/database.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    http_response_code(405);
    echo json_encode(["error" => "Método no permitido"]);
    exit();
}

$pdo     = conectarDB();
$usuario = validarToken($pdo); // Solo usuarios autenticados

$id = isset($_GET['id']) ? trim($_GET['id']) : '';

if (empty($id)) {
    http_response_code(400);
    echo json_encode(["error" => "Falta el parámetro id"]);
    exit();
}

try {
    $stmt = $pdo->prepare("
        SELECT
            e.id,
            e.nombre,
            e.categoria,
            e.enfoque_muscular,
            e.riesgo,
            e.instrucciones,
            e.video_url,
            e.poster_url,
            e.sustitucion_id,
            s.nombre AS sustitucion_nombre
        FROM ejercicios e
        LEFT JOIN ejercicios s ON e.sustitucion_id = s.id
        WHERE e.id = :id
    ");
    $stmt->bindValue(':id', $id);
    $stmt->execute();
    $ejercicio = $stmt->fetch();

    if (!$ejercicio) {
        http_response_code(404);
        echo json_encode(["error" => "Ejercicio no encontrado"]);
        exit();
    }

    echo json_encode($ejercicio, JSON_UNESCAPED_UNICODE);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(["error" => $e->getMessage()]);
}