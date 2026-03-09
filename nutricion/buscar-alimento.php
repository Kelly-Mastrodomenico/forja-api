<?php
require_once '../config/database.php';

$pdo     = conectarDB();
$usuario = validarToken($pdo);

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    http_response_code(405);
    echo json_encode(["error" => "Método no permitido"]);
    exit();
}

$q = isset($_GET['q']) ? trim($_GET['q']) : '';

if (strlen($q) < 2) {
    echo json_encode(["alimentos" => []]);
    exit();
}

try {
    $stmt = $pdo->prepare("
        SELECT id, nombre, marca, calorias_100g, proteinas_100g,
               carbohidratos_100g, grasas_100g
        FROM alimentos
        WHERE nombre LIKE :q OR marca LIKE :q
        ORDER BY nombre
        LIMIT 20
    ");
    $stmt->bindValue(':q', '%' . $q . '%');
    $stmt->execute();
    $alimentos = $stmt->fetchAll();

    echo json_encode(["alimentos" => $alimentos], JSON_UNESCAPED_UNICODE);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["error" => $e->getMessage()]);
}