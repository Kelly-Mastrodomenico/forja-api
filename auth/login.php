<?php
require_once '../config/database.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(["error" => "Método no permitido"]);
    exit();
}

$datos = json_decode(file_get_contents("php://input"), true);

if (!isset($datos['email']) || empty($datos['email'])) {
    http_response_code(400);
    echo json_encode(["error" => "El email es obligatorio"]);
    exit();
}

if (!isset($datos['password']) || empty($datos['password'])) {
    http_response_code(400);
    echo json_encode(["error" => "La contraseña es obligatoria"]);
    exit();
}

try {
    $pdo = conectarDB();

    $stmt = $pdo->prepare("
        SELECT id, nombre, email, password, sexo, fecha_nacimiento,
               altura_cm, peso_actual, objetivo, dias_entrenamiento,
               nivel, tiene_ciclo, fecha_ultimo_ciclo, duracion_ciclo
        FROM usuarios
        WHERE email = :email
    ");
    $stmt->bindValue(':email', strtolower(trim($datos['email'])));
    $stmt->execute();
    $usuario = $stmt->fetch();

    if (!$usuario || !password_verify($datos['password'], $usuario['password'])) {
        http_response_code(401);
        echo json_encode(["error" => "Email o contraseña incorrectos"]);
        exit();
    }

    // Renovar token en cada login
    $nuevoToken = generarToken($usuario['id']);
    $stmtToken = $pdo->prepare("UPDATE usuarios SET token = :token WHERE id = :id");
    $stmtToken->bindValue(':token', $nuevoToken);
    $stmtToken->bindValue(':id', $usuario['id']);
    $stmtToken->execute();

    unset($usuario['password']);
    $usuario['token'] = $nuevoToken;

    // Traer patologías
    $stmtPat = $pdo->prepare("SELECT patologia FROM usuario_patologias WHERE usuario_id = :uid");
    $stmtPat->bindValue(':uid', $usuario['id']);
    $stmtPat->execute();
    $usuario['patologias'] = array_column($stmtPat->fetchAll(), 'patologia');

    echo json_encode([
        "mensaje" => "Login exitoso",
        "usuario" => $usuario
    ]);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["error" => "Error al iniciar sesión: " . $e->getMessage()]);
}