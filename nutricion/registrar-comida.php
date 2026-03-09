<?php
require_once '../config/database.php';

$pdo     = conectarDB();
$usuario = validarToken($pdo);

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(["error" => "Método no permitido"]);
    exit();
}

$datos = json_decode(file_get_contents("php://input"), true);

$momentosValidos = ['desayuno','media_manana','almuerzo','merienda','pre_entreno','post_entreno','cena'];

if (!isset($datos['alimento_id']) || !isset($datos['cantidad_gramos']) || !isset($datos['momento'])) {
    http_response_code(400);
    echo json_encode(["error" => "Faltan campos requeridos: alimento_id, cantidad_gramos, momento"]);
    exit();
}

if (!in_array($datos['momento'], $momentosValidos)) {
    http_response_code(400);
    echo json_encode(["error" => "Momento inválido"]);
    exit();
}

$cantidad = (float)$datos['cantidad_gramos'];
if ($cantidad <= 0 || $cantidad > 5000) {
    http_response_code(400);
    echo json_encode(["error" => "Cantidad inválida (debe ser entre 1 y 5000 gramos)"]);
    exit();
}

$fecha = isset($datos['fecha']) ? $datos['fecha'] : date('Y-m-d');

try {
    // Verificar que el alimento existe
    $stmtCheck = $pdo->prepare("SELECT id FROM alimentos WHERE id = :id");
    $stmtCheck->bindValue(':id', (int)$datos['alimento_id']);
    $stmtCheck->execute();
    if (!$stmtCheck->fetch()) {
        http_response_code(404);
        echo json_encode(["error" => "Alimento no encontrado"]);
        exit();
    }

    $stmt = $pdo->prepare("
        INSERT INTO registro_comidas (usuario_id, alimento_id, cantidad_gramos, momento, fecha)
        VALUES (:uid, :alimento_id, :cantidad, :momento, :fecha)
    ");
    $stmt->bindValue(':uid',        $usuario['id']);
    $stmt->bindValue(':alimento_id',(int)$datos['alimento_id']);
    $stmt->bindValue(':cantidad',   $cantidad);
    $stmt->bindValue(':momento',    $datos['momento']);
    $stmt->bindValue(':fecha',      $fecha);
    $stmt->execute();

    echo json_encode([
        "mensaje" => "Comida registrada correctamente",
        "id"      => $pdo->lastInsertId()
    ], JSON_UNESCAPED_UNICODE);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["error" => $e->getMessage()]);
}