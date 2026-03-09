-- ============================================================
-- FORJA — Biblioteca Científica de Ejercicios v2.1 (CORREGIDA)
-- ============================================================

-- ── PASO 1: Crear tablas ───────────────────────────────────

DROP TABLE IF EXISTS log_entreno;
DROP TABLE IF EXISTS plan_detalle;
DROP TABLE IF EXISTS planes_entrenamiento;
DROP TABLE IF EXISTS ejercicios;

CREATE TABLE ejercicios (
    id               VARCHAR(60)  NOT NULL,
    nombre           VARCHAR(120) NOT NULL,
    categoria        ENUM('Tren Inferior','Tracción','Empuje','Hombro','Brazos','Core') NOT NULL,
    enfoque_muscular VARCHAR(100) NULL,
    riesgo           ENUM('Bajo','Medio','Alto') DEFAULT 'Bajo',
    instrucciones    TEXT NULL,
    video_url        VARCHAR(255) NULL,
    poster_url       VARCHAR(255) NULL,
    sustitucion_id   VARCHAR(60)  NULL,
    PRIMARY KEY (id)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE planes_entrenamiento (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id    INT NOT NULL,
    tipo_plan     ENUM('semanal','mensual') NOT NULL DEFAULT 'semanal',
    fecha_inicio  DATE NOT NULL,
    fecha_fin     DATE NULL,
    periodizacion TEXT NULL,
    activo        TINYINT(1) DEFAULT 1,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE plan_detalle (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    plan_id       INT NOT NULL,
    semana_numero TINYINT NOT NULL DEFAULT 1,
    dia_numero    TINYINT NOT NULL,
    nombre_dia    VARCHAR(100) NULL,
    ejercicio_id  VARCHAR(60) NOT NULL,
    orden         TINYINT DEFAULT 1,
    series        TINYINT NULL,
    repeticiones  VARCHAR(20) NULL,
    rir           TINYINT NULL,
    descanso      VARCHAR(20) NULL,
    nota_tecnica  TEXT NULL,
    FOREIGN KEY (plan_id)      REFERENCES planes_entrenamiento(id) ON DELETE CASCADE,
    FOREIGN KEY (ejercicio_id) REFERENCES ejercicios(id)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE log_entreno (
    id                 INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id         INT NOT NULL,
    plan_detalle_id    INT NULL,
    fecha              DATE NOT NULL,
    ejercicio_id       VARCHAR(60) NOT NULL,
    series_completadas TINYINT NULL,
    reps_completadas   VARCHAR(20) NULL,
    peso_kg            DECIMAL(6,2) NULL,
    rir                TINYINT NULL,
    completado         TINYINT(1) DEFAULT 0,
    notas              VARCHAR(255) NULL,
    FOREIGN KEY (usuario_id)      REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (plan_detalle_id) REFERENCES plan_detalle(id) ON DELETE SET NULL,
    FOREIGN KEY (ejercicio_id)     REFERENCES ejercicios(id)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ── PASO 2: Insertar Ejercicios ──────────────────────────────

INSERT INTO ejercicios (id, nombre, categoria, enfoque_muscular, riesgo, instrucciones, video_url, poster_url) VALUES

-- TREN INFERIOR
('hip_thrust_barra', 'Hip Thrust con Barra', 'Tren Inferior', 'Glúteo Mayor', 'Bajo', 'Espalda alta apoyada en el banco, barra sobre las caderas con almohadilla. Empujar hasta que el tronco quede paralelo al suelo.', 'assets/videos/hip_thrust_barra.mp4', 'assets/posters/hip_thrust_barra.jpg'),
('hip_thrust_maquina', 'Hip Thrust en Máquina', 'Tren Inferior', 'Glúteo Mayor', 'Bajo', 'Tensión constante. Ideal para principiantes o control de carga.', 'assets/videos/hip_thrust_maquina.mp4', 'assets/posters/hip_thrust_maquina.jpg'),
('prensa_45', 'Prensa 45°', 'Tren Inferior', 'Cuádriceps/Glúteo', 'Bajo', 'Pies al ancho de hombros. Bajar hasta 90° de rodilla. No bloquear rodillas al subir.', 'assets/videos/prensa_45.mp4', 'assets/posters/prensa_45.jpg'),
('extension_cuadriceps_maquina', 'Extensión de Cuádriceps en Máquina', 'Tren Inferior', 'Cuádriceps', 'Bajo', 'Rodillo en los tobillos. Pausa en máxima extensión. Bajar controlado.', 'assets/videos/extension_cuadriceps_maquina.mp4', 'assets/posters/extension_cuadriceps_maquina.jpg'),
('sentadilla_bulgara', 'Sentadilla Búlgara con Mancuernas', 'Tren Inferior', 'Cuádriceps/Glúteo', 'Medio', 'Pie trasero elevado. Bajar hasta que la rodilla trasera casi toque el suelo.', 'assets/videos/sentadilla_bulgara.mp4', 'assets/posters/sentadilla_bulgara.jpg'),
('curl_femoral_sentado', 'Curl Femoral Sentado', 'Tren Inferior', 'Isquiotibiales', 'Bajo', 'Lumbar pegada al respaldo. Bajar el rodillo en 3 segundos.', 'assets/videos/curl_femoral_sentado.mp4', 'assets/posters/curl_femoral_sentado.jpg'),
('curl_nordico', 'Curl Nórdico', 'Tren Inferior', 'Isquiotibiales', 'Medio', 'Pies fijos, bajar el tronco frenando con los isquios.', 'assets/videos/curl_nordico.mp4', 'assets/posters/curl_nordico.jpg'),
('aduccion_maquina', 'Aductores en Máquina', 'Tren Inferior', 'Aductores', 'Bajo', 'Movimiento lento, evitar el choque de las placas al cerrar.', 'assets/videos/aduccion_maquina.mp4', 'assets/posters/aduccion_maquina.jpg'),
('abduccion_maquina', 'Abductores en Máquina', 'Tren Inferior', 'Glúteo Medio', 'Bajo', 'Inclinar el tronco ligeramente hacia adelante.', 'assets/videos/abduccion_maquina.mp4', 'assets/posters/abduccion_maquina.jpg'),
('sentadilla_libre_barra', 'Sentadilla Libre con Barra', 'Tren Inferior', 'Cuádriceps/Glúteo', 'Alto', 'Barra sobre trapecios. Bajar rompiendo el paralelo manteniendo espalda neutra.', 'assets/videos/sentadilla_libre_barra.mp4', 'assets/posters/sentadilla_libre_barra.jpg'),
('elevacion_gemelos_prensa', 'Elevación de Gemelos en Prensa', 'Tren Inferior', 'Gastrocnemio', 'Bajo', 'Bajar talón al máximo estiramiento. Pausa arriba.', 'assets/videos/elevacion_gemelos_prensa.mp4', 'assets/posters/elevacion_gemelos_prensa.jpg'),
('gemelos_sentado_maquina', 'Gemelos Sentado en Máquina', 'Tren Inferior', 'Sóleo', 'Bajo', 'Rodilla flexionada. Movimiento controlado.', 'assets/videos/gemelos_sentado_maquina.mp4', 'assets/posters/gemelos_sentado_maquina.jpg'),
('patada_gluteo_polea', 'Patada de Glúteo en Polea Baja', 'Tren Inferior', 'Glúteo Mayor', 'Bajo', 'Extender cadera hacia atrás con espalda recta.', 'assets/videos/patada_gluteo_polea.mp4', 'assets/posters/patada_gluteo_polea.jpg'),
('peso_muerto_rumano_mancuernas', 'Peso Muerto Rumano con Mancuernas', 'Tren Inferior', 'Isquiotibiales/Glúteo', 'Medio', 'Bisagra de cadera. Bajar pegado a las piernas.', 'assets/videos/peso_muerto_rumano_mancuernas.mp4', 'assets/posters/peso_muerto_rumano_mancuernas.jpg'),
('zancada_caminando', 'Zancada Caminando con Mancuernas', 'Tren Inferior', 'Cuádriceps/Glúteo', 'Bajo', 'Paso largo, torso erguido.', 'assets/videos/zancada_caminando.mp4', 'assets/posters/zancada_caminando.jpg'),

-- EMPUJE
('press_banca_mancuernas', 'Press de Banca con Mancuernas', 'Empuje', 'Pectoral Mayor', 'Bajo', 'Retracción escapular, bajar hasta altura del pecho.', 'assets/videos/press_banca_mancuernas.mp4', 'assets/posters/press_banca_mancuernas.jpg'),
('press_banca_barra_plano', 'Press de Banca con Barra', 'Empuje', 'Pectoral Mayor', 'Medio', 'Barra al pecho (altura pezones) y empujar.', 'assets/videos/press_banca_barra.mp4', 'assets/posters/press_banca_barra.jpg'),
('press_inclinado_mancuernas', 'Press Inclinado con Mancuernas', 'Empuje', 'Pectoral Superior', 'Bajo', 'Banco a 30-45 grados.', 'assets/videos/press_inclinado_mancuernas.mp4', 'assets/posters/press_inclinado_mancuernas.jpg'),
('aperturas_polea_cruzada', 'Aperturas en Polea Cruzada', 'Empuje', 'Pectoral Mayor', 'Bajo', 'Llevar manos al centro cruzándolas ligeramente.', 'assets/videos/aperturas_polea_cruzada.mp4', 'assets/posters/aperturas_polea_cruzada.jpg'),
('press_pecho_maquina', 'Press de Pecho en Máquina', 'Empuje', 'Pectoral Mayor', 'Bajo', 'Convergente, permite trabajar a fallo con seguridad.', 'assets/videos/press_pecho_maquina.mp4', 'assets/posters/press_pecho_maquina.jpg'),
('extension_triceps_polea_cuerda', 'Extensión de Tríceps Polea Cuerda', 'Empuje', 'Tríceps', 'Bajo', 'Codos pegados al costado. Abrir cuerda al final.', 'assets/videos/extension_triceps_polea_cuerda.mp4', 'assets/posters/extension_triceps_polea_cuerda.jpg'),
('patada_triceps_polea', 'Patada de Tríceps en Polea Alta', 'Empuje', 'Tríceps', 'Bajo', 'Torso inclinado, brazo paralelo al suelo.', 'assets/videos/patada_triceps_polea.mp4', 'assets/posters/patada_triceps_polea.jpg'),
('extension_triceps_sobre_cabeza', 'Extensión Tríceps sobre Cabeza', 'Empuje', 'Tríceps', 'Bajo', 'Mancuerna detrás de la cabeza, codo fijo.', 'assets/videos/extension_triceps_sobre_cabeza.mp4', 'assets/posters/extension_triceps_sobre_cabeza.jpg'),
('press_militar_mancuernas', 'Press Militar con Mancuernas', 'Empuje', 'Deltoide Anterior', 'Medio', 'No bloquear codos al subir.', 'assets/videos/press_militar_mancuernas.mp4', 'assets/posters/press_militar_mancuernas.jpg'),
('press_hombro_maquina', 'Press de Hombro en Máquina', 'Empuje', 'Deltoide Anterior', 'Bajo', 'Seguridad máxima para series pesadas.', 'assets/videos/press_hombro_maquina.mp4', 'assets/posters/press_hombro_maquina.jpg'),

-- TRACCIÓN
('dominadas', 'Dominadas (Asistidas/Libres)', 'Tracción', 'Dorsal Ancho', 'Bajo', 'Pecho hacia la barra al subir. Estirar completo abajo.', 'assets/videos/dominadas.mp4', 'assets/posters/dominadas.jpg'),
('jalon_agarre_ancho', 'Jalón al Pecho Agarre Ancho', 'Tracción', 'Dorsal Ancho', 'Bajo', 'Llevar barra a la clavícula, codos hacia abajo.', 'assets/videos/jalon_agarre_ancho.mp4', 'assets/posters/jalon_agarre_ancho.jpg'),
('jalon_agarre_neutro', 'Jalón Agarre Neutro', 'Tracción', 'Dorsal/Bíceps', 'Bajo', 'Palmas enfrentadas. Activa dorsal inferior.', 'assets/videos/jalon_agarre_neutro.mp4', 'assets/posters/jalon_agarre_neutro.jpg'),
('remo_polea_baja', 'Remo en Polea Baja', 'Tracción', 'Dorsal/Trapecio', 'Bajo', 'Espalda neutra, tirar hacia el abdomen.', 'assets/videos/remo_polea_baja.mp4', 'assets/posters/remo_polea_baja.jpg'),
('remo_mancuerna_unilateral', 'Remo con Mancuerna Unilateral', 'Tracción', 'Dorsal Ancho', 'Bajo', 'Codo hacia el techo, evitar rotar el tronco.', 'assets/videos/remo_mancuerna_unilateral.mp4', 'assets/posters/remo_mancuerna_unilateral.jpg'),
('remo_maquina_pecho_apoyado', 'Remo Máquina Pecho Apoyado', 'Tracción', 'Dorsal/Romboides', 'Bajo', 'Elimina compensación lumbar.', 'assets/videos/remo_maquina_pecho_apoyado.mp4', 'assets/posters/remo_maquina_pecho_apoyado.jpg'),
('face_pull_polea', 'Face Pull con Cuerda', 'Tracción', 'Deltoide Posterior', 'Bajo', 'Tirar hacia la frente separando extremos.', 'assets/videos/face_pull_polea.mp4', 'assets/posters/face_pull_polea.jpg'),
('pullover_polea', 'Pullover en Polea Alta', 'Tracción', 'Dorsal/Serrato', 'Bajo', 'Brazos extendidos, tirar hacia muslos.', 'assets/videos/pullover_polea.mp4', 'assets/posters/pullover_polea.jpg'),
('pajaro_mancuernas', 'Pájaro con Mancuernas', 'Tracción', 'Deltoide Posterior', 'Bajo', 'Torso inclinado, elevar hacia los lados.', 'assets/videos/pajaro_mancuernas.mp4', 'assets/posters/pajaro_mancuernas.jpg'),

-- HOMBRO
('elevacion_lateral_maquina', 'Elevación Lateral en Máquina', 'Hombro', 'Deltoide Lateral', 'Bajo', 'Subir hasta alinear codo con hombro.', 'assets/videos/elevacion_lateral_maquina.mp4', 'assets/posters/elevacion_lateral_maquina.jpg'),
('elevacion_lateral_polea', 'Elevación Lateral en Polea Baja', 'Hombro', 'Deltoide Lateral', 'Bajo', 'Tensión constante en rango inferior.', 'assets/videos/elevacion_lateral_polea.mp4', 'assets/posters/elevacion_lateral_polea.jpg'),
('elevacion_lateral_mancuernas', 'Elevación Lateral Mancuernas', 'Hombro', 'Deltoide Lateral', 'Bajo', 'Ligera inclinación del torso adelante.', 'assets/videos/elevacion_lateral_mancuernas.mp4', 'assets/posters/elevacion_lateral_mancuernas.jpg'),
('encogimiento_trapecio', 'Encogimiento Trapecios', 'Hombro', 'Trapecio Superior', 'Bajo', 'Subir hombros hacia orejas, sin rotación.', 'assets/videos/encogimiento_trapecio.mp4', 'assets/posters/encogimiento_trapecio.jpg'),
('rotacion_externa_polea', 'Rotación Externa Polea', 'Hombro', 'Manguito Rotador', 'Bajo', 'Codo pegado al costado, rotar hacia afuera.', 'assets/videos/rotacion_externa_polea.mp4', 'assets/posters/rotacion_externa_polea.jpg'),
('rotacion_interna_polea', 'Rotación Interna Polea', 'Hombro', 'Manguito Rotador', 'Bajo', 'Rotar hacia el abdomen.', 'assets/videos/rotacion_interna_polea.mp4', 'assets/posters/rotacion_interna_polea.jpg'),

-- BRAZOS
('curl_biceps_polea_baja', 'Curl de Bíceps Polea Baja', 'Brazos', 'Bíceps', 'Bajo', 'Tensión constante. Codos fijos.', 'assets/videos/curl_biceps_polea_baja.mp4', 'assets/posters/curl_biceps_polea_baja.jpg'),
('curl_predicador_maquina', 'Curl Predicador Máquina', 'Brazos', 'Bíceps', 'Bajo', 'Aisla el bíceps en rango elongado.', 'assets/videos/curl_predicador_maquina.mp4', 'assets/posters/curl_predicador_maquina.jpg'),
('curl_martillo', 'Curl Martillo Mancuernas', 'Brazos', 'Braquiorradial', 'Bajo', 'Agarre neutro, palmas enfrentadas.', 'assets/videos/curl_martillo.mp4', 'assets/posters/curl_martillo.jpg'),
('curl_biceps_barra_z', 'Curl Bíceps Barra Z', 'Brazos', 'Bíceps', 'Bajo', 'Protege muñecas, subir sin balanceo.', 'assets/videos/curl_biceps_barra_z.mp4', 'assets/posters/curl_biceps_barra_z.jpg'),
('press_frances_mancuernas', 'Press Francés Mancuernas', 'Brazos', 'Tríceps', 'Bajo', 'Bajar mancuernas junto a la cabeza.', 'assets/videos/press_frances_mancuernas.mp4', 'assets/posters/press_frances_mancuernas.jpg'),
('extension_triceps_polea_barra', 'Extensión Tríceps Polea Barra', 'Brazos', 'Tríceps', 'Bajo', 'Barra recta activa más cabeza lateral.', 'assets/videos/extension_triceps_polea_barra.mp4', 'assets/posters/extension_triceps_polea_barra.jpg'),
('fondos_triceps_maquina', 'Fondos Tríceps Máquina', 'Brazos', 'Tríceps', 'Bajo', 'Extender completamente, seguridad total.', 'assets/videos/fondos_triceps_maquina.mp4', 'assets/posters/fondos_triceps_maquina.jpg'),
('curl_inverso_barra', 'Curl Inverso con Barra', 'Brazos', 'Antebrazo', 'Bajo', 'Agarre prono (palmas hacia abajo).', 'assets/videos/curl_inverso_barra.mp4', 'assets/posters/curl_inverso_barra.jpg'),

-- CORE
('hiperextension_espalda', 'Hiperextensión Espalda 45°', 'Core', 'Erectores/Glúteo', 'Bajo', 'Bajar hasta perpendicular y subir a horizontal.', 'assets/videos/hiperextension_espalda.mp4', 'assets/posters/hiperextension_espalda.jpg'),
('buenos_dias_mancuernas', 'Buenos Días con Mancuernas', 'Core', 'Erectores/Isquios', 'Medio', 'Bisagra de cadera, espalda neutra.', 'assets/videos/buenos_dias_mancuernas.mp4', 'assets/posters/buenos_dias_mancuernas.jpg'),
('plancha_abdominal', 'Plancha Abdominal', 'Core', 'Abdominales', 'Bajo', 'Cuerpo en línea recta, contraer glúteos.', 'assets/videos/plancha_abdominal.mp4', 'assets/posters/plancha_abdominal.jpg'),
('crunch_maquina', 'Crunch en Máquina', 'Core', 'Abdominales', 'Bajo', 'Ajustar punto de pivote a la columna.', 'assets/videos/crunch_maquina.mp4', 'assets/posters/crunch_maquina.jpg'),
('rotacion_polea_pallof', 'Pallof Press Polea', 'Core', 'Oblicuos', 'Bajo', 'Empujar sin que el tronco rote.', 'assets/videos/rotacion_polea_pallof.mp4', 'assets/posters/rotacion_polea_pallof.jpg');


-- ── PASO 3: Agregar FK de sustitución ─────────────────────

ALTER TABLE ejercicios
    ADD CONSTRAINT fk_ejercicio_sustitucion
    FOREIGN KEY (sustitucion_id) REFERENCES ejercicios(id) ON DELETE SET NULL;

-- ── PASO 4: Asignar sustitutos ──────────────────────────────

-- Tren Inferior
UPDATE ejercicios SET sustitucion_id = 'hip_thrust_maquina'          WHERE id = 'hip_thrust_barra';
UPDATE ejercicios SET sustitucion_id = 'hip_thrust_barra'            WHERE id = 'hip_thrust_maquina';
UPDATE ejercicios SET sustitucion_id = 'prensa_45'                   WHERE id = 'sentadilla_libre_barra';
UPDATE ejercicios SET sustitucion_id = 'prensa_45'                   WHERE id = 'sentadilla_bulgara';
UPDATE ejercicios SET sustitucion_id = 'sentadilla_bulgara'          WHERE id = 'prensa_45';
UPDATE ejercicios SET sustitucion_id = 'prensa_45'                   WHERE id = 'extension_cuadriceps_maquina';
UPDATE ejercicios SET sustitucion_id = 'curl_nordico'                WHERE id = 'curl_femoral_sentado';
UPDATE ejercicios SET sustitucion_id = 'curl_femoral_sentado'         WHERE id = 'curl_nordico';
UPDATE ejercicios SET sustitucion_id = 'abduccion_maquina'           WHERE id = 'aduccion_maquina';
UPDATE ejercicios SET sustitucion_id = 'aduccion_maquina'            WHERE id = 'abduccion_maquina';
UPDATE ejercicios SET sustitucion_id = 'gemelos_sentado_maquina'      WHERE id = 'elevacion_gemelos_prensa';
UPDATE ejercicios SET sustitucion_id = 'elevacion_gemelos_prensa'     WHERE id = 'gemelos_sentado_maquina';

-- Empuje / Tracción / Otros
UPDATE ejercicios SET sustitucion_id = 'press_pecho_maquina'          WHERE id = 'press_banca_barra_plano';
UPDATE ejercicios SET sustitucion_id = 'press_banca_mancuernas'       WHERE id = 'press_banca_barra_plano';
UPDATE ejercicios SET sustitucion_id = 'jalon_agarre_ancho'           WHERE id = 'dominadas';
UPDATE ejercicios SET sustitucion_id = 'dominadas'                   WHERE id = 'jalon_agarre_ancho';
UPDATE ejercicios SET sustitucion_id = 'curl_biceps_polea_baja'       WHERE id = 'curl_biceps_barra_z';
UPDATE ejercicios SET sustitucion_id = 'extension_triceps_polea_barra' WHERE id = 'press_frances_mancuernas';
UPDATE ejercicios SET sustitucion_id = 'buenos_dias_mancuernas'       WHERE id = 'hiperextension_espalda';

-- Verificación final
SELECT categoria, id, nombre, sustitucion_id FROM ejercicios ORDER BY categoria;