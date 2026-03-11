<?php
require_once '../config/database.php';

$pdo     = conectarDB();
$usuario = validarToken($pdo);

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    http_response_code(405);
    echo json_encode(["error" => "Método no permitido"]);
    exit();
}

try {
    $stmt = $pdo->prepare("
        SELECT id, fecha, peso_kg, grasa_corporal, masa_muscular, masa_esqueletica,
               contenido_agua, imc, grasa_visceral, metabolismo_basal,
               cintura_cm, cadera_cm, pecho_cm, cuello_cm,
               bicep_der_cm, bicep_izq_cm,
               cuadriceps_der_cm, cuadriceps_izq_cm,
               pantorrilla_der_cm, pantorrilla_izq_cm,
               fuente, notas
        FROM medidas
        WHERE usuario_id = :uid
        ORDER BY fecha DESC, created_at DESC
        LIMIT 1
    ");
    $stmt->bindValue(':uid', $usuario['id']);
    $stmt->execute();
    $medida = $stmt->fetch();

    if (!$medida) {
        echo json_encode(null);
        exit();
    }

    echo json_encode($medida, JSON_UNESCAPED_UNICODE);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["error" => $e->getMessage()]);
}