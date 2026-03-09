<?php
require_once '../config/database.php';

$pdo     = conectarDB();
$usuario = validarToken($pdo);

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(["error" => "Método no permitido"]);
    exit;
}

try {
    $datos = json_decode(file_get_contents("php://input"), true);

    if (!isset($datos['imagen_base64']) || empty($datos['imagen_base64'])) {
        http_response_code(400);
        echo json_encode(["error" => "No se recibió imagen"]);
        exit;
    }

    $base64 = $datos['imagen_base64'];

    // Detectar tipo de imagen desde el prefijo data:image/...
    if (preg_match('/^data:image\/(\w+);base64,/', $base64, $matches)) {
        $extension = strtolower($matches[1]);
        $base64    = substr($base64, strpos($base64, ',') + 1);
    } else {
        $extension = 'jpg';
    }

    $extensionesPermitidas = ['jpg', 'jpeg', 'png', 'webp'];
    if (!in_array($extension, $extensionesPermitidas)) {
        http_response_code(400);
        echo json_encode(["error" => "Formato no permitido. Usa JPG, PNG o WebP."]);
        exit;
    }

    $imageData = base64_decode($base64);
    if ($imageData === false) {
        http_response_code(400);
        echo json_encode(["error" => "Imagen base64 inválida"]);
        exit;
    }

    // Validar tamaño — máx 5MB
    if (strlen($imageData) > 5 * 1024 * 1024) {
        http_response_code(400);
        echo json_encode(["error" => "La imagen supera el límite de 5MB"]);
        exit;
    }

    // Carpeta de destino
    $carpeta = __DIR__ . '/../../uploads/fotos_perfil/';
    if (!is_dir($carpeta)) {
        mkdir($carpeta, 0755, true);
    }

    // Borrar foto anterior si existe
    $stmtActual = $pdo->prepare("SELECT foto_perfil FROM usuarios WHERE id = :id");
    $stmtActual->bindValue(':id', $usuario['id']);
    $stmtActual->execute();
    $fotoActual = $stmtActual->fetchColumn();

    if ($fotoActual && file_exists(__DIR__ . '/../../' . $fotoActual)) {
        unlink(__DIR__ . '/../../' . $fotoActual);
    }

    // Nombre único para la nueva foto
    $nombreArchivo = 'usuario_' . $usuario['id'] . '_' . time() . '.' . $extension;
    $rutaCompleta  = $carpeta . $nombreArchivo;
    $rutaRelativa  = 'uploads/fotos_perfil/' . $nombreArchivo;

    if (file_put_contents($rutaCompleta, $imageData) === false) {
        http_response_code(500);
        echo json_encode(["error" => "No se pudo guardar la imagen en el servidor"]);
        exit;
    }

    // Actualizar en BD
    $stmt = $pdo->prepare("UPDATE usuarios SET foto_perfil = :foto WHERE id = :id");
    $stmt->bindValue(':foto', $rutaRelativa);
    $stmt->bindValue(':id', $usuario['id']);
    $stmt->execute();

    // URL pública para devolver al app
    $protocolo = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? 'https' : 'http';
    $host      = $_SERVER['HTTP_HOST'];
    $urlPublica = $protocolo . '://' . $host . '/' . $rutaRelativa;

    echo json_encode([
        "mensaje"   => "Foto actualizada correctamente",
        "foto_url"  => $urlPublica,
        "foto_path" => $rutaRelativa,
    ], JSON_UNESCAPED_UNICODE);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["error" => $e->getMessage()]);
}