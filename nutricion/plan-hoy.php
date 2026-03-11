<?php
require_once '../config/database.php';

$pdo     = conectarDB();
$usuario = validarToken($pdo);

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    http_response_code(405);
    echo json_encode(["error" => "Método no permitido"]);
    exit();
}

// dia_semana: 0=Lun...6=Dom (igual que en plan_detalle)
// PHP: date('N') devuelve 1=Lun...7=Dom → convertimos a 0=Lun...6=Dom
$diaSemanaHoy = (int)date('N') - 1;

// Aceptar override por parámetro (para ver otros días)
if (isset($_GET['dia_semana']) && is_numeric($_GET['dia_semana'])) {
    $diaSemanaHoy = max(0, min(6, (int)$_GET['dia_semana']));
}

try {
    // Obtener plan nutricional del día
    $stmt = $pdo->prepare("
        SELECT pn.id, pn.dia_semana, pn.tipo_dia, pn.nombre_dia, pn.grupo_muscular,
               pn.fase_hormonal, pn.calorias_total, pn.proteinas_total,
               pn.carbos_total, pn.grasas_total, pn.estrategia, pn.estado_metabolico
        FROM plan_nutricional pn
        INNER JOIN planes_entrenamiento pe ON pe.id = pn.plan_entreno_id
        WHERE pn.usuario_id  = :uid
          AND pn.dia_semana  = :dia
          AND pe.activo      = 1
        ORDER BY pn.id DESC
        LIMIT 1
    ");
    $stmt->bindValue(':uid', $usuario['id']);
    $stmt->bindValue(':dia', $diaSemanaHoy);
    $stmt->execute();
    $planDia = $stmt->fetch();

    if (!$planDia) {
        echo json_encode([
            "tiene_plan"  => false,
            "dia_semana"  => $diaSemanaHoy,
            "mensaje"     => "No hay plan nutricional generado. Genera tu rutina para obtener un plan de nutrición personalizado."
        ], JSON_UNESCAPED_UNICODE);
        exit();
    }

    // Obtener comidas del día
    $stmtC = $pdo->prepare("
        SELECT id, momento, nombre_comida, hora_sugerida,
               ingredientes, calorias, proteinas, carbos, grasas
        FROM plan_nutricional_comidas
        WHERE plan_nutricional_id = :pn_id
        ORDER BY FIELD(momento, 'desayuno','media_manana','almuerzo','merienda','pre_entreno','cena','post_entreno')
    ");
    $stmtC->bindValue(':pn_id', $planDia['id']);
    $stmtC->execute();
    $comidasRaw = $stmtC->fetchAll();

    // Parsear ingredientes JSON
    $comidas = array_map(function($c) {
        $c['ingredientes'] = json_decode($c['ingredientes'], true) ?? [];
        return $c;
    }, $comidasRaw);

    // Obtener totales del diario real del día (lo que ya registró el usuario)
    $stmtDiario = $pdo->prepare("
        SELECT
            SUM(a.calorias_100g      * rc.cantidad_gramos / 100) AS calorias_real,
            SUM(a.proteinas_100g     * rc.cantidad_gramos / 100) AS proteinas_real,
            SUM(a.carbohidratos_100g * rc.cantidad_gramos / 100) AS carbos_real,
            SUM(a.grasas_100g        * rc.cantidad_gramos / 100) AS grasas_real
        FROM registro_comidas rc
        JOIN alimentos a ON a.id = rc.alimento_id
        WHERE rc.usuario_id = :uid AND rc.fecha = CURDATE()
    ");
    $stmtDiario->bindValue(':uid', $usuario['id']);
    $stmtDiario->execute();
    $real = $stmtDiario->fetch();

    echo json_encode([
        "tiene_plan"      => true,
        "dia_semana"      => (int)$planDia['dia_semana'],
        "tipo_dia"        => $planDia['tipo_dia'],
        "nombre_dia"      => $planDia['nombre_dia'],
        "grupo_muscular"  => $planDia['grupo_muscular'],
        "fase_hormonal"   => $planDia['fase_hormonal'],
        "estrategia"      => $planDia['estrategia'],
        "estado_metabolico" => $planDia['estado_metabolico'],
        "macros_objetivo" => [
            "calorias"   => (float)$planDia['calorias_total'],
            "proteinas"  => (float)$planDia['proteinas_total'],
            "carbos"     => (float)$planDia['carbos_total'],
            "grasas"     => (float)$planDia['grasas_total'],
        ],
        "macros_real"     => [
            "calorias"   => round((float)($real['calorias_real']  ?? 0), 1),
            "proteinas"  => round((float)($real['proteinas_real'] ?? 0), 1),
            "carbos"     => round((float)($real['carbos_real']    ?? 0), 1),
            "grasas"     => round((float)($real['grasas_real']    ?? 0), 1),
        ],
        "comidas"         => $comidas,
    ], JSON_UNESCAPED_UNICODE);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["error" => $e->getMessage()]);
}