<?php
require_once '../config/database.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(["error" => "Método no permitido"]);
    exit();
}

$pdo     = conectarDB();
$usuario = validarToken($pdo);
$datos   = json_decode(file_get_contents("php://input"), true);

// Validar peso
if (!isset($datos['peso_actual']) || !is_numeric($datos['peso_actual'])) {
    http_response_code(400);
    echo json_encode(["error" => "El peso debe ser un número válido"]);
    exit();
}

$peso = (float)$datos['peso_actual'];

if ($peso < 20 || $peso > 300) {
    http_response_code(400);
    echo json_encode(["error" => "El peso debe estar entre 20 y 300 kg"]);
    exit();
}

$fecha = isset($datos['fecha']) ? $datos['fecha'] : date('Y-m-d');

try {
    // 1. Actualizar peso_actual en tabla usuarios
    $stmtUsuario = $pdo->prepare("
        UPDATE usuarios SET peso_actual = :peso WHERE id = :id
    ");
    $stmtUsuario->bindValue(':peso', $peso);
    $stmtUsuario->bindValue(':id',   $usuario['id']);
    $stmtUsuario->execute();

    // 2. Guardar en tabla medidas para que aparezca en el historial de gráficas
    // Solo guardamos peso_kg — los demás campos quedan null (no tenemos báscula)
    // Si ya hay una medida manual del mismo día, actualizarla en vez de duplicar
    $stmtExiste = $pdo->prepare("
        SELECT id FROM medidas
        WHERE usuario_id = :uid AND fecha = :fecha AND fuente = 'manual'
    ");
    $stmtExiste->bindValue(':uid',   $usuario['id']);
    $stmtExiste->bindValue(':fecha', $fecha);
    $stmtExiste->execute();
    $medidaExistente = $stmtExiste->fetch();

    if ($medidaExistente) {
        // Actualizar la que ya existe ese día
        $stmtMedida = $pdo->prepare("
            UPDATE medidas SET peso_kg = :peso WHERE id = :id
        ");
        $stmtMedida->bindValue(':peso', $peso);
        $stmtMedida->bindValue(':id',   $medidaExistente['id']);
        $stmtMedida->execute();
    } else {
        // Insertar nueva medida
        $stmtMedida = $pdo->prepare("
            INSERT INTO medidas (usuario_id, peso_kg, fecha, fuente)
            VALUES (:uid, :peso, :fecha, 'manual')
        ");
        $stmtMedida->bindValue(':uid',   $usuario['id']);
        $stmtMedida->bindValue(':peso',  $peso);
        $stmtMedida->bindValue(':fecha', $fecha);
        $stmtMedida->execute();
    }

    echo json_encode([
        "mensaje"     => "Peso actualizado correctamente",
        "peso_actual" => $peso,
        "fecha"       => $fecha
    ], JSON_UNESCAPED_UNICODE);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["error" => $e->getMessage()]);
}