<?php
require_once '../config/database.php';

$pdo     = conectarDB();
$usuario = validarToken($pdo);

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(["error" => "Método no permitido"]);
    exit;
}

$datos = json_decode(file_get_contents("php://input"), true);

if (!isset($datos['ejercicio']) || empty(trim($datos['ejercicio']))) {
    http_response_code(400);
    echo json_encode(["error" => "Falta el nombre del ejercicio"]);
    exit;
}

try {
    // Crear tabla si no existe
    $pdo->exec("
        CREATE TABLE IF NOT EXISTS reportes_dolor (
            id            INT AUTO_INCREMENT PRIMARY KEY,
            usuario_id    INT NOT NULL,
            ejercicio     VARCHAR(200) NOT NULL,
            nota          TEXT,
            fecha         DATE NOT NULL,
            created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
        )
    ");

    $stmt = $pdo->prepare("
        INSERT INTO reportes_dolor (usuario_id, ejercicio, nota, fecha)
        VALUES (:uid, :ejercicio, :nota, :fecha)
    ");
    $stmt->bindValue(':uid',      $usuario['id']);
    $stmt->bindValue(':ejercicio', trim($datos['ejercicio']));
    $stmt->bindValue(':nota',      isset($datos['nota']) ? trim($datos['nota']) : null);
    $stmt->bindValue(':fecha',     $datos['fecha'] ?? date('Y-m-d'));
    $stmt->execute();

    echo json_encode([
        "mensaje" => "Dolor registrado correctamente",
        "id"      => $pdo->lastInsertId()
    ], JSON_UNESCAPED_UNICODE);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["error" => $e->getMessage()]);
}