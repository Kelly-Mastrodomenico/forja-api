<?php
require_once '../config/database.php';

$pdo     = conectarDB();
$usuario = validarToken($pdo);

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(["error" => "Método no permitido"]);
    exit();
}

$datos = json_decode(file_get_contents("php://input"), true);

if (!$datos) {
    http_response_code(400);
    echo json_encode(["error" => "No se recibieron datos"]);
    exit();
}

// ── Campos permitidos y sus validaciones ──────────────────────────────────────
$campos    = [];
$valores   = [':id' => $usuario['id']];

// Datos básicos
if (isset($datos['nombre']) && !empty(trim($datos['nombre']))) {
    $campos[]         = 'nombre = :nombre';
    $valores[':nombre'] = trim($datos['nombre']);
}
if (isset($datos['altura_cm']) && is_numeric($datos['altura_cm'])) {
    $h = (float)$datos['altura_cm'];
    if ($h >= 100 && $h <= 250) {
        $campos[]           = 'altura_cm = :altura_cm';
        $valores[':altura_cm'] = $h;
    }
}
if (isset($datos['peso_actual']) && is_numeric($datos['peso_actual'])) {
    $p = (float)$datos['peso_actual'];
    if ($p >= 30 && $p <= 300) {
        $campos[]             = 'peso_actual = :peso_actual';
        $valores[':peso_actual'] = $p;
    }
}
if (isset($datos['peso_objetivo']) && is_numeric($datos['peso_objetivo'])) {
    $campos[]               = 'peso_objetivo = :peso_objetivo';
    $valores[':peso_objetivo'] = (float)$datos['peso_objetivo'];
}
if (isset($datos['grasa_objetivo']) && is_numeric($datos['grasa_objetivo'])) {
    $campos[]                 = 'grasa_objetivo = :grasa_objetivo';
    $valores[':grasa_objetivo'] = (float)$datos['grasa_objetivo'];
}
if (isset($datos['objetivo'])) {
    $objetivosValidos = ['perder_grasa', 'ganar_musculo', 'recomposicion', 'mantenimiento', 'rendimiento'];
    if (in_array($datos['objetivo'], $objetivosValidos)) {
        $campos[]           = 'objetivo = :objetivo';
        $valores[':objetivo'] = $datos['objetivo'];
    }
}
if (isset($datos['nivel'])) {
    $nivelesValidos = ['principiante', 'intermedio', 'avanzado'];
    if (in_array($datos['nivel'], $nivelesValidos)) {
        $campos[]        = 'nivel = :nivel';
        $valores[':nivel'] = $datos['nivel'];
    }
}
if (isset($datos['dias_entrenamiento']) && is_numeric($datos['dias_entrenamiento'])) {
    $d = (int)$datos['dias_entrenamiento'];
    if ($d >= 1 && $d <= 7) {
        $campos[]                    = 'dias_entrenamiento = :dias_entrenamiento';
        $valores[':dias_entrenamiento'] = $d;
    }
}

// Ciclo hormonal
if (isset($datos['tiene_ciclo'])) {
    $campos[]             = 'tiene_ciclo = :tiene_ciclo';
    $valores[':tiene_ciclo'] = $datos['tiene_ciclo'] ? 1 : 0;
}
if (isset($datos['fecha_ultimo_ciclo']) && !empty($datos['fecha_ultimo_ciclo'])) {
    $campos[]                     = 'fecha_ultimo_ciclo = :fecha_ultimo_ciclo';
    $valores[':fecha_ultimo_ciclo'] = $datos['fecha_ultimo_ciclo'];
}
if (isset($datos['duracion_ciclo']) && is_numeric($datos['duracion_ciclo'])) {
    $dc = (int)$datos['duracion_ciclo'];
    if ($dc >= 21 && $dc <= 35) {
        $campos[]                = 'duracion_ciclo = :duracion_ciclo';
        $valores[':duracion_ciclo'] = $dc;
    }
}

// ── Preferencias alimentarias ─────────────────────────────────────────────────
if (isset($datos['tipo_dieta'])) {
    $tiposDieta = ['omnivora', 'vegetariana', 'vegana', 'sin_gluten', 'keto', 'paleo', 'mediterranea'];
    if (in_array($datos['tipo_dieta'], $tiposDieta)) {
        $campos[]              = 'tipo_dieta = :tipo_dieta';
        $valores[':tipo_dieta'] = $datos['tipo_dieta'];
    }
}
if (isset($datos['alergias'])) {
    $alergias = is_array($datos['alergias']) ? $datos['alergias'] : json_decode($datos['alergias'], true);
    $campos[]           = 'alergias = :alergias';
    $valores[':alergias'] = json_encode($alergias ?? [], JSON_UNESCAPED_UNICODE);
}
if (isset($datos['alimentos_no_gusta'])) {
    $noGusta = is_array($datos['alimentos_no_gusta']) ? $datos['alimentos_no_gusta'] : json_decode($datos['alimentos_no_gusta'], true);
    $campos[]                    = 'alimentos_no_gusta = :alimentos_no_gusta';
    $valores[':alimentos_no_gusta'] = json_encode($noGusta ?? [], JSON_UNESCAPED_UNICODE);
}
if (isset($datos['alimentos_favoritos'])) {
    $favoritos = is_array($datos['alimentos_favoritos']) ? $datos['alimentos_favoritos'] : json_decode($datos['alimentos_favoritos'], true);
    $campos[]                     = 'alimentos_favoritos = :alimentos_favoritos';
    $valores[':alimentos_favoritos'] = json_encode($favoritos ?? [], JSON_UNESCAPED_UNICODE);
}
if (isset($datos['comidas_diarias']) && is_numeric($datos['comidas_diarias'])) {
    $c = (int)$datos['comidas_diarias'];
    if ($c >= 3 && $c <= 6) {
        $campos[]                 = 'comidas_diarias = :comidas_diarias';
        $valores[':comidas_diarias'] = $c;
    }
}

// ── Foto de perfil (si viene) ─────────────────────────────────────────────────
if (isset($datos['foto_perfil']) && !empty($datos['foto_perfil'])) {
    $campos[]               = 'foto_perfil = :foto_perfil';
    $valores[':foto_perfil'] = $datos['foto_perfil'];
}

if (empty($campos)) {
    http_response_code(400);
    echo json_encode(["error" => "No hay campos válidos para actualizar"]);
    exit();
}

try {
    $sql  = "UPDATE usuarios SET " . implode(', ', $campos) . " WHERE id = :id";
    $stmt = $pdo->prepare($sql);
    foreach ($valores as $param => $val) {
        $stmt->bindValue($param, $val);
    }
    $stmt->execute();

    // ── Actualizar patologías si vienen ──────────────────────────────────────
    if (isset($datos['patologias']) && is_array($datos['patologias'])) {
        $pdo->prepare("DELETE FROM usuario_patologias WHERE usuario_id = :uid")
            ->execute([':uid' => $usuario['id']]);

        if (!empty($datos['patologias'])) {
            $stmtP = $pdo->prepare("INSERT INTO usuario_patologias (usuario_id, patologia) VALUES (:uid, :pat)");
            foreach ($datos['patologias'] as $pat) {
                if (!empty(trim($pat))) {
                    $stmtP->bindValue(':uid', $usuario['id']);
                    $stmtP->bindValue(':pat', trim($pat));
                    $stmtP->execute();
                }
            }
        }
    }

    echo json_encode([
        "mensaje" => "Perfil actualizado correctamente",
        "campos_actualizados" => count($campos),
    ], JSON_UNESCAPED_UNICODE);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["error" => $e->getMessage()]);
}