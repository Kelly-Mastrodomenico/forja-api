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

if (!isset($datos['nombre']) || empty(trim($datos['nombre']))) {
    http_response_code(400);
    echo json_encode(["error" => "El nombre del alimento es requerido"]);
    exit();
}

// Validar que calorias_100g tenga sentido
$calorias = isset($datos['calorias_100g']) ? (float)$datos['calorias_100g'] : null;
if ($calorias !== null && ($calorias < 0 || $calorias > 900)) {
    http_response_code(400);
    echo json_encode(["error" => "Valor de calorías inválido"]);
    exit();
}

try {
    // Verificar si ya existe un alimento con el mismo nombre y marca
    $stmtCheck = $pdo->prepare("
        SELECT id FROM alimentos
        WHERE nombre = :nombre AND (marca = :marca OR (marca IS NULL AND :marca2 IS NULL))
        LIMIT 1
    ");
    $stmtCheck->bindValue(':nombre', trim($datos['nombre']));
    $stmtCheck->bindValue(':marca',  isset($datos['marca']) ? trim($datos['marca']) : null);
    $stmtCheck->bindValue(':marca2', isset($datos['marca']) ? trim($datos['marca']) : null);
    $stmtCheck->execute();

    if ($stmtCheck->fetch()) {
        // Ya existe — devolver OK igual para no bloquear el flujo
        echo json_encode([
            "mensaje"   => "Este alimento ya existe en la biblioteca",
            "duplicado" => true
        ], JSON_UNESCAPED_UNICODE);
        exit();
    }

    $stmt = $pdo->prepare("
        INSERT INTO alimentos
            (nombre, marca, calorias_100g, proteinas_100g, carbohidratos_100g,
             azucares_100g, grasas_100g, grasas_saturadas_100g, fibra_100g, sodio_100g)
        VALUES
            (:nombre, :marca, :calorias, :proteinas, :carbohidratos,
             :azucares, :grasas, :grasas_sat, :fibra, :sodio)
    ");

    $stmt->bindValue(':nombre',      trim($datos['nombre']));
    $stmt->bindValue(':marca',       isset($datos['marca']) && $datos['marca'] ? trim($datos['marca']) : null);
    $stmt->bindValue(':calorias',    $calorias);
    $stmt->bindValue(':proteinas',   isset($datos['proteinas_100g'])       ? (float)$datos['proteinas_100g']        : null);
    $stmt->bindValue(':carbohidratos',isset($datos['carbohidratos_100g'])  ? (float)$datos['carbohidratos_100g']    : null);
    $stmt->bindValue(':azucares',    isset($datos['azucares_100g'])        ? (float)$datos['azucares_100g']         : null);
    $stmt->bindValue(':grasas',      isset($datos['grasas_100g'])          ? (float)$datos['grasas_100g']           : null);
    $stmt->bindValue(':grasas_sat',  isset($datos['grasas_saturadas_100g'])? (float)$datos['grasas_saturadas_100g'] : null);
    $stmt->bindValue(':fibra',       isset($datos['fibra_100g'])           ? (float)$datos['fibra_100g']            : null);
    $stmt->bindValue(':sodio',       isset($datos['sodio_100g'])           ? (float)$datos['sodio_100g']            : null);
    $stmt->execute();

    echo json_encode([
        "mensaje" => "Alimento guardado correctamente",
        "id"      => $pdo->lastInsertId()
    ], JSON_UNESCAPED_UNICODE);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["error" => $e->getMessage()]);
}