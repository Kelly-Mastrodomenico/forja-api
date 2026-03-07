<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

define('DB_HOST', 'localhost');
define('DB_NAME', 'forja_db');
define('DB_USER', 'root');
define('DB_PASS', '');

function conectarDB() {
    try {
        $pdo = new PDO(
            "mysql:host=" . DB_HOST . ";dbname=" . DB_NAME . ";charset=utf8mb4",
            DB_USER,
            DB_PASS
        );
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
        return $pdo;
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(["error" => "Error de conexión: " . $e->getMessage()]);
        exit();
    }
}

function generarToken($usuario_id) {
    return bin2hex(random_bytes(32)) . '_' . $usuario_id . '_' . time();
}

function validarToken($pdo) {
    $headers = getallheaders();

    $auth = '';
    if (isset($headers['Authorization'])) {
        $auth = $headers['Authorization'];
    } elseif (isset($headers['authorization'])) {
        $auth = $headers['authorization'];
    } elseif (isset($_SERVER['HTTP_AUTHORIZATION'])) {
        $auth = $_SERVER['HTTP_AUTHORIZATION'];
    }

    if (empty($auth) || !str_starts_with($auth, 'Bearer ')) {
        http_response_code(401);
        echo json_encode(["error" => "Token requerido"]);
        exit();
    }

    $token = substr($auth, 7);

    $stmt = $pdo->prepare("SELECT id, nombre, email FROM usuarios WHERE token = :token");
    $stmt->bindValue(':token', $token);
    $stmt->execute();
    $usuario = $stmt->fetch();

    if (!$usuario) {
        http_response_code(401);
        echo json_encode(["error" => "Token inválido o expirado"]);
        exit();
    }

    return $usuario;
}