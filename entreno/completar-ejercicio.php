<?php
require_once '../config/database.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(["error" => "Método no permitido"]);
    exit();
}

$pdo = conectarDB();
$usuario = validarToken($pdo);
$datos = json_decode(file_get_contents("php://input"), true);

if (!isset($datos['nombre_ejercicio']) || !isset($datos['fecha'])) {
    http_response_code(400);
    echo json_encode(["error" => "Faltan datos"]);
    exit();
}

try {
    // Buscar si ya existe un log para hoy
    $stmt = $pdo->prepare("
        SELECT id FROM log_entreno
        WHERE usuario_id = :uid AND fecha = :fecha
        LIMIT 1
    ");
    $stmt->bindValue(':uid', $usuario['id']);
    $stmt->bindValue(':fecha', $datos['fecha']);
    $stmt->execute();
    $log = $stmt->fetch();

    if (!$log) {
        $stmtLog = $pdo->prepare("
            INSERT INTO log_entreno (usuario_id, fecha, notas)
            VALUES (:uid, :fecha, 'Entreno registrado desde app')
        ");
        $stmtLog->bindValue(':uid', $usuario['id']);
        $stmtLog->bindValue(':fecha', $datos['fecha']);
        $stmtLog->execute();
        $logId = $pdo->lastInsertId();
    } else {
        $logId = $log['id'];
    }

    // Verificar si el ejercicio ya estaba guardado
    $stmtBuscar = $pdo->prepare("
        SELECT id FROM ejercicios
        WHERE log_id = :log_id AND nombre = :nombre
        LIMIT 1
    ");
    $stmtBuscar->bindValue(':log_id', $logId);
    $stmtBuscar->bindValue(':nombre', $datos['nombre_ejercicio']);
    $stmtBuscar->execute();
    $ejercicioExistente = $stmtBuscar->fetch();

    if ($ejercicioExistente) {
        // Actualizar completado
        $stmtUpdate = $pdo->prepare("
            UPDATE ejercicios SET completado = :completado
            WHERE id = :id
        ");
        $stmtUpdate->bindValue(':completado', (int)$datos['completado'], PDO::PARAM_INT);
        $stmtUpdate->bindValue(':id', $ejercicioExistente['id']);
        $stmtUpdate->execute();
    } else {
        // Insertar nuevo
        $stmtEj = $pdo->prepare("
            INSERT INTO ejercicios (log_id, nombre, series, repeticiones, peso_kg, completado)
            VALUES (:log_id, :nombre, :series, :reps, :peso, :completado)
        ");
        $stmtEj->bindValue(':log_id', $logId);
        $stmtEj->bindValue(':nombre', $datos['nombre_ejercicio']);
        $stmtEj->bindValue(':series', isset($datos['series']) ? (int)$datos['series'] : null);
        $stmtEj->bindValue(':reps', isset($datos['repeticiones']) ? $datos['repeticiones'] : null);
        $stmtEj->bindValue(':peso', isset($datos['peso_kg']) ? (float)$datos['peso_kg'] : null);
        $stmtEj->bindValue(':completado', (int)$datos['completado'], PDO::PARAM_INT);
        $stmtEj->execute();
    }

    echo json_encode(["mensaje" => "Ejercicio guardado", "log_id" => $logId], JSON_UNESCAPED_UNICODE);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["error" => $e->getMessage()]);
}