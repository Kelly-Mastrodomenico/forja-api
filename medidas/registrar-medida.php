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

// Peso obligatorio
if (!isset($datos['peso_kg']) || !is_numeric($datos['peso_kg'])) {
    http_response_code(400);
    echo json_encode(["error" => "El peso es obligatorio y debe ser un número"]);
    exit();
}

$peso = (float)$datos['peso_kg'];
if ($peso < 20 || $peso > 300) {
    http_response_code(400);
    echo json_encode(["error" => "El peso debe estar entre 20 y 300 kg"]);
    exit();
}

// Función para limpiar decimales opcionales
function floatONull($val) {
    if (!isset($val) || $val === '' || $val === null) return null;
    $n = (float)$val;
    return $n > 0 ? $n : null;
}
function intONull($val) {
    if (!isset($val) || $val === '' || $val === null) return null;
    $n = (int)$val;
    return $n > 0 ? $n : null;
}

$fecha          = isset($datos['fecha']) && !empty($datos['fecha']) ? $datos['fecha'] : date('Y-m-d');
$fuente         = in_array($datos['fuente'] ?? '', ['manual', 'foto_bascula', 'bluetooth']) ? $datos['fuente'] : 'manual';
$grasa          = floatONull($datos['grasa_corporal']     ?? null);
$muscular       = floatONull($datos['masa_muscular']      ?? null);
$esqueletica    = floatONull($datos['masa_esqueletica']   ?? null);
$agua           = floatONull($datos['contenido_agua']     ?? null);
$imc            = floatONull($datos['imc']                ?? null);
$visceral       = intONull($datos['grasa_visceral']       ?? null);
$metabolismo    = intONull($datos['metabolismo_basal']    ?? null);
$cintura        = floatONull($datos['cintura_cm']         ?? null);
$cadera         = floatONull($datos['cadera_cm']          ?? null);
$pecho          = floatONull($datos['pecho_cm']           ?? null);
$cuello         = floatONull($datos['cuello_cm']          ?? null);
$bicepDer       = floatONull($datos['bicep_der_cm']       ?? null);
$bicepIzq       = floatONull($datos['bicep_izq_cm']       ?? null);
$cuadDer        = floatONull($datos['cuadriceps_der_cm']  ?? null);
$cuadIzq        = floatONull($datos['cuadriceps_izq_cm']  ?? null);
$pantDer        = floatONull($datos['pantorrilla_der_cm'] ?? null);
$pantIzq        = floatONull($datos['pantorrilla_izq_cm'] ?? null);
$notas          = isset($datos['notas']) && !empty(trim($datos['notas'])) ? trim($datos['notas']) : null;

try {
    // ── ¿Ya existe una medida manual de hoy? ────────────────────────────────
    $stmtExiste = $pdo->prepare("
        SELECT id FROM medidas
        WHERE usuario_id = :uid AND fecha = :fecha AND fuente = :fuente
        LIMIT 1
    ");
    $stmtExiste->bindValue(':uid',    $usuario['id']);
    $stmtExiste->bindValue(':fecha',  $fecha);
    $stmtExiste->bindValue(':fuente', $fuente);
    $stmtExiste->execute();
    $existe = $stmtExiste->fetch();

    if ($existe) {
        // Actualizar la del mismo día
        $stmt = $pdo->prepare("
            UPDATE medidas SET
                peso_kg            = :peso,
                grasa_corporal     = :grasa,
                masa_muscular      = :muscular,
                masa_esqueletica   = :esqueletica,
                contenido_agua     = :agua,
                imc                = :imc,
                grasa_visceral     = :visceral,
                metabolismo_basal  = :metabolismo,
                cintura_cm         = :cintura,
                cadera_cm          = :cadera,
                pecho_cm           = :pecho,
                cuello_cm          = :cuello,
                bicep_der_cm       = :bicepDer,
                bicep_izq_cm       = :bicepIzq,
                cuadriceps_der_cm  = :cuadDer,
                cuadriceps_izq_cm  = :cuadIzq,
                pantorrilla_der_cm = :pantDer,
                pantorrilla_izq_cm = :pantIzq,
                notas              = :notas
            WHERE id = :id
        ");
        $stmt->bindValue(':id', $existe['id']);
        $accion = 'actualizada';
    } else {
        // Insertar nueva
        $stmt = $pdo->prepare("
            INSERT INTO medidas (
                usuario_id, fecha, peso_kg, grasa_corporal, masa_muscular,
                masa_esqueletica, contenido_agua, imc, grasa_visceral,
                metabolismo_basal, cintura_cm, cadera_cm, pecho_cm, cuello_cm,
                bicep_der_cm, bicep_izq_cm, cuadriceps_der_cm, cuadriceps_izq_cm,
                pantorrilla_der_cm, pantorrilla_izq_cm, fuente, notas
            ) VALUES (
                :uid, :fecha, :peso, :grasa, :muscular,
                :esqueletica, :agua, :imc, :visceral,
                :metabolismo, :cintura, :cadera, :pecho, :cuello,
                :bicepDer, :bicepIzq, :cuadDer, :cuadIzq,
                :pantDer, :pantIzq, :fuente, :notas
            )
        ");
        $stmt->bindValue(':uid',    $usuario['id']);
        $stmt->bindValue(':fecha',  $fecha);
        $stmt->bindValue(':fuente', $fuente);
        $accion = 'registrada';
    }

    // Bind de campos comunes
    $stmt->bindValue(':peso',        $peso);
    $stmt->bindValue(':grasa',       $grasa);
    $stmt->bindValue(':muscular',    $muscular);
    $stmt->bindValue(':esqueletica', $esqueletica);
    $stmt->bindValue(':agua',        $agua);
    $stmt->bindValue(':imc',         $imc);
    $stmt->bindValue(':visceral',    $visceral,    PDO::PARAM_INT);
    $stmt->bindValue(':metabolismo', $metabolismo, PDO::PARAM_INT);
    $stmt->bindValue(':cintura',     $cintura);
    $stmt->bindValue(':cadera',      $cadera);
    $stmt->bindValue(':pecho',       $pecho);
    $stmt->bindValue(':cuello',      $cuello);
    $stmt->bindValue(':bicepDer',    $bicepDer);
    $stmt->bindValue(':bicepIzq',    $bicepIzq);
    $stmt->bindValue(':cuadDer',     $cuadDer);
    $stmt->bindValue(':cuadIzq',     $cuadIzq);
    $stmt->bindValue(':pantDer',     $pantDer);
    $stmt->bindValue(':pantIzq',     $pantIzq);
    $stmt->bindValue(':notas',       $notas);
    $stmt->execute();

    // También actualizar peso_actual en tabla usuarios
    $stmtU = $pdo->prepare("UPDATE usuarios SET peso_actual = :peso WHERE id = :uid");
    $stmtU->bindValue(':peso', $peso);
    $stmtU->bindValue(':uid',  $usuario['id']);
    $stmtU->execute();

    echo json_encode([
        "mensaje"    => "Medida {$accion} correctamente",
        "accion"     => $accion,
        "fecha"      => $fecha,
        "peso_kg"    => $peso,
    ], JSON_UNESCAPED_UNICODE);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["error" => $e->getMessage()]);
}