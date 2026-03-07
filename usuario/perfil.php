<?php
require_once '../config/database.php';

$pdo = conectarDB();
$usuario = validarToken($pdo);

// GET — obtener perfil completo
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    try {
        $stmt = $pdo->prepare("
            SELECT u.id, u.nombre, u.email, u.sexo, u.fecha_nacimiento,
                   u.altura_cm, u.peso_actual, u.objetivo, u.dias_entrenamiento,
                   u.nivel, u.tiene_ciclo, u.duracion_ciclo, u.created_at,
                   GROUP_CONCAT(p.patologia) as patologias
            FROM usuarios u
            LEFT JOIN usuario_patologias p ON p.usuario_id = u.id
            WHERE u.id = :id
            GROUP BY u.id
        ");
        $stmt->bindValue(':id', $usuario['id']);
        $stmt->execute();
        $perfil = $stmt->fetch();

        // Traer última medida
        $stmtMedida = $pdo->prepare("
            SELECT peso_kg, grasa_corporal, masa_muscular, imc, fecha
            FROM medidas
            WHERE usuario_id = :id
            ORDER BY fecha DESC LIMIT 1
        ");
        $stmtMedida->bindValue(':id', $usuario['id']);
        $stmtMedida->execute();
        $ultimaMedida = $stmtMedida->fetch();

        $perfil['patologias'] = $perfil['patologias'] ? explode(',', $perfil['patologias']) : ['ninguna'];
        $perfil['ultima_medida'] = $ultimaMedida ?: null;

        echo json_encode($perfil, JSON_UNESCAPED_UNICODE);

    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(["error" => $e->getMessage()]);
    }
}

// POST — actualizar perfil
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $datos = json_decode(file_get_contents("php://input"), true);

    try {
        $stmt = $pdo->prepare("
    UPDATE usuarios SET
        nombre = :nombre,
        altura_cm = :altura,
        peso_objetivo = :peso_objetivo,
        grasa_objetivo = :grasa_objetivo,
        objetivo = :objetivo,
        dias_entrenamiento = :dias,
        nivel = :nivel,
        tiene_ciclo = :ciclo,
        duracion_ciclo = :duracion_ciclo
    WHERE id = :id
");
$stmt->bindValue(':nombre', trim($datos['nombre']));
$stmt->bindValue(':altura', (float)$datos['altura_cm']);
$stmt->bindValue(':peso_objetivo', isset($datos['peso_objetivo']) ? (float)$datos['peso_objetivo'] : null);
$stmt->bindValue(':grasa_objetivo', isset($datos['grasa_objetivo']) ? (float)$datos['grasa_objetivo'] : null);
$stmt->bindValue(':objetivo', $datos['objetivo']);
$stmt->bindValue(':dias', (int)$datos['dias_entrenamiento']);
$stmt->bindValue(':nivel', $datos['nivel']);
$stmt->bindValue(':ciclo', isset($datos['tiene_ciclo']) ? (bool)$datos['tiene_ciclo'] : false, PDO::PARAM_BOOL);
$stmt->bindValue(':duracion_ciclo', isset($datos['duracion_ciclo']) ? (int)$datos['duracion_ciclo'] : 28);
$stmt->bindValue(':id', $usuario['id']);
        $stmt->execute();

        // Actualizar patologías
        if (isset($datos['patologias']) && is_array($datos['patologias'])) {
            $pdo->prepare("DELETE FROM usuario_patologias WHERE usuario_id = :id")
                ->execute([':id' => $usuario['id']]);

            $patologiasValidas = [
    'sop', 'hipotiroidismo', 'resistencia_insulina',
    'endometriosis', 'diabetes_tipo2', 'ninguna',
    'dolor_rodilla', 'dolor_lumbar', 'lesion_hombro', 'tendinitis'
];
            $stmtPat = $pdo->prepare("INSERT INTO usuario_patologias (usuario_id, patologia) VALUES (:uid, :pat)");
            foreach ($datos['patologias'] as $pat) {
                if (in_array($pat, $patologiasValidas)) {
                    $stmtPat->bindValue(':uid', $usuario['id']);
                    $stmtPat->bindValue(':pat', $pat);
                    $stmtPat->execute();
                }
            }
        }

        echo json_encode(["mensaje" => "Perfil actualizado correctamente"], JSON_UNESCAPED_UNICODE);

    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(["error" => $e->getMessage()]);
    }
}