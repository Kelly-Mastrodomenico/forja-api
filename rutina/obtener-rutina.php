<?php
require_once '../config/database.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    http_response_code(405);
    echo json_encode(["error" => "Método no permitido"]);
    exit();
}

$pdo     = conectarDB();
$usuario = validarToken($pdo);

$semana = isset($_GET['semana']) ? (int)$_GET['semana'] : null;
$planId = isset($_GET['plan_id']) ? (int)$_GET['plan_id'] : null;

try {
    if ($planId) {
        $stmtPlan = $pdo->prepare("SELECT * FROM planes_entrenamiento WHERE id = :id AND usuario_id = :uid");
        $stmtPlan->bindValue(':id',  $planId);
        $stmtPlan->bindValue(':uid', $usuario['id']);
    } else {
        $stmtPlan = $pdo->prepare("SELECT * FROM planes_entrenamiento WHERE usuario_id = :uid AND activo = 1 ORDER BY created_at DESC LIMIT 1");
        $stmtPlan->bindValue(':uid', $usuario['id']);
    }
    $stmtPlan->execute();
    $plan = $stmtPlan->fetch();

    if (!$plan) {
        http_response_code(404);
        echo json_encode(["error" => "No hay plan activo. Genera uno primero."]);
        exit();
    }

    $sqlDetalle = "
        SELECT
            pd.id               AS detalle_id,
            pd.semana_numero,
            pd.dia_numero,
            pd.dia_semana,
            pd.nombre_dia,
            pd.orden,
            pd.series,
            pd.repeticiones,
            pd.rir,
            pd.descanso,
            pd.nota_tecnica,
            e.id                AS ejercicio_id,
            e.nombre            AS ejercicio_nombre,
            e.categoria,
            e.enfoque_muscular,
            e.riesgo,
            e.instrucciones,
            e.video_url,
            e.poster_url,
            e.sustitucion_id,
            es.nombre           AS sustitucion_nombre,
            es.riesgo           AS sustitucion_riesgo
        FROM plan_detalle pd
        INNER JOIN ejercicios e  ON pd.ejercicio_id  = e.id
        LEFT  JOIN ejercicios es ON e.sustitucion_id = es.id
        WHERE pd.plan_id = :plan_id
    ";

    $params = [':plan_id' => $plan['id']];

    if ($semana !== null) {
        $sqlDetalle .= " AND pd.semana_numero = :semana";
        $params[':semana'] = $semana;
    }

    $sqlDetalle .= " ORDER BY pd.semana_numero, pd.dia_numero, pd.orden";

    $stmtDetalle = $pdo->prepare($sqlDetalle);
    foreach ($params as $k => $v) {
        $stmtDetalle->bindValue($k, $v);
    }
    $stmtDetalle->execute();
    $filas = $stmtDetalle->fetchAll();

    // Agrupar por semana → día → ejercicios
    $semanas = [];
    foreach ($filas as $fila) {
        $semNum = $fila['semana_numero'];
        $diaNum = $fila['dia_numero'];

        if (!isset($semanas[$semNum])) {
            $semanas[$semNum] = [
                'semana_numero' => $semNum,
                'es_deload'     => false,
                'dias'          => []
            ];
        }

        if (!isset($semanas[$semNum]['dias'][$diaNum])) {
            // dia_semana: usar el valor guardado, fallback a dia_numero - 1
            $diaSemanaVal = ($fila['dia_semana'] !== null) ? (int)$fila['dia_semana'] : ($diaNum - 1);

            $semanas[$semNum]['dias'][$diaNum] = [
                'dia_numero'     => $diaNum,
                'dia_semana'     => $diaSemanaVal,
                'dia_nombre'     => $fila['nombre_dia'],
                'grupo_muscular' => $fila['enfoque_muscular'] ?? '',
                'ejercicios'     => []
            ];
        }

        $semanas[$semNum]['dias'][$diaNum]['ejercicios'][] = [
            'detalle_id'         => $fila['detalle_id'],
            'ejercicio_id'       => $fila['ejercicio_id'],
            'nombre'             => $fila['ejercicio_nombre'],
            'categoria'          => $fila['categoria'],
            'enfoque_muscular'   => $fila['enfoque_muscular'],
            'riesgo'             => $fila['riesgo'],
            'instrucciones'      => $fila['instrucciones'],
            'video_url'          => $fila['video_url'],
            'poster_url'         => $fila['poster_url'],
            'sustitucion_id'     => $fila['sustitucion_id'],
            'sustitucion_nombre' => $fila['sustitucion_nombre'],
            'sustitucion_riesgo' => $fila['sustitucion_riesgo'],
            'series'             => $fila['series'],
            'repeticiones'       => $fila['repeticiones'],
            'rir'                => $fila['rir'],
            'descanso'           => $fila['descanso'],
            'nota_tecnica'       => $fila['nota_tecnica'],
        ];
    }

    $semanasLista = array_values(array_map(function($sem) {
        $sem['dias'] = array_values($sem['dias']);
        return $sem;
    }, $semanas));

    echo json_encode([
        "plan_id"       => $plan['id'],
        "tipo_plan"     => $plan['tipo_plan'],
        "fecha_inicio"  => $plan['fecha_inicio'],
        "fecha_fin"     => $plan['fecha_fin'],
        "periodizacion" => $plan['periodizacion'],
        "semanas"       => $semanasLista,
    ], JSON_UNESCAPED_UNICODE);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(["error" => $e->getMessage()]);
}