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

$fuente = isset($datos['fuente']) ? $datos['fuente'] : 'manual';
$fecha = isset($datos['fecha']) ? $datos['fecha'] : date('Y-m-d');

try {
    $stmt = $pdo->prepare("
        INSERT INTO medidas (
            usuario_id, fecha, peso_kg, grasa_corporal, masa_muscular,
            masa_esqueletica, contenido_agua, imc, grasa_visceral,
            metabolismo_basal, cintura_cm, cadera_cm, pecho_cm,
            bicep_der_cm, bicep_izq_cm, cuadriceps_der_cm, cuadriceps_izq_cm,
            pantorrilla_der_cm, pantorrilla_izq_cm, notas, fuente
        ) VALUES (
            :uid, :fecha, :peso, :grasa, :musculo,
            :esqueletica, :agua, :imc, :visceral,
            :metabolismo, :cintura, :cadera, :pecho,
            :bicep_d, :bicep_i, :cuad_d, :cuad_i,
            :pant_d, :pant_i, :notas, :fuente
        )
    ");

    $stmt->bindValue(':uid', $usuario['id']);
    $stmt->bindValue(':fecha', $fecha);
    $stmt->bindValue(':peso', isset($datos['peso_kg']) ? (float)$datos['peso_kg'] : null);
    $stmt->bindValue(':grasa', isset($datos['grasa_corporal']) ? (float)$datos['grasa_corporal'] : null);
    $stmt->bindValue(':musculo', isset($datos['masa_muscular']) ? (float)$datos['masa_muscular'] : null);
    $stmt->bindValue(':esqueletica', isset($datos['masa_esqueletica']) ? (float)$datos['masa_esqueletica'] : null);
    $stmt->bindValue(':agua', isset($datos['contenido_agua']) ? (float)$datos['contenido_agua'] : null);
    $stmt->bindValue(':imc', isset($datos['imc']) ? (float)$datos['imc'] : null);
    $stmt->bindValue(':visceral', isset($datos['grasa_visceral']) ? (int)$datos['grasa_visceral'] : null);
    $stmt->bindValue(':metabolismo', isset($datos['metabolismo_basal']) ? (int)$datos['metabolismo_basal'] : null);
    $stmt->bindValue(':cintura', isset($datos['cintura_cm']) ? (float)$datos['cintura_cm'] : null);
    $stmt->bindValue(':cadera', isset($datos['cadera_cm']) ? (float)$datos['cadera_cm'] : null);
    $stmt->bindValue(':pecho', isset($datos['pecho_cm']) ? (float)$datos['pecho_cm'] : null);
    $stmt->bindValue(':bicep_d', isset($datos['bicep_der_cm']) ? (float)$datos['bicep_der_cm'] : null);
    $stmt->bindValue(':bicep_i', isset($datos['bicep_izq_cm']) ? (float)$datos['bicep_izq_cm'] : null);
    $stmt->bindValue(':cuad_d', isset($datos['cuadriceps_der_cm']) ? (float)$datos['cuadriceps_der_cm'] : null);
    $stmt->bindValue(':cuad_i', isset($datos['cuadriceps_izq_cm']) ? (float)$datos['cuadriceps_izq_cm'] : null);
    $stmt->bindValue(':pant_d', isset($datos['pantorrilla_der_cm']) ? (float)$datos['pantorrilla_der_cm'] : null);
    $stmt->bindValue(':pant_i', isset($datos['pantorrilla_izq_cm']) ? (float)$datos['pantorrilla_izq_cm'] : null);
    $stmt->bindValue(':notas', isset($datos['notas']) ? $datos['notas'] : null);
    $stmt->bindValue(':fuente', $fuente);
    $stmt->execute();

    $medidaId = $pdo->lastInsertId();

    echo json_encode([
        "mensaje" => "Medidas guardadas correctamente",
        "medida_id" => $medidaId,
        "fecha" => $fecha
    ], JSON_UNESCAPED_UNICODE);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["error" => "Error al guardar: " . $e->getMessage()]);
}