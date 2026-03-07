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

$camposRequeridos = ['nombre', 'cantidad_gramos', 'momento'];
foreach ($camposRequeridos as $campo) {
    if (!isset($datos[$campo]) || $datos[$campo] === '') {
        http_response_code(400);
        echo json_encode(["error" => "El campo '$campo' es obligatorio"]);
        exit();
    }
}

$momentosValidos = ['desayuno','media_manana','almuerzo','merienda','cena','pre_entreno','post_entreno'];
if (!in_array($datos['momento'], $momentosValidos)) {
    http_response_code(400);
    echo json_encode(["error" => "Momento no válido"]);
    exit();
}

try {
    // Buscar si el alimento ya existe para este usuario
    $stmt = $pdo->prepare("
        SELECT id FROM alimentos
        WHERE nombre = :nombre AND (usuario_id = :uid OR usuario_id IS NULL)
        LIMIT 1
    ");
    $stmt->bindValue(':nombre', trim($datos['nombre']));
    $stmt->bindValue(':uid', $usuario['id']);
    $stmt->execute();
    $alimentoExistente = $stmt->fetch();

    if ($alimentoExistente) {
        $alimentoId = $alimentoExistente['id'];
    } else {
        // Crear el alimento nuevo
        $stmtInsert = $pdo->prepare("
            INSERT INTO alimentos
                (usuario_id, nombre, marca, calorias_100g, proteinas_100g,
                 carbohidratos_100g, grasas_100g, fibra_100g, es_escaneado)
            VALUES
                (:uid, :nombre, :marca, :calorias, :proteinas,
                 :carbohidratos, :grasas, :fibra, :escaneado)
        ");
        $stmtInsert->bindValue(':uid', $usuario['id']);
        $stmtInsert->bindValue(':nombre', trim($datos['nombre']));
        $stmtInsert->bindValue(':marca', isset($datos['marca']) ? $datos['marca'] : null);
        $stmtInsert->bindValue(':calorias', isset($datos['calorias_100g']) ? (float)$datos['calorias_100g'] : null);
        $stmtInsert->bindValue(':proteinas', isset($datos['proteinas_100g']) ? (float)$datos['proteinas_100g'] : null);
        $stmtInsert->bindValue(':carbohidratos', isset($datos['carbohidratos_100g']) ? (float)$datos['carbohidratos_100g'] : null);
        $stmtInsert->bindValue(':grasas', isset($datos['grasas_100g']) ? (float)$datos['grasas_100g'] : null);
        $stmtInsert->bindValue(':fibra', isset($datos['fibra_100g']) ? (float)$datos['fibra_100g'] : null);
        $stmtInsert->bindValue(':escaneado', isset($datos['es_escaneado']) ? 1 : 0);
        $stmtInsert->execute();
        $alimentoId = $pdo->lastInsertId();
    }

    // Registrar la comida del día
    $fecha = isset($datos['fecha']) ? $datos['fecha'] : date('Y-m-d');
    $stmtComida = $pdo->prepare("
        INSERT INTO registro_comidas (usuario_id, alimento_id, fecha, momento, cantidad_gramos)
        VALUES (:uid, :alimento_id, :fecha, :momento, :cantidad)
    ");
    $stmtComida->bindValue(':uid', $usuario['id']);
    $stmtComida->bindValue(':alimento_id', $alimentoId);
    $stmtComida->bindValue(':fecha', $fecha);
    $stmtComida->bindValue(':momento', $datos['momento']);
    $stmtComida->bindValue(':cantidad', (float)$datos['cantidad_gramos']);
    $stmtComida->execute();

    echo json_encode([
        "mensaje" => "Comida registrada correctamente",
        "alimento_id" => $alimentoId,
        "fecha" => $fecha
    ], JSON_UNESCAPED_UNICODE);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["error" => $e->getMessage()]);
}