<?php
require_once '../config/database.php';

$pdo = conectarDB();
$usuario = validarToken($pdo);
$fecha = isset($_GET['fecha']) ? $_GET['fecha'] : date('Y-m-d');

try {
    $stmt = $pdo->prepare("
        SELECT rc.id, rc.momento, rc.cantidad_gramos, rc.fecha,
               a.nombre, a.marca, a.calorias_100g, a.proteinas_100g,
               a.carbohidratos_100g, a.grasas_100g
        FROM registro_comidas rc
        JOIN alimentos a ON a.id = rc.alimento_id
        WHERE rc.usuario_id = :uid AND rc.fecha = :fecha
        ORDER BY FIELD(rc.momento, 'desayuno','media_manana','almuerzo','merienda','cena','pre_entreno','post_entreno')
    ");
    $stmt->bindValue(':uid', $usuario['id']);
    $stmt->bindValue(':fecha', $fecha);
    $stmt->execute();
    $comidas = $stmt->fetchAll();

    // Calcular totales del día
    $totales = ['calorias' => 0, 'proteinas' => 0, 'carbohidratos' => 0, 'grasas' => 0];
    foreach ($comidas as $comida) {
        $factor = $comida['cantidad_gramos'] / 100;
        $totales['calorias'] += ($comida['calorias_100g'] ?? 0) * $factor;
        $totales['proteinas'] += ($comida['proteinas_100g'] ?? 0) * $factor;
        $totales['carbohidratos'] += ($comida['carbohidratos_100g'] ?? 0) * $factor;
        $totales['grasas'] += ($comida['grasas_100g'] ?? 0) * $factor;
    }

    foreach ($totales as $key => $val) {
        $totales[$key] = round($val, 1);
    }

    echo json_encode([
        "fecha" => $fecha,
        "comidas" => $comidas,
        "totales" => $totales
    ], JSON_UNESCAPED_UNICODE);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["error" => $e->getMessage()]);
}