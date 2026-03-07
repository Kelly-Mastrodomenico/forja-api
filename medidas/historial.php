<?php
require_once '../config/database.php';

$pdo = conectarDB();
$usuario = validarToken($pdo);

try {
    $stmt = $pdo->prepare("
        SELECT fecha, peso_kg, grasa_corporal, masa_muscular,
               imc, metabolismo_basal, grasa_visceral, contenido_agua
        FROM medidas
        WHERE usuario_id = :id
        ORDER BY fecha ASC
        LIMIT 30
    ");
    $stmt->bindValue(':id', $usuario['id']);
    $stmt->execute();
    $medidas = $stmt->fetchAll();

    // Calcular progreso entre primera y última medida
    $progreso = null;
    if (count($medidas) >= 2) {
        $primera = $medidas[0];
        $ultima = $medidas[count($medidas) - 1];
        $progreso = [
            'peso' => round($ultima['peso_kg'] - $primera['peso_kg'], 2),
            'grasa' => round($ultima['grasa_corporal'] - $primera['grasa_corporal'], 2),
            'musculo' => round($ultima['masa_muscular'] - $primera['masa_muscular'], 2),
            'dias' => (new DateTime($primera['fecha']))->diff(new DateTime($ultima['fecha']))->days
        ];
    }

    echo json_encode([
        "medidas" => $medidas,
        "total" => count($medidas),
        "progreso" => $progreso
    ], JSON_UNESCAPED_UNICODE);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["error" => $e->getMessage()]);
}