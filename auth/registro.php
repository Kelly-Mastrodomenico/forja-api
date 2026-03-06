<?php
require_once '../config/database.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(["error" => "Método no permitido"]);
    exit();
}

$datos = json_decode(file_get_contents("php://input"), true);

$obligatorios = ['nombre','email','password','sexo','fecha_nacimiento','altura_cm','objetivo','dias_entrenamiento','nivel'];
foreach ($obligatorios as $campo) {
    if (!isset($datos[$campo]) || $datos[$campo] === '') {
        http_response_code(400);
        echo json_encode(["error" => "El campo '$campo' es obligatorio"]);
        exit();
    }
}

if (!filter_var($datos['email'], FILTER_VALIDATE_EMAIL)) {
    http_response_code(400);
    echo json_encode(["error" => "Email no válido"]);
    exit();
}

if (strlen($datos['password']) < 6) {
    http_response_code(400);
    echo json_encode(["error" => "La contraseña debe tener al menos 6 caracteres"]);
    exit();
}

$sexosValidos = ['hombre','mujer','otro'];
if (!in_array($datos['sexo'], $sexosValidos)) {
    http_response_code(400);
    echo json_encode(["error" => "Sexo no válido"]);
    exit();
}

$objetivosValidos = ['perder_grasa','ganar_musculo','recomposicion','mantenimiento'];
if (!in_array($datos['objetivo'], $objetivosValidos)) {
    http_response_code(400);
    echo json_encode(["error" => "Objetivo no válido"]);
    exit();
}

$nivelesValidos = ['principiante','intermedio','avanzado'];
if (!in_array($datos['nivel'], $nivelesValidos)) {
    http_response_code(400);
    echo json_encode(["error" => "Nivel no válido"]);
    exit();
}

try {
    $pdo = conectarDB();

    $stmt = $pdo->prepare("SELECT id FROM usuarios WHERE email = :email");
    $stmt->bindValue(':email', strtolower(trim($datos['email'])));
    $stmt->execute();
    if ($stmt->fetch()) {
        http_response_code(409);
        echo json_encode(["error" => "Ya existe una cuenta con ese email"]);
        exit();
    }

    $passwordHash = password_hash($datos['password'], PASSWORD_BCRYPT);
    $token = generarToken(0);

    $stmt = $pdo->prepare("
        INSERT INTO usuarios
            (nombre, email, password, sexo, fecha_nacimiento, altura_cm,
             objetivo, dias_entrenamiento, nivel, tiene_ciclo,
             fecha_ultimo_ciclo, duracion_ciclo, token)
        VALUES
            (:nombre, :email, :password, :sexo, :fecha_nacimiento, :altura_cm,
             :objetivo, :dias_entrenamiento, :nivel, :tiene_ciclo,
             :fecha_ultimo_ciclo, :duracion_ciclo, :token)
    ");
    $stmt->bindValue(':nombre', trim($datos['nombre']));
    $stmt->bindValue(':email', strtolower(trim($datos['email'])));
    $stmt->bindValue(':password', $passwordHash);
    $stmt->bindValue(':sexo', $datos['sexo']);
    $stmt->bindValue(':fecha_nacimiento', $datos['fecha_nacimiento']);
    $stmt->bindValue(':altura_cm', (float)$datos['altura_cm']);
    $stmt->bindValue(':objetivo', $datos['objetivo']);
    $stmt->bindValue(':dias_entrenamiento', (int)$datos['dias_entrenamiento']);
    $stmt->bindValue(':nivel', $datos['nivel']);
    $stmt->bindValue(':tiene_ciclo', isset($datos['tiene_ciclo']) ? (bool)$datos['tiene_ciclo'] : false, PDO::PARAM_BOOL);
    $stmt->bindValue(':fecha_ultimo_ciclo', isset($datos['fecha_ultimo_ciclo']) ? $datos['fecha_ultimo_ciclo'] : null);
    $stmt->bindValue(':duracion_ciclo', isset($datos['duracion_ciclo']) ? (int)$datos['duracion_ciclo'] : 28);
    $stmt->bindValue(':token', $token);
    $stmt->execute();

    $nuevoId = $pdo->lastInsertId();

    // Guardar patologías si las envían
    if (!empty($datos['patologias']) && is_array($datos['patologias'])) {
        $patologiasValidas = ['sop','hipotiroidismo','resistencia_insulina','endometriosis','diabetes_tipo2','ninguna'];
        $stmtPat = $pdo->prepare("INSERT INTO usuario_patologias (usuario_id, patologia) VALUES (:uid, :pat)");
        foreach ($datos['patologias'] as $pat) {
            if (in_array($pat, $patologiasValidas)) {
                $stmtPat->bindValue(':uid', $nuevoId);
                $stmtPat->bindValue(':pat', $pat);
                $stmtPat->execute();
            }
        }
    }

    http_response_code(201);
    echo json_encode([
        "mensaje" => "Cuenta creada correctamente",
        "usuario_id" => $nuevoId,
        "nombre" => trim($datos['nombre']),
        "token" => $token
    ]);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["error" => "Error al registrar: " . $e->getMessage()]);
}