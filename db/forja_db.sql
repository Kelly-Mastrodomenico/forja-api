-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 11-03-2026 a las 01:13:43
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `forja_db`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `alimentos`
--

CREATE TABLE `alimentos` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) DEFAULT NULL,
  `nombre` varchar(150) NOT NULL,
  `marca` varchar(100) DEFAULT NULL,
  `calorias_100g` decimal(7,2) DEFAULT NULL,
  `proteinas_100g` decimal(7,2) DEFAULT NULL,
  `carbohidratos_100g` decimal(7,2) DEFAULT NULL,
  `grasas_100g` decimal(7,2) DEFAULT NULL,
  `fibra_100g` decimal(7,2) DEFAULT NULL,
  `es_escaneado` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `alimentos`
--

INSERT INTO `alimentos` (`id`, `usuario_id`, `nombre`, `marca`, `calorias_100g`, `proteinas_100g`, `carbohidratos_100g`, `grasas_100g`, `fibra_100g`, `es_escaneado`) VALUES
(1, 1, 'Leche Sin lactosa', 'Celta', 59.00, 10.00, 4.40, 0.20, NULL, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `analisis_sangre`
--

CREATE TABLE `analisis_sangre` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `pdf_url` varchar(255) DEFAULT NULL,
  `valores_json` text DEFAULT NULL,
  `recomendaciones_ia` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `checkin_fotos`
--

CREATE TABLE `checkin_fotos` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `foto_url` varchar(255) NOT NULL,
  `analisis_ia` text DEFAULT NULL,
  `tipo` enum('frontal','lateral','posterior') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ciclo_menstrual`
--

CREATE TABLE `ciclo_menstrual` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `fecha_inicio` date NOT NULL,
  `duracion_dias` tinyint(4) DEFAULT 28,
  `sintomas` text DEFAULT NULL,
  `fase_actual` enum('folicular','ovulatoria','lutea','menstruacion') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ejercicios`
--

CREATE TABLE `ejercicios` (
  `id` varchar(60) NOT NULL,
  `nombre` varchar(120) NOT NULL,
  `categoria` enum('Tren Inferior','Tracción','Empuje','Hombro','Brazos','Core') NOT NULL,
  `enfoque_muscular` varchar(100) DEFAULT NULL,
  `riesgo` enum('Bajo','Medio','Alto') DEFAULT 'Bajo',
  `instrucciones` text DEFAULT NULL,
  `video_url` varchar(255) DEFAULT NULL,
  `poster_url` varchar(255) DEFAULT NULL,
  `sustitucion_id` varchar(60) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `ejercicios`
--

INSERT INTO `ejercicios` (`id`, `nombre`, `categoria`, `enfoque_muscular`, `riesgo`, `instrucciones`, `video_url`, `poster_url`, `sustitucion_id`) VALUES
('abduccion_maquina', 'Abductores en Máquina', 'Tren Inferior', 'Glúteo Medio', 'Bajo', 'Inclinar el tronco ligeramente hacia adelante.', 'assets/videos/abduccion_maquina.mp4', 'assets/posters/abduccion_maquina.jpg', 'aduccion_maquina'),
('aduccion_maquina', 'Aductores en Máquina', 'Tren Inferior', 'Aductores', 'Bajo', 'Movimiento lento, evitar el choque de las placas al cerrar.', 'assets/videos/aduccion_maquina.mp4', 'assets/posters/aduccion_maquina.jpg', 'abduccion_maquina'),
('aperturas_polea_cruzada', 'Aperturas en Polea Cruzada', 'Empuje', 'Pectoral Mayor', 'Bajo', 'Llevar manos al centro cruzándolas ligeramente.', 'assets/videos/aperturas_polea_cruzada.mp4', 'assets/posters/aperturas_polea_cruzada.jpg', NULL),
('buenos_dias_mancuernas', 'Buenos Días con Mancuernas', 'Core', 'Erectores/Isquios', 'Medio', 'Bisagra de cadera, espalda neutra.', 'assets/videos/buenos_dias_mancuernas.mp4', 'assets/posters/buenos_dias_mancuernas.jpg', NULL),
('crunch_maquina', 'Crunch en Máquina', 'Core', 'Abdominales', 'Bajo', 'Ajustar punto de pivote a la columna.', 'assets/videos/crunch_maquina.mp4', 'assets/posters/crunch_maquina.jpg', NULL),
('curl_biceps_barra_z', 'Curl Bíceps Barra Z', 'Brazos', 'Bíceps', 'Bajo', 'Protege muñecas, subir sin balanceo.', 'assets/videos/curl_biceps_barra_z.mp4', 'assets/posters/curl_biceps_barra_z.jpg', 'curl_biceps_polea_baja'),
('curl_biceps_polea_baja', 'Curl de Bíceps Polea Baja', 'Brazos', 'Bíceps', 'Bajo', 'Tensión constante. Codos fijos.', 'assets/videos/curl_biceps_polea_baja.mp4', 'assets/posters/curl_biceps_polea_baja.jpg', NULL),
('curl_femoral_sentado', 'Curl Femoral Sentado', 'Tren Inferior', 'Isquiotibiales', 'Bajo', 'Lumbar pegada al respaldo. Bajar el rodillo en 3 segundos.', 'assets/videos/curl_femoral_sentado.mp4', 'assets/posters/curl_femoral_sentado.jpg', 'curl_nordico'),
('curl_inverso_barra', 'Curl Inverso con Barra', 'Brazos', 'Antebrazo', 'Bajo', 'Agarre prono (palmas hacia abajo).', 'assets/videos/curl_inverso_barra.mp4', 'assets/posters/curl_inverso_barra.jpg', NULL),
('curl_martillo', 'Curl Martillo Mancuernas', 'Brazos', 'Braquiorradial', 'Bajo', 'Agarre neutro, palmas enfrentadas.', 'assets/videos/curl_martillo.mp4', 'assets/posters/curl_martillo.jpg', NULL),
('curl_nordico', 'Curl Nórdico', 'Tren Inferior', 'Isquiotibiales', 'Medio', 'Pies fijos, bajar el tronco frenando con los isquios.', 'assets/videos/curl_nordico.mp4', 'assets/posters/curl_nordico.jpg', 'curl_femoral_sentado'),
('curl_predicador_maquina', 'Curl Predicador Máquina', 'Brazos', 'Bíceps', 'Bajo', 'Aisla el bíceps en rango elongado.', 'assets/videos/curl_predicador_maquina.mp4', 'assets/posters/curl_predicador_maquina.jpg', NULL),
('dominadas', 'Dominadas (Asistidas/Libres)', 'Tracción', 'Dorsal Ancho', 'Bajo', 'Pecho hacia la barra al subir. Estirar completo abajo.', 'assets/videos/dominadas.mp4', 'assets/posters/dominadas.jpg', 'jalon_agarre_ancho'),
('elevacion_gemelos_prensa', 'Elevación de Gemelos en Prensa', 'Tren Inferior', 'Gastrocnemio', 'Bajo', 'Bajar talón al máximo estiramiento. Pausa arriba.', 'assets/videos/elevacion_gemelos_prensa.mp4', 'assets/posters/elevacion_gemelos_prensa.jpg', 'gemelos_sentado_maquina'),
('elevacion_lateral_mancuernas', 'Elevación Lateral Mancuernas', 'Hombro', 'Deltoide Lateral', 'Bajo', 'Ligera inclinación del torso adelante.', 'assets/videos/elevacion_lateral_mancuernas.mp4', 'assets/posters/elevacion_lateral_mancuernas.jpg', NULL),
('elevacion_lateral_maquina', 'Elevación Lateral en Máquina', 'Hombro', 'Deltoide Lateral', 'Bajo', 'Subir hasta alinear codo con hombro.', 'assets/videos/elevacion_lateral_maquina.mp4', 'assets/posters/elevacion_lateral_maquina.jpg', NULL),
('elevacion_lateral_polea', 'Elevación Lateral en Polea Baja', 'Hombro', 'Deltoide Lateral', 'Bajo', 'Tensión constante en rango inferior.', 'assets/videos/elevacion_lateral_polea.mp4', 'assets/posters/elevacion_lateral_polea.jpg', NULL),
('encogimiento_trapecio', 'Encogimiento Trapecios', 'Hombro', 'Trapecio Superior', 'Bajo', 'Subir hombros hacia orejas, sin rotación.', 'assets/videos/encogimiento_trapecio.mp4', 'assets/posters/encogimiento_trapecio.jpg', NULL),
('extension_cuadriceps_maquina', 'Extensión de Cuádriceps en Máquina', 'Tren Inferior', 'Cuádriceps', 'Bajo', 'Rodillo en los tobillos. Pausa en máxima extensión. Bajar controlado.', 'assets/videos/extension_cuadriceps_maquina.mp4', 'assets/posters/extension_cuadriceps_maquina.jpg', 'prensa_45'),
('extension_triceps_polea_barra', 'Extensión Tríceps Polea Barra', 'Brazos', 'Tríceps', 'Bajo', 'Barra recta activa más cabeza lateral.', 'assets/videos/extension_triceps_polea_barra.mp4', 'assets/posters/extension_triceps_polea_barra.jpg', NULL),
('extension_triceps_polea_cuerda', 'Extensión de Tríceps Polea Cuerda', 'Empuje', 'Tríceps', 'Bajo', 'Codos pegados al costado. Abrir cuerda al final.', 'assets/videos/extension_triceps_polea_cuerda.mp4', 'assets/posters/extension_triceps_polea_cuerda.jpg', NULL),
('extension_triceps_sobre_cabeza', 'Extensión Tríceps sobre Cabeza', 'Empuje', 'Tríceps', 'Bajo', 'Mancuerna detrás de la cabeza, codo fijo.', 'assets/videos/extension_triceps_sobre_cabeza.mp4', 'assets/posters/extension_triceps_sobre_cabeza.jpg', NULL),
('face_pull_polea', 'Face Pull con Cuerda', 'Tracción', 'Deltoide Posterior', 'Bajo', 'Tirar hacia la frente separando extremos.', 'assets/videos/face_pull_polea.mp4', 'assets/posters/face_pull_polea.jpg', NULL),
('fondos_triceps_maquina', 'Fondos Tríceps Máquina', 'Brazos', 'Tríceps', 'Bajo', 'Extender completamente, seguridad total.', 'assets/videos/fondos_triceps_maquina.mp4', 'assets/posters/fondos_triceps_maquina.jpg', NULL),
('gemelos_sentado_maquina', 'Gemelos Sentado en Máquina', 'Tren Inferior', 'Sóleo', 'Bajo', 'Rodilla flexionada. Movimiento controlado.', 'assets/videos/gemelos_sentado_maquina.mp4', 'assets/posters/gemelos_sentado_maquina.jpg', 'elevacion_gemelos_prensa'),
('hip_thrust_barra', 'Hip Thrust con Barra', 'Tren Inferior', 'Glúteo Mayor', 'Bajo', 'Espalda alta apoyada en el banco, barra sobre las caderas con almohadilla. Empujar hasta que el tronco quede paralelo al suelo.', 'assets/videos/hip_thrust_barra.mp4', 'assets/posters/hip_thrust_barra.jpg', 'hip_thrust_maquina'),
('hip_thrust_maquina', 'Hip Thrust en Máquina', 'Tren Inferior', 'Glúteo Mayor', 'Bajo', 'Tensión constante. Ideal para principiantes o control de carga.', 'assets/videos/hip_thrust_maquina.mp4', 'assets/posters/hip_thrust_maquina.jpg', 'hip_thrust_barra'),
('hiperextension_espalda', 'Hiperextensión Espalda 45°', 'Core', 'Erectores/Glúteo', 'Bajo', 'Bajar hasta perpendicular y subir a horizontal.', 'assets/videos/hiperextension_espalda.mp4', 'assets/posters/hiperextension_espalda.jpg', 'buenos_dias_mancuernas'),
('jalon_agarre_ancho', 'Jalón al Pecho Agarre Ancho', 'Tracción', 'Dorsal Ancho', 'Bajo', 'Llevar barra a la clavícula, codos hacia abajo.', 'assets/videos/jalon_agarre_ancho.mp4', 'assets/posters/jalon_agarre_ancho.jpg', 'dominadas'),
('jalon_agarre_neutro', 'Jalón Agarre Neutro', 'Tracción', 'Dorsal/Bíceps', 'Bajo', 'Palmas enfrentadas. Activa dorsal inferior.', 'assets/videos/jalon_agarre_neutro.mp4', 'assets/posters/jalon_agarre_neutro.jpg', NULL),
('pajaro_mancuernas', 'Pájaro con Mancuernas', 'Tracción', 'Deltoide Posterior', 'Bajo', 'Torso inclinado, elevar hacia los lados.', 'assets/videos/pajaro_mancuernas.mp4', 'assets/posters/pajaro_mancuernas.jpg', NULL),
('patada_gluteo_polea', 'Patada de Glúteo en Polea Baja', 'Tren Inferior', 'Glúteo Mayor', 'Bajo', 'Extender cadera hacia atrás con espalda recta.', 'assets/videos/patada_gluteo_polea.mp4', 'assets/posters/patada_gluteo_polea.jpg', NULL),
('patada_triceps_polea', 'Patada de Tríceps en Polea Alta', 'Empuje', 'Tríceps', 'Bajo', 'Torso inclinado, brazo paralelo al suelo.', 'assets/videos/patada_triceps_polea.mp4', 'assets/posters/patada_triceps_polea.jpg', NULL),
('peso_muerto_rumano_mancuernas', 'Peso Muerto Rumano con Mancuernas', 'Tren Inferior', 'Isquiotibiales/Glúteo', 'Medio', 'Bisagra de cadera. Bajar pegado a las piernas.', 'assets/videos/peso_muerto_rumano_mancuernas.mp4', 'assets/posters/peso_muerto_rumano_mancuernas.jpg', NULL),
('plancha_abdominal', 'Plancha Abdominal', 'Core', 'Abdominales', 'Bajo', 'Cuerpo en línea recta, contraer glúteos.', 'assets/videos/plancha_abdominal.mp4', 'assets/posters/plancha_abdominal.jpg', NULL),
('prensa_45', 'Prensa 45°', 'Tren Inferior', 'Cuádriceps/Glúteo', 'Bajo', 'Pies al ancho de hombros. Bajar hasta 90° de rodilla. No bloquear rodillas al subir.', 'assets/videos/prensa_45.mp4', 'assets/posters/prensa_45.jpg', 'sentadilla_bulgara'),
('press_banca_barra_plano', 'Press de Banca con Barra', 'Empuje', 'Pectoral Mayor', 'Medio', 'Barra al pecho (altura pezones) y empujar.', 'assets/videos/press_banca_barra.mp4', 'assets/posters/press_banca_barra.jpg', 'press_banca_mancuernas'),
('press_banca_mancuernas', 'Press de Banca con Mancuernas', 'Empuje', 'Pectoral Mayor', 'Bajo', 'Retracción escapular, bajar hasta altura del pecho.', 'assets/videos/press_banca_mancuernas.mp4', 'assets/posters/press_banca_mancuernas.jpg', NULL),
('press_frances_mancuernas', 'Press Francés Mancuernas', 'Brazos', 'Tríceps', 'Bajo', 'Bajar mancuernas junto a la cabeza.', 'assets/videos/press_frances_mancuernas.mp4', 'assets/posters/press_frances_mancuernas.jpg', 'extension_triceps_polea_barra'),
('press_hombro_maquina', 'Press de Hombro en Máquina', 'Empuje', 'Deltoide Anterior', 'Bajo', 'Seguridad máxima para series pesadas.', 'assets/videos/press_hombro_maquina.mp4', 'assets/posters/press_hombro_maquina.jpg', NULL),
('press_inclinado_mancuernas', 'Press Inclinado con Mancuernas', 'Empuje', 'Pectoral Superior', 'Bajo', 'Banco a 30-45 grados.', 'assets/videos/press_inclinado_mancuernas.mp4', 'assets/posters/press_inclinado_mancuernas.jpg', NULL),
('press_militar_mancuernas', 'Press Militar con Mancuernas', 'Empuje', 'Deltoide Anterior', 'Medio', 'No bloquear codos al subir.', 'assets/videos/press_militar_mancuernas.mp4', 'assets/posters/press_militar_mancuernas.jpg', NULL),
('press_pecho_maquina', 'Press de Pecho en Máquina', 'Empuje', 'Pectoral Mayor', 'Bajo', 'Convergente, permite trabajar a fallo con seguridad.', 'assets/videos/press_pecho_maquina.mp4', 'assets/posters/press_pecho_maquina.jpg', NULL),
('pullover_polea', 'Pullover en Polea Alta', 'Tracción', 'Dorsal/Serrato', 'Bajo', 'Brazos extendidos, tirar hacia muslos.', 'assets/videos/pullover_polea.mp4', 'assets/posters/pullover_polea.jpg', NULL),
('remo_mancuerna_unilateral', 'Remo con Mancuerna Unilateral', 'Tracción', 'Dorsal Ancho', 'Bajo', 'Codo hacia el techo, evitar rotar el tronco.', 'assets/videos/remo_mancuerna_unilateral.mp4', 'assets/posters/remo_mancuerna_unilateral.jpg', NULL),
('remo_maquina_pecho_apoyado', 'Remo Máquina Pecho Apoyado', 'Tracción', 'Dorsal/Romboides', 'Bajo', 'Elimina compensación lumbar.', 'assets/videos/remo_maquina_pecho_apoyado.mp4', 'assets/posters/remo_maquina_pecho_apoyado.jpg', NULL),
('remo_polea_baja', 'Remo en Polea Baja', 'Tracción', 'Dorsal/Trapecio', 'Bajo', 'Espalda neutra, tirar hacia el abdomen.', 'assets/videos/remo_polea_baja.mp4', 'assets/posters/remo_polea_baja.jpg', NULL),
('rotacion_externa_polea', 'Rotación Externa Polea', 'Hombro', 'Manguito Rotador', 'Bajo', 'Codo pegado al costado, rotar hacia afuera.', 'assets/videos/rotacion_externa_polea.mp4', 'assets/posters/rotacion_externa_polea.jpg', NULL),
('rotacion_interna_polea', 'Rotación Interna Polea', 'Hombro', 'Manguito Rotador', 'Bajo', 'Rotar hacia el abdomen.', 'assets/videos/rotacion_interna_polea.mp4', 'assets/posters/rotacion_interna_polea.jpg', NULL),
('rotacion_polea_pallof', 'Pallof Press Polea', 'Core', 'Oblicuos', 'Bajo', 'Empujar sin que el tronco rote.', 'assets/videos/rotacion_polea_pallof.mp4', 'assets/posters/rotacion_polea_pallof.jpg', NULL),
('sentadilla_bulgara', 'Sentadilla Búlgara con Mancuernas', 'Tren Inferior', 'Cuádriceps/Glúteo', 'Medio', 'Pie trasero elevado. Bajar hasta que la rodilla trasera casi toque el suelo.', 'assets/videos/sentadilla_bulgara.mp4', 'assets/posters/sentadilla_bulgara.jpg', 'prensa_45'),
('sentadilla_hack_maquina', 'Sentadilla Hack en Máquina', 'Tren Inferior', 'Cuádriceps', 'Bajo', 'Pies en la plataforma, espalda bien apoyada. Bajar controladamente buscando máxima flexión de rodilla sin levantar talones.', 'assets/videos/sentadilla_hack_maquina.mp4', 'assets/posters/sentadilla_hack_maquina.jpg', 'prensa_45'),
('sentadilla_libre_barra', 'Sentadilla Libre con Barra', 'Tren Inferior', 'Cuádriceps/Glúteo', 'Alto', 'Barra sobre trapecios. Bajar rompiendo el paralelo manteniendo espalda neutra.', 'assets/videos/sentadilla_libre_barra.mp4', 'assets/posters/sentadilla_libre_barra.jpg', 'sentadilla_hack_maquina'),
('zancada_caminando', 'Zancada Caminando con Mancuernas', 'Tren Inferior', 'Cuádriceps/Glúteo', 'Bajo', 'Paso largo, torso erguido.', 'assets/videos/zancada_caminando.mp4', 'assets/posters/zancada_caminando.jpg', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ejercicios_imagenes`
--

CREATE TABLE `ejercicios_imagenes` (
  `id` int(11) NOT NULL,
  `nombre_ingles` varchar(255) NOT NULL,
  `nombre_espanol` varchar(255) DEFAULT NULL,
  `gif_url` varchar(500) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `ejercicios_imagenes`
--

INSERT INTO `ejercicios_imagenes` (`id`, `nombre_ingles`, `nombre_espanol`, `gif_url`, `created_at`) VALUES
(1, 'barbell bench press', 'Press de banca', NULL, '2026-03-07 17:36:10'),
(2, 'tricep pushdown', 'Extensiones de tríceps', NULL, '2026-03-07 17:36:10'),
(3, 'dumbbell fly', 'Fondos', NULL, '2026-03-07 17:36:11'),
(4, 'lateral raises', 'Elevaciones laterales', NULL, '2026-03-07 17:36:11'),
(5, 'barbell row', 'Remo a dos manos', NULL, '2026-03-07 17:36:12'),
(6, 'dumbbell curl', 'Curl de bíceps', NULL, '2026-03-07 17:36:12'),
(7, 'deadlift', 'Peso muerto', NULL, '2026-03-07 17:36:12'),
(8, 'front raises', 'Elevaciones frontales', NULL, '2026-03-07 17:36:13'),
(9, 'plank', 'Abdominales', NULL, '2026-03-07 17:36:13'),
(10, 'goblet squat', 'Goblet Squat', NULL, '2026-03-07 17:36:13'),
(11, 'leg press', 'Prensa de piernas', NULL, '2026-03-07 17:36:14'),
(12, 'leg extension', 'Extensión de piernas', NULL, '2026-03-07 17:36:14'),
(13, 'leg curl', 'Curl de piernas', NULL, '2026-03-07 17:36:14'),
(14, 'dumbbell shoulder press', 'Prensa militar', NULL, '2026-03-07 17:36:14'),
(16, 'crunches', 'Abdominales', NULL, '2026-03-07 17:36:15'),
(18, 'running', 'Correr', NULL, '2026-03-07 17:36:15'),
(19, 'leg stretches', 'Estiramientos de piernas', NULL, '2026-03-07 17:36:15'),
(20, 'back stretches', 'Estiramientos de espalda', NULL, '2026-03-07 17:36:15'),
(21, 'shoulder stretches', 'Estiramientos de hombros', NULL, '2026-03-07 17:36:16'),
(22, 'abdominal stretches', 'Estiramientos de abdominales', NULL, '2026-03-07 17:36:16');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `log_entreno`
--

CREATE TABLE `log_entreno` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `plan_detalle_id` int(11) DEFAULT NULL,
  `fecha` date NOT NULL,
  `ejercicio_id` varchar(60) NOT NULL,
  `series_completadas` tinyint(4) DEFAULT NULL,
  `reps_completadas` varchar(20) DEFAULT NULL,
  `peso_kg` decimal(6,2) DEFAULT NULL,
  `rir` tinyint(4) DEFAULT NULL,
  `completado` tinyint(1) DEFAULT 0,
  `notas` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `medidas`
--

CREATE TABLE `medidas` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `peso_kg` decimal(5,2) DEFAULT NULL,
  `grasa_corporal` decimal(5,2) DEFAULT NULL,
  `masa_muscular` decimal(5,2) DEFAULT NULL,
  `masa_esqueletica` decimal(5,2) DEFAULT NULL,
  `contenido_agua` decimal(5,2) DEFAULT NULL,
  `imc` decimal(5,2) DEFAULT NULL,
  `grasa_visceral` tinyint(4) DEFAULT NULL,
  `metabolismo_basal` int(11) DEFAULT NULL,
  `cintura_cm` decimal(5,2) DEFAULT NULL,
  `cadera_cm` decimal(5,2) DEFAULT NULL,
  `pecho_cm` decimal(5,2) DEFAULT NULL,
  `cuello_cm` decimal(5,2) DEFAULT NULL,
  `bicep_der_cm` decimal(5,2) DEFAULT NULL,
  `bicep_izq_cm` decimal(5,2) DEFAULT NULL,
  `cuadriceps_der_cm` decimal(5,2) DEFAULT NULL,
  `cuadriceps_izq_cm` decimal(5,2) DEFAULT NULL,
  `pantorrilla_der_cm` decimal(5,2) DEFAULT NULL,
  `pantorrilla_izq_cm` decimal(5,2) DEFAULT NULL,
  `fuente` enum('manual','foto_bascula','bluetooth') DEFAULT 'manual',
  `notas` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `medidas`
--

INSERT INTO `medidas` (`id`, `usuario_id`, `fecha`, `peso_kg`, `grasa_corporal`, `masa_muscular`, `masa_esqueletica`, `contenido_agua`, `imc`, `grasa_visceral`, `metabolismo_basal`, `cintura_cm`, `cadera_cm`, `pecho_cm`, `cuello_cm`, `bicep_der_cm`, `bicep_izq_cm`, `cuadriceps_der_cm`, `cuadriceps_izq_cm`, `pantorrilla_der_cm`, `pantorrilla_izq_cm`, `fuente`, `notas`, `created_at`) VALUES
(1, 1, '2026-03-07', 54.30, 15.10, 36.50, 2.60, 28.70, 21.20, 5, 1216, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'foto_bascula', NULL, '2026-03-07 01:26:35');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `planes_entrenamiento`
--

CREATE TABLE `planes_entrenamiento` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `tipo_plan` enum('semanal','mensual') NOT NULL DEFAULT 'semanal',
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date DEFAULT NULL,
  `periodizacion` text DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `planes_entrenamiento`
--

INSERT INTO `planes_entrenamiento` (`id`, `usuario_id`, `tipo_plan`, `fecha_inicio`, `fecha_fin`, `periodizacion`, `activo`, `created_at`) VALUES
(1, 1, 'semanal', '2026-03-08', '2026-03-15', 'El plan de entrenamiento semanal se enfoca en un enfoque de periodización lineal, donde se aumenta la intensidad y el volumen de entrenamiento a lo largo de la semana. Esto se logra mediante la variación en el número de series, repeticiones y descanso entre ejercicios.', 0, '2026-03-08 19:35:49'),
(2, 1, 'semanal', '2026-03-08', '2026-03-15', 'El plan de entrenamiento semanal se enfoca en el desarrollo muscular y la fuerza, con un enfoque en la cadena posterior, glúteo, isquiotibiales y salud hormonal para mujeres. Se distribuye en 5 días de entrenamiento, con ejercicios que trabajan diferentes grupos musculares y se ajustan según el biotipo y objetivo de la persona.', 0, '2026-03-08 19:36:16'),
(3, 1, 'semanal', '2026-03-09', '2026-03-16', 'El plan de entrenamiento se enfoca en la ganancia de músculo, con un enfoque en el tren inferior y la cadena posterior, considerando el biotipo femenino y el objetivo de salud hormonal.', 0, '2026-03-09 00:47:38'),
(4, 1, 'semanal', '2026-03-09', '2026-03-16', 'El plan de entrenamiento está diseñado para un enfoque de hipertrofia muscular, con un énfasis en el desarrollo de la cadena posterior, glúteo, isquiotibiales y salud hormonal en mujeres. La periodización se basa en un modelo de entrenamiento por días de la semana, con un enfoque en diferentes grupos musculares cada día.', 0, '2026-03-09 00:48:02'),
(5, 1, 'semanal', '2026-03-09', '2026-03-16', 'El plan de entrenamiento se enfoca en el aumento de la masa muscular en mujeres, priorizando la cadena posterior, glúteo, isquiotibiales y salud hormonal. Se distribuye en 5 días de entrenamiento, con ejercicios que trabajan diferentes grupos musculares y se ajustan según el biotipo y objetivos de la persona.', 0, '2026-03-09 00:48:27'),
(6, 1, 'semanal', '2026-03-09', '2026-03-16', 'El plan de entrenamiento está diseñado para una mujer de 30 años con el objetivo de ganar músculo, enfocándose en la cadena posterior, glúteo, isquiotibiales y salud hormonal. Se realiza 5 días a la semana, con un enfoque en ejercicios compuestos y de aislamiento para estimular el crecimiento muscular.', 0, '2026-03-09 22:18:54'),
(7, 1, 'semanal', '2026-03-09', '2026-03-16', 'El plan de entrenamiento se enfoca en un enfoque de fuerza y volumen para ganar músculo, con un énfasis en la cadena posterior y glúteo para mujeres. Se distribuyen 5 días de entrenamiento, con un enfoque diferente cada día.', 0, '2026-03-09 22:34:21'),
(8, 1, 'semanal', '2026-03-09', '2026-03-16', 'El plan de entrenamiento está diseñado para maximizar el crecimiento muscular en mujeres, enfocándose en la cadena posterior, glúteo, isquiotibiales y salud hormonal. Se basa en un enfoque de periodización lineal, aumentando la intensidad y el volumen de entrenamiento a lo largo de la semana.', 0, '2026-03-09 22:35:11'),
(9, 1, 'semanal', '2026-03-09', '2026-03-16', 'El plan de entrenamiento está diseñado para aumentar la masa muscular y la fuerza, con un enfoque en el tren inferior y el tren superior. Se utiliza un sistema de periodización lineal, con un aumento progresivo del peso y la intensidad a lo largo de la semana.', 0, '2026-03-09 22:51:25'),
(10, 1, 'semanal', '2026-03-09', '2026-03-16', 'El plan de entrenamiento semanal se enfoca en un enfoque de periodización lineal, donde se aumenta la intensidad y el volumen de entrenamiento a lo largo de la semana. Se prioriza el trabajo de cadena posterior, glúteo, isquiotibiales y salud hormonal, adecuado para mujeres.', 0, '2026-03-09 22:54:39'),
(11, 1, 'semanal', '2026-03-10', '2026-03-17', 'El plan de entrenamiento semanal se enfoca en el desarrollo muscular y la fuerza, con un enfoque en la cadena posterior, glúteo, isquiotibiales y salud hormonal para mujeres. Se distribuye en 5 días de entrenamiento, con ejercicios específicos para cada grupo muscular.', 0, '2026-03-09 23:31:32'),
(12, 1, 'semanal', '2026-03-10', '2026-03-17', 'lineal', 1, '2026-03-10 22:46:37');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `plan_detalle`
--

CREATE TABLE `plan_detalle` (
  `id` int(11) NOT NULL,
  `plan_id` int(11) NOT NULL,
  `semana_numero` tinyint(4) NOT NULL DEFAULT 1,
  `dia_numero` tinyint(4) NOT NULL,
  `dia_semana` tinyint(1) DEFAULT NULL COMMENT '0=Lun,1=Mar,2=Mie,3=Jue,4=Vie,5=Sab,6=Dom',
  `nombre_dia` varchar(100) DEFAULT NULL,
  `ejercicio_id` varchar(60) NOT NULL,
  `orden` tinyint(4) DEFAULT 1,
  `series` tinyint(4) DEFAULT NULL,
  `repeticiones` varchar(20) DEFAULT NULL,
  `rir` tinyint(4) DEFAULT NULL,
  `descanso` varchar(20) DEFAULT NULL,
  `nota_tecnica` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `plan_detalle`
--

INSERT INTO `plan_detalle` (`id`, `plan_id`, `semana_numero`, `dia_numero`, `dia_semana`, `nombre_dia`, `ejercicio_id`, `orden`, `series`, `repeticiones`, `rir`, `descanso`, `nota_tecnica`) VALUES
(1, 1, 1, 1, NULL, 'Lunes: Tren Inferior', 'sentadilla_hack_maquina', 1, 4, '10-12', 2, '90s', 'Pausa de 1s en el fondo'),
(2, 1, 1, 1, NULL, 'Lunes: Tren Inferior', 'prensa_45', 2, 3, '12-15', 2, '90s', 'Mantener la espalda recta'),
(3, 1, 1, 1, NULL, 'Lunes: Tren Inferior', 'curl_femoral_sentado', 3, 3, '10-12', 2, '90s', 'Concentrarse en la contracción de los isquiotibiales'),
(4, 1, 1, 1, NULL, 'Lunes: Tren Inferior', 'patada_gluteo_polea', 4, 3, '12-15', 2, '90s', 'Mantener la espalda recta y los glúteos contraídos'),
(5, 1, 1, 1, NULL, 'Lunes: Tren Inferior', 'elevacion_gemelos_prensa', 5, 3, '12-15', 2, '90s', 'Pausa de 1s en la parte superior'),
(6, 1, 1, 2, NULL, 'Martes: Tren Superior', 'dominadas', 1, 3, '8-10', 2, '120s', 'Mantener la espalda recta y los hombros bajos'),
(7, 1, 1, 2, NULL, 'Martes: Tren Superior', 'pullover_polea', 2, 3, '10-12', 2, '90s', 'Concentrarse en la contracción de los dorsales'),
(8, 1, 1, 2, NULL, 'Martes: Tren Superior', 'face_pull_polea', 3, 3, '12-15', 2, '90s', 'Mantener la espalda recta y los hombros bajos'),
(9, 1, 1, 2, NULL, 'Martes: Tren Superior', 'press_banca_mancuernas', 4, 3, '8-10', 2, '120s', 'Pausa de 1s en la parte superior'),
(10, 1, 1, 2, NULL, 'Martes: Tren Superior', 'extension_triceps_polea_cuerda', 5, 3, '12-15', 2, '90s', 'Concentrarse en la contracción de los tríceps'),
(11, 1, 1, 4, NULL, 'Jueves: Tren Inferior', 'sentadilla_bulgara', 1, 3, '8-10', 2, '120s', 'Mantener la espalda recta y los glúteos contraídos'),
(12, 1, 1, 4, NULL, 'Jueves: Tren Inferior', 'zancada_caminando', 2, 3, '10-12', 2, '90s', 'Concentrarse en la contracción de los cuádriceps y glúteos'),
(13, 1, 1, 4, NULL, 'Jueves: Tren Inferior', 'curl_nordico', 3, 3, '10-12', 2, '90s', 'Concentrarse en la contracción de los isquiotibiales'),
(14, 1, 1, 4, NULL, 'Jueves: Tren Inferior', 'hip_thrust_barra', 4, 3, '8-10', 2, '120s', 'Pausa de 1s en la parte superior'),
(15, 1, 1, 4, NULL, 'Jueves: Tren Inferior', 'elevacion_gemelos_prensa', 5, 3, '12-15', 2, '90s', 'Pausa de 1s en la parte superior'),
(16, 1, 1, 5, NULL, 'Viernes: Tren Superior', 'jalon_agarre_ancho', 1, 3, '8-10', 2, '120s', 'Mantener la espalda recta y los hombros bajos'),
(17, 1, 1, 5, NULL, 'Viernes: Tren Superior', 'remo_polea_baja', 2, 3, '10-12', 2, '90s', 'Concentrarse en la contracción de los dorsales'),
(18, 1, 1, 5, NULL, 'Viernes: Tren Superior', 'press_hombro_maquina', 3, 3, '10-12', 2, '90s', 'Mantener la espalda recta y los hombros bajos'),
(19, 1, 1, 5, NULL, 'Viernes: Tren Superior', 'aperturas_polea_cruzada', 4, 3, '12-15', 2, '90s', 'Concentrarse en la contracción de los pectorales'),
(20, 1, 1, 5, NULL, 'Viernes: Tren Superior', 'fondos_triceps_maquina', 5, 3, '12-15', 2, '90s', 'Concentrarse en la contracción de los tríceps'),
(21, 2, 1, 1, NULL, 'Lunes: Tren Inferior', 'sentadilla_hack_maquina', 1, 4, '10-12', 2, '90s', 'Pausa de 1s en el fondo'),
(22, 2, 1, 1, NULL, 'Lunes: Tren Inferior', 'patada_gluteo_polea', 2, 3, '12-15', 2, '60s', 'Enfócate en la contracción del glúteo'),
(23, 2, 1, 1, NULL, 'Lunes: Tren Inferior', 'curl_femoral_sentado', 3, 4, '10-12', 2, '90s', 'Mantén la espalda recta'),
(24, 2, 1, 1, NULL, 'Lunes: Tren Inferior', 'extension_cuadriceps_maquina', 4, 3, '12-15', 2, '60s', 'Extiende completamente la pierna'),
(25, 2, 1, 1, NULL, 'Lunes: Tren Inferior', 'elevacion_gemelos_prensa', 5, 3, '12-15', 2, '60s', 'Eleva los talones lo más alto posible'),
(26, 2, 1, 2, NULL, 'Martes: Tracción y Hombros', 'dominadas', 1, 3, '8-10', 2, '90s', 'Mantén el cuerpo recto'),
(27, 2, 1, 2, NULL, 'Martes: Tracción y Hombros', 'face_pull_polea', 2, 3, '12-15', 2, '60s', 'Enfócate en la contracción del hombro'),
(28, 2, 1, 2, NULL, 'Martes: Tracción y Hombros', 'jalon_agarre_ancho', 3, 4, '10-12', 2, '90s', 'Mantén la espalda recta'),
(29, 2, 1, 2, NULL, 'Martes: Tracción y Hombros', 'encogimiento_trapecio', 4, 3, '12-15', 2, '60s', 'Enfócate en la contracción del trapecio'),
(30, 2, 1, 2, NULL, 'Martes: Tracción y Hombros', 'elevacion_lateral_mancuernas', 5, 3, '12-15', 2, '60s', 'Eleva los brazos lateralmente'),
(31, 2, 1, 3, NULL, 'Miércoles: Empuje', 'press_banca_mancuernas', 1, 4, '8-10', 2, '90s', 'Mantén la espalda recta'),
(32, 2, 1, 3, NULL, 'Miércoles: Empuje', 'aperturas_polea_cruzada', 2, 3, '12-15', 2, '60s', 'Enfócate en la contracción del pecho'),
(33, 2, 1, 3, NULL, 'Miércoles: Empuje', 'press_hombro_maquina', 3, 3, '10-12', 2, '90s', 'Mantén la espalda recta'),
(34, 2, 1, 3, NULL, 'Miércoles: Empuje', 'extension_triceps_polea_barra', 4, 3, '12-15', 2, '60s', 'Extiende completamente el brazo'),
(35, 2, 1, 3, NULL, 'Miércoles: Empuje', 'patada_triceps_polea', 5, 3, '12-15', 2, '60s', 'Enfócate en la contracción del tríceps'),
(36, 2, 1, 4, NULL, 'Jueves: Tren Inferior', 'prensa_45', 1, 4, '10-12', 2, '90s', 'Pausa de 1s en el fondo'),
(37, 2, 1, 4, NULL, 'Jueves: Tren Inferior', 'zancada_caminando', 2, 3, '10-12', 2, '90s', 'Mantén la espalda recta'),
(38, 2, 1, 4, NULL, 'Jueves: Tren Inferior', 'peso_muerto_rumano_mancuernas', 3, 4, '8-10', 2, '90s', 'Mantén la espalda recta'),
(39, 2, 1, 4, NULL, 'Jueves: Tren Inferior', 'abduccion_maquina', 4, 3, '12-15', 2, '60s', 'Enfócate en la contracción del glúteo'),
(40, 2, 1, 4, NULL, 'Jueves: Tren Inferior', 'hip_thrust_maquina', 5, 3, '12-15', 2, '60s', 'Enfócate en la contracción del glúteo'),
(41, 2, 1, 5, NULL, 'Viernes: Core y Brazos', 'crunch_maquina', 1, 3, '12-15', 2, '60s', 'Enfócate en la contracción del abdomen'),
(42, 2, 1, 5, NULL, 'Viernes: Core y Brazos', 'plancha_abdominal', 2, 3, '30-60s', 2, '60s', 'Mantén la posición durante el tiempo indicado'),
(43, 2, 1, 5, NULL, 'Viernes: Core y Brazos', 'curl_biceps_polea_baja', 3, 3, '10-12', 2, '60s', 'Enfócate en la contracción del bíceps'),
(44, 2, 1, 5, NULL, 'Viernes: Core y Brazos', 'press_frances_mancuernas', 4, 3, '10-12', 2, '60s', 'Extiende completamente el brazo'),
(45, 2, 1, 5, NULL, 'Viernes: Core y Brazos', 'fondos_triceps_maquina', 5, 3, '12-15', 2, '60s', 'Enfócate en la contracción del tríceps'),
(46, 3, 1, 1, NULL, 'Lunes: Tren Inferior', 'sentadilla_hack_maquina', 1, 4, '10-12', 2, '90s', 'Pausa de 1s en el fondo'),
(47, 3, 1, 1, NULL, 'Lunes: Tren Inferior', 'patada_gluteo_polea', 2, 3, '12-15', 2, '60s', 'Concentración en el glúteo'),
(48, 3, 1, 1, NULL, 'Lunes: Tren Inferior', 'curl_femoral_sentado', 3, 4, '10-12', 2, '90s', 'Mantener la espalda recta'),
(49, 3, 1, 1, NULL, 'Lunes: Tren Inferior', 'extension_cuadriceps_maquina', 4, 3, '12-15', 2, '60s', 'Extensión completa'),
(50, 3, 1, 1, NULL, 'Lunes: Tren Inferior', 'abduccion_maquina', 5, 3, '12-15', 2, '60s', 'Movimiento controlado'),
(51, 3, 1, 2, NULL, 'Martes: Tracción', 'dominadas', 1, 4, '8-10', 2, '90s', 'Squeeze en la parte superior'),
(52, 3, 1, 2, NULL, 'Martes: Tracción', 'remo_polea_baja', 2, 3, '10-12', 2, '60s', 'Mantener la espalda recta'),
(53, 3, 1, 2, NULL, 'Martes: Tracción', 'pullover_polea', 3, 3, '12-15', 2, '60s', 'Movimiento suave'),
(54, 3, 1, 2, NULL, 'Martes: Tracción', 'face_pull_polea', 4, 3, '12-15', 2, '60s', 'Concentración en los hombros'),
(55, 3, 1, 2, NULL, 'Martes: Tracción', 'jalon_agarre_ancho', 5, 3, '10-12', 2, '60s', 'Mantener la espalda recta'),
(56, 3, 1, 3, NULL, 'Miércoles: Empuje', 'press_pecho_maquina', 1, 4, '8-10', 2, '90s', 'Extensión completa'),
(57, 3, 1, 3, NULL, 'Miércoles: Empuje', 'press_hombro_maquina', 2, 3, '10-12', 2, '60s', 'Movimiento controlado'),
(58, 3, 1, 3, NULL, 'Miércoles: Empuje', 'patada_triceps_polea', 3, 3, '12-15', 2, '60s', 'Extensión completa'),
(59, 3, 1, 3, NULL, 'Miércoles: Empuje', 'extension_triceps_polea_cuerda', 4, 3, '12-15', 2, '60s', 'Movimiento suave'),
(60, 3, 1, 3, NULL, 'Miércoles: Empuje', 'elevacion_lateral_mancuernas', 5, 3, '12-15', 2, '60s', 'Concentración en los hombros'),
(61, 3, 1, 4, NULL, 'Jueves: Tren Inferior', 'prensa_45', 1, 4, '10-12', 2, '90s', 'Pausa de 1s en el fondo'),
(62, 3, 1, 4, NULL, 'Jueves: Tren Inferior', 'zancada_caminando', 2, 3, '10-12', 2, '60s', 'Mantener la espalda recta'),
(63, 3, 1, 4, NULL, 'Jueves: Tren Inferior', 'hip_thrust_barra', 3, 3, '10-12', 2, '60s', 'Concentración en el glúteo'),
(64, 3, 1, 4, NULL, 'Jueves: Tren Inferior', 'gemelos_sentado_maquina', 4, 3, '12-15', 2, '60s', 'Movimiento suave'),
(65, 3, 1, 4, NULL, 'Jueves: Tren Inferior', 'elevacion_gemelos_prensa', 5, 3, '12-15', 2, '60s', 'Extensión completa'),
(66, 3, 1, 5, NULL, 'Viernes: Core y Brazos', 'crunch_maquina', 1, 3, '12-15', 2, '60s', 'Movimiento controlado'),
(67, 3, 1, 5, NULL, 'Viernes: Core y Brazos', 'plancha_abdominal', 2, 3, '30-60s', 2, '60s', 'Mantener la posición'),
(68, 3, 1, 5, NULL, 'Viernes: Core y Brazos', 'curl_biceps_barra_z', 3, 3, '10-12', 2, '60s', 'Concentración en los bíceps'),
(69, 3, 1, 5, NULL, 'Viernes: Core y Brazos', 'fondos_triceps_maquina', 4, 3, '12-15', 2, '60s', 'Extensión completa'),
(70, 3, 1, 5, NULL, 'Viernes: Core y Brazos', 'press_frances_mancuernas', 5, 3, '10-12', 2, '60s', 'Movimiento suave'),
(71, 4, 1, 1, NULL, 'Lunes: Tren Inferior', 'sentadilla_hack_maquina', 1, 4, '10-12', 2, '90s', 'Pausa de 1s en el fondo'),
(72, 4, 1, 1, NULL, 'Lunes: Tren Inferior', 'hip_thrust_maquina', 2, 3, '12-15', 2, '90s', 'Enfócate en la contracción del glúteo'),
(73, 4, 1, 1, NULL, 'Lunes: Tren Inferior', 'curl_femoral_sentado', 3, 3, '10-12', 2, '90s', 'Mantén la espalda recta'),
(74, 4, 1, 1, NULL, 'Lunes: Tren Inferior', 'extension_cuadriceps_maquina', 4, 3, '12-15', 2, '90s', 'Extiende completamente la pierna'),
(75, 4, 1, 1, NULL, 'Lunes: Tren Inferior', 'patada_gluteo_polea', 5, 3, '12-15', 2, '90s', 'Enfócate en la contracción del glúteo'),
(76, 4, 1, 2, NULL, 'Martes: Tracción y Hombros', 'dominadas', 1, 3, '8-10', 2, '120s', 'Mantén el cuerpo recto'),
(77, 4, 1, 2, NULL, 'Martes: Tracción y Hombros', 'jalon_agarre_ancho', 2, 3, '10-12', 2, '120s', 'Enfócate en la contracción de la espalda'),
(78, 4, 1, 2, NULL, 'Martes: Tracción y Hombros', 'face_pull_polea', 3, 3, '12-15', 2, '90s', 'Mantén los hombros relajados'),
(79, 4, 1, 2, NULL, 'Martes: Tracción y Hombros', 'elevacion_lateral_mancuernas', 4, 3, '10-12', 2, '90s', 'Enfócate en la contracción del deltoides'),
(80, 4, 1, 2, NULL, 'Martes: Tracción y Hombros', 'rotacion_externa_polea', 5, 3, '12-15', 2, '90s', 'Mantén el brazo recto'),
(81, 4, 1, 4, NULL, 'Jueves: Empuje y Brazos', 'press_banca_mancuernas', 1, 3, '8-10', 2, '120s', 'Mantén el cuerpo recto'),
(82, 4, 1, 4, NULL, 'Jueves: Empuje y Brazos', 'aperturas_polea_cruzada', 2, 3, '10-12', 2, '120s', 'Enfócate en la contracción del pecho'),
(83, 4, 1, 4, NULL, 'Jueves: Empuje y Brazos', 'extension_triceps_polea_barra', 3, 3, '10-12', 2, '90s', 'Extiende completamente el brazo'),
(84, 4, 1, 4, NULL, 'Jueves: Empuje y Brazos', 'curl_biceps_polea_baja', 4, 3, '10-12', 2, '90s', 'Mantén la espalda recta'),
(85, 4, 1, 4, NULL, 'Jueves: Empuje y Brazos', 'press_frances_mancuernas', 5, 3, '10-12', 2, '90s', 'Enfócate en la contracción del tríceps'),
(86, 4, 1, 5, NULL, 'Viernes: Core y Tren Inferior', 'plancha_abdominal', 1, 3, '30-60s', 2, '90s', 'Mantén el cuerpo recto'),
(87, 4, 1, 5, NULL, 'Viernes: Core y Tren Inferior', 'rotacion_polea_pallof', 2, 3, '10-12', 2, '90s', 'Mantén la espalda recta'),
(88, 4, 1, 5, NULL, 'Viernes: Core y Tren Inferior', 'prensa_45', 3, 3, '10-12', 2, '120s', 'Pausa de 1s en el fondo'),
(89, 4, 1, 5, NULL, 'Viernes: Core y Tren Inferior', 'zancada_caminando', 4, 3, '10-12', 2, '120s', 'Mantén la espalda recta'),
(90, 4, 1, 5, NULL, 'Viernes: Core y Tren Inferior', 'abduccion_maquina', 5, 3, '12-15', 2, '90s', 'Enfócate en la contracción del glúteo'),
(91, 5, 1, 1, NULL, 'Lunes: Tren Inferior', 'sentadilla_hack_maquina', 1, 4, '10-12', 2, '90s', 'Pausa de 1s en el fondo'),
(92, 5, 1, 1, NULL, 'Lunes: Tren Inferior', 'hip_thrust_maquina', 2, 4, '12-15', 2, '90s', 'Enfócate en la contracción del glúteo'),
(93, 5, 1, 1, NULL, 'Lunes: Tren Inferior', 'curl_femoral_sentado', 3, 3, '10-12', 2, '90s', 'Mantén la espalda recta'),
(94, 5, 1, 1, NULL, 'Lunes: Tren Inferior', 'extension_cuadriceps_maquina', 4, 3, '12-15', 2, '90s', 'Extiende completamente la pierna'),
(95, 5, 1, 1, NULL, 'Lunes: Tren Inferior', 'abduccion_maquina', 5, 3, '12-15', 2, '90s', 'Abduce las piernas sin arquear la espalda'),
(96, 5, 1, 2, NULL, 'Martes: Tracción y Hombro', 'dominadas', 1, 3, '8-10', 2, '120s', 'Mantén el cuerpo recto'),
(97, 5, 1, 2, NULL, 'Martes: Tracción y Hombro', 'face_pull_polea', 2, 3, '12-15', 2, '90s', 'Enfócate en la contracción del hombro'),
(98, 5, 1, 2, NULL, 'Martes: Tracción y Hombro', 'jalon_agarre_ancho', 3, 3, '10-12', 2, '90s', 'Mantén la espalda recta'),
(99, 5, 1, 2, NULL, 'Martes: Tracción y Hombro', 'elevacion_lateral_mancuernas', 4, 3, '12-15', 2, '90s', 'Eleva las mancuernas sin arquear la espalda'),
(100, 5, 1, 2, NULL, 'Martes: Tracción y Hombro', 'encogimiento_trapecio', 5, 3, '12-15', 2, '90s', 'Enfócate en la contracción del trapecio'),
(101, 5, 1, 3, NULL, 'Miércoles: Empuje', 'press_banca_mancuernas', 1, 4, '8-10', 2, '120s', 'Mantén la espalda recta'),
(102, 5, 1, 3, NULL, 'Miércoles: Empuje', 'aperturas_polea_cruzada', 2, 3, '12-15', 2, '90s', 'Enfócate en la contracción del pecho'),
(103, 5, 1, 3, NULL, 'Miércoles: Empuje', 'press_inclinado_mancuernas', 3, 3, '10-12', 2, '90s', 'Mantén la espalda recta'),
(104, 5, 1, 3, NULL, 'Miércoles: Empuje', 'extension_triceps_polea_barra', 4, 3, '12-15', 2, '90s', 'Extiende completamente el brazo'),
(105, 5, 1, 3, NULL, 'Miércoles: Empuje', 'press_frances_mancuernas', 5, 3, '10-12', 2, '90s', 'Enfócate en la contracción del tríceps'),
(106, 5, 1, 4, NULL, 'Jueves: Tren Inferior', 'prensa_45', 1, 4, '10-12', 2, '90s', 'Pausa de 1s en el fondo'),
(107, 5, 1, 4, NULL, 'Jueves: Tren Inferior', 'patada_gluteo_polea', 2, 3, '12-15', 2, '90s', 'Enfócate en la contracción del glúteo'),
(108, 5, 1, 4, NULL, 'Jueves: Tren Inferior', 'zancada_caminando', 3, 3, '10-12', 2, '90s', 'Mantén la espalda recta'),
(109, 5, 1, 4, NULL, 'Jueves: Tren Inferior', 'gemelos_sentado_maquina', 4, 3, '12-15', 2, '90s', 'Enfócate en la contracción del gemelo'),
(110, 5, 1, 4, NULL, 'Jueves: Tren Inferior', 'elevacion_gemelos_prensa', 5, 3, '12-15', 2, '90s', 'Eleva los talones sin arquear la espalda'),
(111, 5, 1, 5, NULL, 'Viernes: Core y Brazos', 'plancha_abdominal', 1, 3, '30-60s', 2, '90s', 'Mantén la espalda recta'),
(112, 5, 1, 5, NULL, 'Viernes: Core y Brazos', 'curl_biceps_barra_z', 2, 3, '10-12', 2, '90s', 'Enfócate en la contracción del bíceps'),
(113, 5, 1, 5, NULL, 'Viernes: Core y Brazos', 'curl_martillo', 3, 3, '10-12', 2, '90s', 'Mantén la espalda recta'),
(114, 5, 1, 5, NULL, 'Viernes: Core y Brazos', 'fondos_triceps_maquina', 4, 3, '12-15', 2, '90s', 'Extiende completamente el brazo'),
(115, 5, 1, 5, NULL, 'Viernes: Core y Brazos', 'rotacion_polea_pallof', 5, 3, '12-15', 2, '90s', 'Enfócate en la contracción del core'),
(116, 6, 1, 1, NULL, 'Lunes: Tren Inferior', 'sentadilla_hack_maquina', 1, 4, '10-12', 2, '90s', 'Pausa de 1s en el fondo'),
(117, 6, 1, 1, NULL, 'Lunes: Tren Inferior', 'patada_gluteo_polea', 2, 3, '12-15', 2, '60s', 'Enfócate en la contracción del glúteo'),
(118, 6, 1, 1, NULL, 'Lunes: Tren Inferior', 'extension_cuadriceps_maquina', 3, 3, '10-12', 2, '60s', 'Mantén la rodilla en ángulo recto'),
(119, 6, 1, 1, NULL, 'Lunes: Tren Inferior', 'curl_femoral_sentado', 4, 3, '10-12', 2, '60s', 'Mantén la espalda recta'),
(120, 6, 1, 1, NULL, 'Lunes: Tren Inferior', 'elevacion_gemelos_prensa', 5, 3, '12-15', 2, '60s', 'Enfócate en la contracción de los gemelos'),
(121, 6, 1, 2, NULL, 'Martes: Tracción y Hombros', 'dominadas', 1, 3, '8-10', 2, '90s', 'Mantén el core enganchado'),
(122, 6, 1, 2, NULL, 'Martes: Tracción y Hombros', 'pullover_polea', 2, 3, '10-12', 2, '60s', 'Mantén la espalda recta'),
(123, 6, 1, 2, NULL, 'Martes: Tracción y Hombros', 'face_pull_polea', 3, 3, '12-15', 2, '60s', 'Enfócate en la contracción del hombro'),
(124, 6, 1, 2, NULL, 'Martes: Tracción y Hombros', 'encogimiento_trapecio', 4, 3, '10-12', 2, '60s', 'Mantén la espalda recta'),
(125, 6, 1, 2, NULL, 'Martes: Tracción y Hombros', 'elevacion_lateral_mancuernas', 5, 3, '10-12', 2, '60s', 'Mantén los brazos rectos'),
(126, 6, 1, 3, NULL, 'Miércoles: Empuje', 'press_banca_mancuernas', 1, 3, '8-10', 2, '90s', 'Mantén la espalda recta'),
(127, 6, 1, 3, NULL, 'Miércoles: Empuje', 'aperturas_polea_cruzada', 2, 3, '10-12', 2, '60s', 'Mantén los brazos rectos'),
(128, 6, 1, 3, NULL, 'Miércoles: Empuje', 'press_inclinado_mancuernas', 3, 3, '10-12', 2, '60s', 'Mantén la espalda recta'),
(129, 6, 1, 3, NULL, 'Miércoles: Empuje', 'extension_triceps_polea_cuerda', 4, 3, '12-15', 2, '60s', 'Mantén el brazo recto'),
(130, 6, 1, 3, NULL, 'Miércoles: Empuje', 'press_frances_mancuernas', 5, 3, '10-12', 2, '60s', 'Mantén la espalda recta'),
(131, 6, 1, 4, NULL, 'Jueves: Tren Inferior', 'prensa_45', 1, 3, '10-12', 2, '90s', 'Mantén la espalda recta'),
(132, 6, 1, 4, NULL, 'Jueves: Tren Inferior', 'zancada_caminando', 2, 3, '10-12', 2, '60s', 'Mantén la rodilla en ángulo recto'),
(133, 6, 1, 4, NULL, 'Jueves: Tren Inferior', 'hip_thrust_barra', 3, 3, '10-12', 2, '60s', 'Enfócate en la contracción del glúteo'),
(134, 6, 1, 4, NULL, 'Jueves: Tren Inferior', 'abduccion_maquina', 4, 3, '12-15', 2, '60s', 'Mantén la espalda recta'),
(135, 6, 1, 4, NULL, 'Jueves: Tren Inferior', 'curl_nordico', 5, 3, '10-12', 2, '60s', 'Mantén la espalda recta'),
(136, 6, 1, 5, NULL, 'Viernes: Core y Brazos', 'plancha_abdominal', 1, 3, '30-60s', 2, '60s', 'Mantén la espalda recta'),
(137, 6, 1, 5, NULL, 'Viernes: Core y Brazos', 'crunch_maquina', 2, 3, '10-12', 2, '60s', 'Mantén la espalda recta'),
(138, 6, 1, 5, NULL, 'Viernes: Core y Brazos', 'curl_biceps_barra_z', 3, 3, '10-12', 2, '60s', 'Mantén la espalda recta'),
(139, 6, 1, 5, NULL, 'Viernes: Core y Brazos', 'fondos_triceps_maquina', 4, 3, '10-12', 2, '60s', 'Mantén el brazo recto'),
(140, 6, 1, 5, NULL, 'Viernes: Core y Brazos', 'curl_predicador_maquina', 5, 3, '10-12', 2, '60s', 'Mantén la espalda recta'),
(141, 7, 1, 1, NULL, 'Lunes: Tren Inferior', 'sentadilla_hack_maquina', 1, 4, '10-12', 2, '90s', 'Pausa de 1s en el fondo'),
(142, 7, 1, 1, NULL, 'Lunes: Tren Inferior', 'curl_femoral_sentado', 2, 3, '12-15', 2, '60s', 'Mantener la espalda recta'),
(143, 7, 1, 1, NULL, 'Lunes: Tren Inferior', 'patada_gluteo_polea', 3, 3, '12-15', 2, '60s', 'Pausa de 1s en la contracción'),
(144, 7, 1, 1, NULL, 'Lunes: Tren Inferior', 'extension_cuadriceps_maquina', 4, 3, '12-15', 2, '60s', 'Mantener la rodilla en ángulo recto'),
(145, 7, 1, 1, NULL, 'Lunes: Tren Inferior', 'elevacion_gemelos_prensa', 5, 3, '12-15', 2, '60s', 'Pausa de 1s en la contracción'),
(146, 7, 1, 2, NULL, 'Martes: Tracción y Hombro', 'dominadas', 1, 3, '8-10', 2, '90s', 'Pausa de 1s en la contracción'),
(147, 7, 1, 2, NULL, 'Martes: Tracción y Hombro', 'pullover_polea', 2, 3, '10-12', 2, '60s', 'Mantener la espalda recta'),
(148, 7, 1, 2, NULL, 'Martes: Tracción y Hombro', 'face_pull_polea', 3, 3, '12-15', 2, '60s', 'Pausa de 1s en la contracción'),
(149, 7, 1, 2, NULL, 'Martes: Tracción y Hombro', 'elevacion_lateral_mancuernas', 4, 3, '12-15', 2, '60s', 'Mantener la espalda recta'),
(150, 7, 1, 2, NULL, 'Martes: Tracción y Hombro', 'rotacion_externa_polea', 5, 3, '12-15', 2, '60s', 'Pausa de 1s en la contracción'),
(151, 7, 1, 3, NULL, 'Miércoles: Empuje', 'press_banca_mancuernas', 1, 4, '8-10', 2, '90s', 'Pausa de 1s en la contracción'),
(152, 7, 1, 3, NULL, 'Miércoles: Empuje', 'aperturas_polea_cruzada', 2, 3, '10-12', 2, '60s', 'Mantener la espalda recta'),
(153, 7, 1, 3, NULL, 'Miércoles: Empuje', 'press_hombro_maquina', 3, 3, '10-12', 2, '60s', 'Pausa de 1s en la contracción'),
(154, 7, 1, 3, NULL, 'Miércoles: Empuje', 'extension_triceps_polea_cuerda', 4, 3, '12-15', 2, '60s', 'Mantener la espalda recta'),
(155, 7, 1, 3, NULL, 'Miércoles: Empuje', 'press_frances_mancuernas', 5, 3, '12-15', 2, '60s', 'Pausa de 1s en la contracción'),
(156, 7, 1, 4, NULL, 'Jueves: Tren Inferior', 'prensa_45', 1, 4, '8-10', 2, '90s', 'Pausa de 1s en el fondo'),
(157, 7, 1, 4, NULL, 'Jueves: Tren Inferior', 'peso_muerto_rumano_mancuernas', 2, 3, '8-10', 2, '90s', 'Mantener la espalda recta'),
(158, 7, 1, 4, NULL, 'Jueves: Tren Inferior', 'patada_gluteo_polea', 3, 3, '12-15', 2, '60s', 'Pausa de 1s en la contracción'),
(159, 7, 1, 4, NULL, 'Jueves: Tren Inferior', 'extension_cuadriceps_maquina', 4, 3, '12-15', 2, '60s', 'Mantener la rodilla en ángulo recto'),
(160, 7, 1, 4, NULL, 'Jueves: Tren Inferior', 'elevacion_gemelos_prensa', 5, 3, '12-15', 2, '60s', 'Pausa de 1s en la contracción'),
(161, 7, 1, 5, NULL, 'Viernes: Core y Brazos', 'crunch_maquina', 1, 3, '12-15', 2, '60s', 'Pausa de 1s en la contracción'),
(162, 7, 1, 5, NULL, 'Viernes: Core y Brazos', 'plancha_abdominal', 2, 3, '30-60s', 2, '60s', 'Mantener la espalda recta'),
(163, 7, 1, 5, NULL, 'Viernes: Core y Brazos', 'curl_biceps_polea_baja', 3, 3, '10-12', 2, '60s', 'Pausa de 1s en la contracción'),
(164, 7, 1, 5, NULL, 'Viernes: Core y Brazos', 'extension_triceps_polea_cuerda', 4, 3, '12-15', 2, '60s', 'Mantener la espalda recta'),
(165, 7, 1, 5, NULL, 'Viernes: Core y Brazos', 'press_frances_mancuernas', 5, 3, '12-15', 2, '60s', 'Pausa de 1s en la contracción'),
(166, 8, 1, 1, NULL, 'Lunes: Tren Inferior', 'sentadilla_hack_maquina', 1, 4, '10-12', 2, '90s', 'Pausa de 1s en el fondo'),
(167, 8, 1, 1, NULL, 'Lunes: Tren Inferior', 'hip_thrust_barra', 2, 3, '12-15', 2, '90s', 'Enfócate en la contracción del glúteo'),
(168, 8, 1, 1, NULL, 'Lunes: Tren Inferior', 'curl_femoral_sentado', 3, 3, '10-12', 2, '90s', 'Mantén la espalda recta'),
(169, 8, 1, 1, NULL, 'Lunes: Tren Inferior', 'patada_gluteo_polea', 4, 3, '12-15', 2, '90s', 'Enfócate en la contracción del glúteo'),
(170, 8, 1, 1, NULL, 'Lunes: Tren Inferior', 'abduccion_maquina', 5, 3, '12-15', 2, '90s', 'Mantén la espalda recta'),
(171, 8, 1, 2, NULL, 'Martes: Tracción', 'dominadas', 1, 3, '8-10', 2, '120s', 'Enfócate en la contracción de la espalda'),
(172, 8, 1, 2, NULL, 'Martes: Tracción', 'pullover_polea', 2, 3, '10-12', 2, '90s', 'Mantén la espalda recta'),
(173, 8, 1, 2, NULL, 'Martes: Tracción', 'face_pull_polea', 3, 3, '12-15', 2, '90s', 'Enfócate en la contracción del hombro'),
(174, 8, 1, 2, NULL, 'Martes: Tracción', 'remo_polea_baja', 4, 3, '10-12', 2, '90s', 'Mantén la espalda recta'),
(175, 8, 1, 2, NULL, 'Martes: Tracción', 'jalon_agarre_ancho', 5, 3, '8-10', 2, '120s', 'Enfócate en la contracción de la espalda'),
(176, 8, 1, 3, NULL, 'Miércoles: Empuje', 'press_banca_mancuernas', 1, 3, '8-10', 2, '120s', 'Enfócate en la contracción del pecho'),
(177, 8, 1, 3, NULL, 'Miércoles: Empuje', 'aperturas_polea_cruzada', 2, 3, '10-12', 2, '90s', 'Mantén la espalda recta'),
(178, 8, 1, 3, NULL, 'Miércoles: Empuje', 'press_hombro_maquina', 3, 3, '10-12', 2, '90s', 'Enfócate en la contracción del hombro'),
(179, 8, 1, 3, NULL, 'Miércoles: Empuje', 'extension_triceps_polea_cuerda', 4, 3, '12-15', 2, '90s', 'Mantén la espalda recta'),
(180, 8, 1, 3, NULL, 'Miércoles: Empuje', 'press_inclinado_mancuernas', 5, 3, '10-12', 2, '90s', 'Enfócate en la contracción del pecho'),
(181, 8, 1, 4, NULL, 'Jueves: Tren Inferior', 'prensa_45', 1, 3, '10-12', 2, '90s', 'Pausa de 1s en el fondo'),
(182, 8, 1, 4, NULL, 'Jueves: Tren Inferior', 'zancada_caminando', 2, 3, '10-12', 2, '90s', 'Mantén la espalda recta'),
(183, 8, 1, 4, NULL, 'Jueves: Tren Inferior', 'patada_gluteo_polea', 3, 3, '12-15', 2, '90s', 'Enfócate en la contracción del glúteo'),
(184, 8, 1, 4, NULL, 'Jueves: Tren Inferior', 'abduccion_maquina', 4, 3, '12-15', 2, '90s', 'Mantén la espalda recta'),
(185, 8, 1, 4, NULL, 'Jueves: Tren Inferior', 'curl_femoral_sentado', 5, 3, '10-12', 2, '90s', 'Mantén la espalda recta'),
(186, 8, 1, 5, NULL, 'Viernes: Core', 'crunch_maquina', 1, 3, '12-15', 2, '90s', 'Enfócate en la contracción del abdomen'),
(187, 8, 1, 5, NULL, 'Viernes: Core', 'plancha_abdominal', 2, 3, '30-60s', 2, '90s', 'Mantén la espalda recta'),
(188, 8, 1, 5, NULL, 'Viernes: Core', 'rotacion_polea_pallof', 3, 3, '10-12', 2, '90s', 'Enfócate en la contracción de los oblicuos'),
(189, 8, 1, 5, NULL, 'Viernes: Core', 'buenos_dias_mancuernas', 4, 3, '10-12', 2, '90s', 'Mantén la espalda recta'),
(190, 8, 1, 5, NULL, 'Viernes: Core', 'hiperextension_espalda', 5, 3, '12-15', 2, '90s', 'Enfócate en la contracción de la espalda'),
(191, 9, 1, 1, 0, 'Lunes: Tren Inferior', 'sentadilla_hack_maquina', 1, 4, '10-12', 2, '90s', 'Pausa de 1s en el fondo'),
(192, 9, 1, 1, 0, 'Lunes: Tren Inferior', 'hip_thrust_maquina', 2, 3, '12-15', 2, '90s', 'Concentrarse en la contracción del glúteo'),
(193, 9, 1, 1, 0, 'Lunes: Tren Inferior', 'extension_cuadriceps_maquina', 3, 3, '12-15', 2, '90s', 'Mantener la rodilla firme'),
(194, 9, 1, 1, 0, 'Lunes: Tren Inferior', 'curl_femoral_sentado', 4, 3, '10-12', 2, '90s', 'Concentrarse en la contracción del isquiotibial'),
(195, 9, 1, 1, 0, 'Lunes: Tren Inferior', 'elevacion_gemelos_prensa', 5, 3, '12-15', 2, '90s', 'Mantener la pierna firme'),
(196, 9, 1, 2, 1, 'Martes: Tren Superior', 'press_banca_mancuernas', 1, 4, '8-10', 2, '90s', 'Mantener la espalda recta'),
(197, 9, 1, 2, 1, 'Martes: Tren Superior', 'dominadas', 2, 3, '10-12', 2, '90s', 'Concentrarse en la contracción del dorsal'),
(198, 9, 1, 2, 1, 'Martes: Tren Superior', 'face_pull_polea', 3, 3, '12-15', 2, '90s', 'Mantener la espalda recta'),
(199, 9, 1, 2, 1, 'Martes: Tren Superior', 'elevacion_lateral_mancuernas', 4, 3, '10-12', 2, '90s', 'Concentrarse en la contracción del deltoide'),
(200, 9, 1, 2, 1, 'Martes: Tren Superior', 'curl_biceps_polea_baja', 5, 3, '10-12', 2, '90s', 'Mantener la muñeca firme'),
(201, 9, 1, 3, 2, 'Miércoles: Core', 'plancha_abdominal', 1, 3, '30-60s', 2, '90s', 'Mantener la espalda recta'),
(202, 9, 1, 3, 2, 'Miércoles: Core', 'rotacion_polea_pallof', 2, 3, '10-12', 2, '90s', 'Concentrarse en la contracción del oblicuo'),
(203, 9, 1, 3, 2, 'Miércoles: Core', 'crunch_maquina', 3, 3, '10-12', 2, '90s', 'Mantener la espalda recta'),
(204, 9, 1, 3, 2, 'Miércoles: Core', 'buenos_dias_mancuernas', 4, 3, '8-10', 2, '90s', 'Concentrarse en la contracción del erector'),
(205, 9, 1, 4, 4, 'Viernes: Tren Inferior', 'prensa_45', 1, 4, '8-10', 2, '90s', 'Pausa de 1s en el fondo'),
(206, 9, 1, 4, 4, 'Viernes: Tren Inferior', 'zancada_caminando', 2, 3, '10-12', 2, '90s', 'Concentrarse en la contracción del cuádriceps'),
(207, 9, 1, 4, 4, 'Viernes: Tren Inferior', 'patada_gluteo_polea', 3, 3, '12-15', 2, '90s', 'Mantener la pierna firme'),
(208, 9, 1, 4, 4, 'Viernes: Tren Inferior', 'curl_nordico', 4, 3, '10-12', 2, '90s', 'Concentrarse en la contracción del isquiotibial'),
(209, 9, 1, 4, 4, 'Viernes: Tren Inferior', 'elevacion_gemelos_prensa', 5, 3, '12-15', 2, '90s', 'Mantener la pierna firme'),
(210, 9, 1, 5, 5, 'Sábado: Tren Superior', 'press_hombro_maquina', 1, 4, '8-10', 2, '90s', 'Mantener la espalda recta'),
(211, 9, 1, 5, 5, 'Sábado: Tren Superior', 'jalon_agarre_ancho', 2, 3, '10-12', 2, '90s', 'Concentrarse en la contracción del dorsal'),
(212, 9, 1, 5, 5, 'Sábado: Tren Superior', 'face_pull_polea', 3, 3, '12-15', 2, '90s', 'Mantener la espalda recta'),
(213, 9, 1, 5, 5, 'Sábado: Tren Superior', 'elevacion_lateral_mancuernas', 4, 3, '10-12', 2, '90s', 'Concentrarse en la contracción del deltoide'),
(214, 9, 1, 5, 5, 'Sábado: Tren Superior', 'curl_biceps_polea_baja', 5, 3, '10-12', 2, '90s', 'Mantener la muñeca firme'),
(215, 10, 1, 1, 0, 'Lunes: Tren Inferior', 'sentadilla_hack_maquina', 1, 4, '10-12', 2, '90s', 'Pausa de 1s en el fondo'),
(216, 10, 1, 1, 0, 'Lunes: Tren Inferior', 'hip_thrust_maquina', 2, 3, '12-15', 2, '90s', 'Enfócate en la contracción del glúteo'),
(217, 10, 1, 1, 0, 'Lunes: Tren Inferior', 'curl_femoral_sentado', 3, 3, '10-12', 2, '90s', 'Mantén la espalda recta'),
(218, 10, 1, 1, 0, 'Lunes: Tren Inferior', 'extension_cuadriceps_maquina', 4, 3, '12-15', 2, '90s', 'Extiende completamente la pierna'),
(219, 10, 1, 2, 1, 'Martes: Tracción', 'dominadas', 1, 3, '8-10', 2, '120s', 'Mantén el cuerpo recto'),
(220, 10, 1, 2, 1, 'Martes: Tracción', 'pullover_polea', 2, 3, '10-12', 2, '90s', 'Enfócate en la expansión del pecho'),
(221, 10, 1, 2, 1, 'Martes: Tracción', 'face_pull_polea', 3, 3, '12-15', 2, '90s', 'Mantén los hombros bajos'),
(222, 10, 1, 2, 1, 'Martes: Tracción', 'remo_polea_baja', 4, 3, '10-12', 2, '90s', 'Mantén la espalda recta'),
(223, 10, 1, 3, 2, 'Miércoles: Empuje', 'press_banca_mancuernas', 1, 3, '8-10', 2, '120s', 'Mantén los codos cerca del cuerpo'),
(224, 10, 1, 3, 2, 'Miércoles: Empuje', 'press_hombro_maquina', 2, 3, '10-12', 2, '90s', 'Mantén los hombros bajos'),
(225, 10, 1, 3, 2, 'Miércoles: Empuje', 'extension_triceps_polea_cuerda', 3, 3, '12-15', 2, '90s', 'Extiende completamente el brazo'),
(226, 10, 1, 3, 2, 'Miércoles: Empuje', 'curl_biceps_polea_baja', 4, 3, '10-12', 2, '90s', 'Mantén la espalda recta'),
(227, 10, 1, 4, 3, 'Jueves: Tren Inferior', 'prensa_45', 1, 4, '10-12', 2, '90s', 'Pausa de 1s en el fondo'),
(228, 10, 1, 4, 3, 'Jueves: Tren Inferior', 'patada_gluteo_polea', 2, 3, '12-15', 2, '90s', 'Enfócate en la contracción del glúteo'),
(229, 10, 1, 4, 3, 'Jueves: Tren Inferior', 'sentadilla_bulgara', 3, 3, '10-12', 2, '90s', 'Mantén la espalda recta'),
(230, 10, 1, 4, 3, 'Jueves: Tren Inferior', 'elevacion_gemelos_prensa', 4, 3, '12-15', 2, '90s', 'Extiende completamente la pierna'),
(231, 10, 1, 5, 4, 'Viernes: Tracción', 'jalon_agarre_ancho', 1, 3, '8-10', 2, '120s', 'Mantén el cuerpo recto'),
(232, 10, 1, 5, 4, 'Viernes: Tracción', 'remo_mancuerna_unilateral', 2, 3, '10-12', 2, '90s', 'Mantén la espalda recta'),
(233, 10, 1, 5, 4, 'Viernes: Tracción', 'face_pull_polea', 3, 3, '12-15', 2, '90s', 'Mantén los hombros bajos'),
(234, 10, 1, 5, 4, 'Viernes: Tracción', 'pajaro_mancuernas', 4, 3, '10-12', 2, '90s', 'Mantén la espalda recta'),
(235, 10, 1, 6, 5, 'Sábado: Core', 'crunch_maquina', 1, 3, '12-15', 2, '90s', 'Enfócate en la contracción del abdomen'),
(236, 10, 1, 6, 5, 'Sábado: Core', 'plancha_abdominal', 2, 3, '30-60s', 2, '90s', 'Mantén el cuerpo recto'),
(237, 10, 1, 6, 5, 'Sábado: Core', 'rotacion_polea_pallof', 3, 3, '10-12', 2, '90s', 'Mantén la espalda recta'),
(238, 10, 1, 6, 5, 'Sábado: Core', 'buenos_dias_mancuernas', 4, 3, '10-12', 2, '90s', 'Mantén la espalda recta'),
(239, 10, 1, 7, 6, 'Domingo: Hombros y Brazos', 'elevacion_lateral_mancuernas', 1, 3, '10-12', 2, '90s', 'Mantén los hombros bajos'),
(240, 10, 1, 7, 6, 'Domingo: Hombros y Brazos', 'curl_biceps_polea_baja', 2, 3, '10-12', 2, '90s', 'Mantén la espalda recta'),
(241, 10, 1, 7, 6, 'Domingo: Hombros y Brazos', 'extension_triceps_polea_cuerda', 3, 3, '12-15', 2, '90s', 'Extiende completamente el brazo'),
(242, 10, 1, 7, 6, 'Domingo: Hombros y Brazos', 'curl_martillo', 4, 3, '10-12', 2, '90s', 'Mantén la espalda recta'),
(243, 11, 1, 1, 0, 'Lunes: Tren Inferior', 'sentadilla_hack_maquina', 1, 4, '10-12', 2, '90s', 'Pausa de 1s en el fondo'),
(244, 11, 1, 1, 0, 'Lunes: Tren Inferior', 'hip_thrust_barra', 2, 4, '10-12', 2, '90s', 'Enfócate en la contracción del glúteo'),
(245, 11, 1, 1, 0, 'Lunes: Tren Inferior', 'curl_femoral_sentado', 3, 4, '10-12', 2, '90s', 'Mantén la espalda recta'),
(246, 11, 1, 1, 0, 'Lunes: Tren Inferior', 'extension_cuadriceps_maquina', 4, 4, '12-15', 2, '60s', 'Extiende completamente la pierna'),
(247, 11, 1, 1, 0, 'Lunes: Tren Inferior', 'elevacion_gemelos_prensa', 5, 4, '12-15', 2, '60s', 'Eleva los talones lo más alto posible'),
(248, 11, 1, 2, 1, 'Martes: Tracción y Hombros', 'dominadas', 1, 4, '8-10', 2, '90s', 'Mantén el cuerpo recto'),
(249, 11, 1, 2, 1, 'Martes: Tracción y Hombros', 'remo_polea_baja', 2, 4, '10-12', 2, '90s', 'Mantén la espalda recta'),
(250, 11, 1, 2, 1, 'Martes: Tracción y Hombros', 'face_pull_polea', 3, 4, '12-15', 2, '60s', 'Enfócate en la contracción del hombro'),
(251, 11, 1, 2, 1, 'Martes: Tracción y Hombros', 'elevacion_lateral_polea', 4, 4, '12-15', 2, '60s', 'Eleva los brazos lateralmente'),
(252, 11, 1, 2, 1, 'Martes: Tracción y Hombros', 'encogimiento_trapecio', 5, 4, '12-15', 2, '60s', 'Encoge los hombros hacia arriba'),
(253, 11, 1, 3, 2, 'Miércoles: Empuje y Brazos', 'press_banca_mancuernas', 1, 4, '8-10', 2, '90s', 'Mantén el cuerpo recto'),
(254, 11, 1, 3, 2, 'Miércoles: Empuje y Brazos', 'aperturas_polea_cruzada', 2, 4, '10-12', 2, '90s', 'Mantén los brazos estirados'),
(255, 11, 1, 3, 2, 'Miércoles: Empuje y Brazos', 'extension_triceps_polea_barra', 3, 4, '12-15', 2, '60s', 'Extiende completamente el brazo'),
(256, 11, 1, 3, 2, 'Miércoles: Empuje y Brazos', 'curl_biceps_polea_baja', 4, 4, '10-12', 2, '60s', 'Mantén la espalda recta'),
(257, 11, 1, 3, 2, 'Miércoles: Empuje y Brazos', 'press_frances_mancuernas', 5, 4, '10-12', 2, '60s', 'Mantén los codos cerca del cuerpo'),
(258, 11, 1, 4, 4, 'Viernes: Tren Inferior y Core', 'prensa_45', 1, 4, '10-12', 2, '90s', 'Mantén la espalda recta'),
(259, 11, 1, 4, 4, 'Viernes: Tren Inferior y Core', 'patada_gluteo_polea', 2, 4, '12-15', 2, '60s', 'Enfócate en la contracción del glúteo'),
(260, 11, 1, 4, 4, 'Viernes: Tren Inferior y Core', 'buenos_dias_mancuernas', 3, 4, '10-12', 2, '60s', 'Mantén la espalda recta'),
(261, 11, 1, 4, 4, 'Viernes: Tren Inferior y Core', 'plancha_abdominal', 4, 4, '30-60s', 2, '30s', 'Mantén el cuerpo recto'),
(262, 11, 1, 4, 4, 'Viernes: Tren Inferior y Core', 'rotacion_polea_pallof', 5, 4, '10-12', 2, '60s', 'Mantén la espalda recta'),
(263, 11, 1, 5, 5, 'Sábado: Tracción y Hombros', 'jalon_agarre_ancho', 1, 4, '8-10', 2, '90s', 'Mantén el cuerpo recto'),
(264, 11, 1, 5, 5, 'Sábado: Tracción y Hombros', 'remo_maquina_pecho_apoyado', 2, 4, '10-12', 2, '90s', 'Mantén la espalda recta'),
(265, 11, 1, 5, 5, 'Sábado: Tracción y Hombros', 'elevacion_lateral_mancuernas', 3, 4, '12-15', 2, '60s', 'Eleva los brazos lateralmente'),
(266, 11, 1, 5, 5, 'Sábado: Tracción y Hombros', 'rotacion_externa_polea', 4, 4, '10-12', 2, '60s', 'Mantén la espalda recta'),
(267, 11, 1, 5, 5, 'Sábado: Tracción y Hombros', 'crunch_maquina', 5, 4, '12-15', 2, '60s', 'Mantén la espalda recta'),
(268, 12, 1, 1, 0, 'Lunes: Tren Inferior', 'sentadilla_hack_maquina', 1, 4, '10-12', 2, '90s', 'Pausa 1s'),
(269, 12, 1, 1, 0, 'Lunes: Tren Inferior', 'hip_thrust_barra', 2, 3, '12-15', 2, '90s', 'Asegurarse de mantener la espalda recta'),
(270, 12, 1, 1, 0, 'Lunes: Tren Inferior', 'curl_femoral_sentado', 3, 3, '10-12', 2, '90s', 'Pausa 1s'),
(271, 12, 1, 1, 0, 'Lunes: Tren Inferior', 'patada_gluteo_polea', 4, 3, '12-15', 2, '90s', 'Asegurarse de mantener la espalda recta'),
(272, 12, 1, 2, 1, 'Martes: Tracción', 'dominadas', 1, 3, '8-10', 2, '90s', 'Pausa 1s'),
(273, 12, 1, 2, 1, 'Martes: Tracción', 'jalon_agarre_ancho', 2, 3, '10-12', 2, '90s', 'Asegurarse de mantener la espalda recta'),
(274, 12, 1, 2, 1, 'Martes: Tracción', 'remo_polea_baja', 3, 3, '10-12', 2, '90s', 'Pausa 1s'),
(275, 12, 1, 3, 2, 'Miércoles: Empuje', 'press_banca_mancuernas', 1, 3, '8-10', 2, '90s', 'Pausa 1s'),
(276, 12, 1, 3, 2, 'Miércoles: Empuje', 'press_hombro_maquina', 2, 3, '10-12', 2, '90s', 'Asegurarse de mantener la espalda recta'),
(277, 12, 1, 3, 2, 'Miércoles: Empuje', 'elevacion_lateral_polea', 3, 3, '12-15', 2, '90s', 'Pausa 1s'),
(278, 12, 1, 4, 4, 'Viernes: Tren Inferior', 'sentadilla_bulgara', 1, 3, '10-12', 2, '90s', 'Pausa 1s'),
(279, 12, 1, 4, 4, 'Viernes: Tren Inferior', 'hip_thrust_maquina', 2, 3, '12-15', 2, '90s', 'Asegurarse de mantener la espalda recta'),
(280, 12, 1, 4, 4, 'Viernes: Tren Inferior', 'curl_nordico', 3, 3, '10-12', 2, '90s', 'Pausa 1s'),
(281, 12, 1, 5, 5, 'Sábado: Core', 'crunch_maquina', 1, 3, '12-15', 2, '90s', 'Pausa 1s'),
(282, 12, 1, 5, 5, 'Sábado: Core', 'plancha_abdominal', 2, 3, '30-60s', 2, '90s', 'Asegurarse de mantener la espalda recta'),
(283, 12, 1, 5, 5, 'Sábado: Core', 'rotacion_polea_pallof', 3, 3, '10-12', 2, '90s', 'Pausa 1s');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `plan_nutricional`
--

CREATE TABLE `plan_nutricional` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `plan_entreno_id` int(11) NOT NULL,
  `dia_semana` tinyint(1) NOT NULL COMMENT '0=Lun,1=Mar,...,6=Dom',
  `tipo_dia` varchar(50) NOT NULL COMMENT 'entreno|descanso',
  `nombre_dia` varchar(100) DEFAULT NULL COMMENT 'Lunes: Tren Inferior',
  `grupo_muscular` varchar(100) DEFAULT NULL,
  `fase_hormonal` varchar(30) DEFAULT NULL COMMENT 'folicular|lutea|menstrual|ovulatoria',
  `calorias_total` decimal(7,1) NOT NULL,
  `proteinas_total` decimal(6,1) NOT NULL,
  `carbos_total` decimal(6,1) NOT NULL,
  `grasas_total` decimal(6,1) NOT NULL,
  `estrategia` text DEFAULT NULL COMMENT 'Descripción de la estrategia nutricional del día',
  `estado_metabolico` varchar(80) DEFAULT NULL COMMENT 'Anabólico Optimizado, etc.',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `plan_nutricional`
--

INSERT INTO `plan_nutricional` (`id`, `usuario_id`, `plan_entreno_id`, `dia_semana`, `tipo_dia`, `nombre_dia`, `grupo_muscular`, `fase_hormonal`, `calorias_total`, `proteinas_total`, `carbos_total`, `grasas_total`, `estrategia`, `estado_metabolico`, `created_at`) VALUES
(1, 1, 12, 0, 'entreno', 'Lunes: Tren Inferior', 'piernas, glúteo', NULL, 2450.0, 185.0, 280.0, 65.0, 'Alta recarga de carbohidratos para maximizar glucógeno en cadena posterior.', 'Anabólico Optimizado', '2026-03-10 22:46:44'),
(2, 1, 12, 1, 'entreno', 'Martes: Tracción', 'espalda', NULL, 2450.0, 185.0, 280.0, 65.0, 'Alta recarga de carbohidratos para maximizar glucógeno en cadena posterior.', 'Anabólico Optimizado', '2026-03-10 22:46:44'),
(3, 1, 12, 2, 'entreno', 'Miércoles: Empuje', 'pecho y hombros', NULL, 2450.0, 185.0, 280.0, 65.0, 'Alta recarga de carbohidratos para maximizar glucógeno en cadena posterior.', 'Anabólico Optimizado', '2026-03-10 22:46:44'),
(4, 1, 12, 3, 'descanso', 'Jueves', '', NULL, 2000.0, 150.0, 150.0, 70.0, 'Moderación en carbohidratos para mantener glucógeno.', 'Anabólico Moderado', '2026-03-10 22:46:44'),
(5, 1, 12, 4, 'entreno', 'Viernes: Tren Inferior', 'piernas', NULL, 2450.0, 185.0, 280.0, 65.0, 'Alta recarga de carbohidratos para maximizar glucógeno en cadena posterior.', 'Anabólico Optimizado', '2026-03-10 22:46:44'),
(6, 1, 12, 5, 'entreno', 'Sábado: Core', 'abdominales', NULL, 2450.0, 185.0, 280.0, 65.0, 'Alta recarga de carbohidratos para maximizar glucógeno en cadena posterior.', 'Anabólico Optimizado', '2026-03-10 22:46:44'),
(7, 1, 12, 6, 'descanso', 'Domingo', '', NULL, 2000.0, 150.0, 150.0, 70.0, 'Moderación en carbohidratos para mantener glucógeno.', 'Anabólico Moderado', '2026-03-10 22:46:44');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `plan_nutricional_comidas`
--

CREATE TABLE `plan_nutricional_comidas` (
  `id` int(11) NOT NULL,
  `plan_nutricional_id` int(11) NOT NULL,
  `momento` varchar(30) NOT NULL COMMENT 'desayuno|almuerzo|merienda|cena|pre_entreno|post_entreno|media_manana',
  `nombre_comida` varchar(200) NOT NULL,
  `hora_sugerida` varchar(10) DEFAULT NULL,
  `ingredientes` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '[{nombre, cantidad_g, unidad, peso_crudo}]' CHECK (json_valid(`ingredientes`)),
  `calorias` decimal(6,1) DEFAULT NULL,
  `proteinas` decimal(5,1) DEFAULT NULL,
  `carbos` decimal(5,1) DEFAULT NULL,
  `grasas` decimal(5,1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `plan_nutricional_comidas`
--

INSERT INTO `plan_nutricional_comidas` (`id`, `plan_nutricional_id`, `momento`, `nombre_comida`, `hora_sugerida`, `ingredientes`, `calorias`, `proteinas`, `carbos`, `grasas`) VALUES
(1, 1, 'desayuno', 'Tortitas de Avena con Huevo', '08:00', '[{\"nombre\":\"Avena molida\",\"cantidad_g\":80,\"unidad\":\"g\",\"peso_crudo\":true},{\"nombre\":\"Claras de huevo\",\"cantidad_g\":200,\"unidad\":\"ml\",\"peso_crudo\":false},{\"nombre\":\"Crema de almendras\",\"cantidad_g\":15,\"unidad\":\"g\",\"peso_crudo\":false}]', 420.0, 32.0, 55.0, 12.0),
(2, 1, 'comida pre-entreno', 'Fruta con Yogur', '12:00', '[{\"nombre\":\"Plátano\",\"cantidad_g\":150,\"unidad\":\"g\",\"peso_crudo\":true},{\"nombre\":\"Yogur griego\",\"cantidad_g\":200,\"unidad\":\"g\",\"peso_crudo\":true}]', 250.0, 20.0, 40.0, 0.0),
(3, 1, 'cena', 'Pollo con Arroz y Verduras', '19:00', '[{\"nombre\":\"Pechuga de pollo\",\"cantidad_g\":120,\"unidad\":\"g\",\"peso_crudo\":true},{\"nombre\":\"Arroz integral\",\"cantidad_g\":100,\"unidad\":\"g\",\"peso_crudo\":true},{\"nombre\":\"Brócoli\",\"cantidad_g\":100,\"unidad\":\"g\",\"peso_crudo\":true}]', 400.0, 40.0, 60.0, 10.0),
(4, 2, 'desayuno', 'Avena con Frutas y Nueces', '08:00', '[{\"nombre\":\"Avena molida\",\"cantidad_g\":80,\"unidad\":\"g\",\"peso_crudo\":true},{\"nombre\":\"Plátano\",\"cantidad_g\":100,\"unidad\":\"g\",\"peso_crudo\":true},{\"nombre\":\"Nueces\",\"cantidad_g\":20,\"unidad\":\"g\",\"peso_crudo\":true}]', 400.0, 15.0, 60.0, 15.0),
(5, 2, 'comida pre-entreno', 'Tortilla de Huevo con Espinacas', '12:00', '[{\"nombre\":\"Huevos\",\"cantidad_g\":200,\"unidad\":\"g\",\"peso_crudo\":true},{\"nombre\":\"Espinacas\",\"cantidad_g\":100,\"unidad\":\"g\",\"peso_crudo\":true},{\"nombre\":\"Queso feta\",\"cantidad_g\":50,\"unidad\":\"g\",\"peso_crudo\":true}]', 250.0, 25.0, 10.0, 15.0),
(6, 2, 'cena', 'Salmón con Quinoa y Verduras', '19:00', '[{\"nombre\":\"Salmón\",\"cantidad_g\":120,\"unidad\":\"g\",\"peso_crudo\":true},{\"nombre\":\"Quinoa\",\"cantidad_g\":100,\"unidad\":\"g\",\"peso_crudo\":true},{\"nombre\":\"Brócoli\",\"cantidad_g\":100,\"unidad\":\"g\",\"peso_crudo\":true}]', 420.0, 40.0, 40.0, 20.0),
(7, 3, 'desayuno', 'Batido de Proteínas con Frutas', '08:00', '[{\"nombre\":\"Proteína en polvo\",\"cantidad_g\":30,\"unidad\":\"g\",\"peso_crudo\":true},{\"nombre\":\"Leche de almendras\",\"cantidad_g\":200,\"unidad\":\"ml\",\"peso_crudo\":false},{\"nombre\":\"Plátano\",\"cantidad_g\":100,\"unidad\":\"g\",\"peso_crudo\":true}]', 250.0, 30.0, 30.0, 10.0),
(8, 3, 'comida pre-entreno', 'Tostada de Pan Integral con Aguacate', '12:00', '[{\"nombre\":\"Pan integral\",\"cantidad_g\":80,\"unidad\":\"g\",\"peso_crudo\":true},{\"nombre\":\"Aguacate\",\"cantidad_g\":100,\"unidad\":\"g\",\"peso_crudo\":true},{\"nombre\":\"Huevos\",\"cantidad_g\":100,\"unidad\":\"g\",\"peso_crudo\":true}]', 300.0, 15.0, 30.0, 20.0),
(9, 3, 'cena', 'Pollo con Patatas y Verduras', '19:00', '[{\"nombre\":\"Pechuga de pollo\",\"cantidad_g\":120,\"unidad\":\"g\",\"peso_crudo\":true},{\"nombre\":\"Patatas\",\"cantidad_g\":150,\"unidad\":\"g\",\"peso_crudo\":true},{\"nombre\":\"Brócoli\",\"cantidad_g\":100,\"unidad\":\"g\",\"peso_crudo\":true}]', 400.0, 35.0, 60.0, 10.0),
(10, 4, 'desayuno', 'Huevos Revueltos con Espinacas', '08:00', '[{\"nombre\":\"Huevos\",\"cantidad_g\":200,\"unidad\":\"g\",\"peso_crudo\":true},{\"nombre\":\"Espinacas\",\"cantidad_g\":100,\"unidad\":\"g\",\"peso_crudo\":true},{\"nombre\":\"Queso feta\",\"cantidad_g\":50,\"unidad\":\"g\",\"peso_crudo\":true}]', 250.0, 20.0, 10.0, 15.0),
(11, 4, 'comida', 'Pechuga de Pollo con Ensalada', '14:00', '[{\"nombre\":\"Pechuga de pollo\",\"cantidad_g\":120,\"unidad\":\"g\",\"peso_crudo\":true},{\"nombre\":\"Lechuga\",\"cantidad_g\":100,\"unidad\":\"g\",\"peso_crudo\":true},{\"nombre\":\"Tomate\",\"cantidad_g\":100,\"unidad\":\"g\",\"peso_crudo\":true}]', 300.0, 35.0, 10.0, 10.0),
(12, 4, 'cena', 'Salmón con Brócoli', '19:00', '[{\"nombre\":\"Salmón\",\"cantidad_g\":120,\"unidad\":\"g\",\"peso_crudo\":true},{\"nombre\":\"Brócoli\",\"cantidad_g\":100,\"unidad\":\"g\",\"peso_crudo\":true}]', 300.0, 30.0, 10.0, 15.0),
(13, 5, 'desayuno', 'Avena con Frutas y Nueces', '08:00', '[{\"nombre\":\"Avena molida\",\"cantidad_g\":80,\"unidad\":\"g\",\"peso_crudo\":true},{\"nombre\":\"Plátano\",\"cantidad_g\":100,\"unidad\":\"g\",\"peso_crudo\":true},{\"nombre\":\"Nueces\",\"cantidad_g\":20,\"unidad\":\"g\",\"peso_crudo\":true}]', 400.0, 15.0, 60.0, 15.0),
(14, 5, 'comida pre-entreno', 'Tortilla de Huevo con Espinacas', '12:00', '[{\"nombre\":\"Huevos\",\"cantidad_g\":200,\"unidad\":\"g\",\"peso_crudo\":true},{\"nombre\":\"Espinacas\",\"cantidad_g\":100,\"unidad\":\"g\",\"peso_crudo\":true},{\"nombre\":\"Queso feta\",\"cantidad_g\":50,\"unidad\":\"g\",\"peso_crudo\":true}]', 250.0, 25.0, 10.0, 15.0),
(15, 5, 'cena', 'Pollo con Quinoa y Verduras', '19:00', '[{\"nombre\":\"Pechuga de pollo\",\"cantidad_g\":120,\"unidad\":\"g\",\"peso_crudo\":true},{\"nombre\":\"Quinoa\",\"cantidad_g\":100,\"unidad\":\"g\",\"peso_crudo\":true},{\"nombre\":\"Brócoli\",\"cantidad_g\":100,\"unidad\":\"g\",\"peso_crudo\":true}]', 420.0, 40.0, 40.0, 20.0),
(16, 6, 'desayuno', 'Tortitas de Avena con Huevo', '08:00', '[{\"nombre\":\"Avena molida\",\"cantidad_g\":80,\"unidad\":\"g\",\"peso_crudo\":true},{\"nombre\":\"Claras de huevo\",\"cantidad_g\":200,\"unidad\":\"ml\",\"peso_crudo\":false},{\"nombre\":\"Crema de almendras\",\"cantidad_g\":15,\"unidad\":\"g\",\"peso_crudo\":false}]', 420.0, 32.0, 55.0, 12.0),
(17, 6, 'comida pre-entreno', 'Fruta con Yogur', '12:00', '[{\"nombre\":\"Plátano\",\"cantidad_g\":150,\"unidad\":\"g\",\"peso_crudo\":true},{\"nombre\":\"Yogur griego\",\"cantidad_g\":200,\"unidad\":\"g\",\"peso_crudo\":true}]', 250.0, 20.0, 40.0, 0.0),
(18, 6, 'cena', 'Salmón con Patatas y Verduras', '19:00', '[{\"nombre\":\"Salmón\",\"cantidad_g\":120,\"unidad\":\"g\",\"peso_crudo\":true},{\"nombre\":\"Patatas\",\"cantidad_g\":150,\"unidad\":\"g\",\"peso_crudo\":true},{\"nombre\":\"Brócoli\",\"cantidad_g\":100,\"unidad\":\"g\",\"peso_crudo\":true}]', 400.0, 35.0, 60.0, 10.0),
(19, 7, 'desayuno', 'Huevos Revueltos con Espinacas', '08:00', '[{\"nombre\":\"Huevos\",\"cantidad_g\":200,\"unidad\":\"g\",\"peso_crudo\":true},{\"nombre\":\"Espinacas\",\"cantidad_g\":100,\"unidad\":\"g\",\"peso_crudo\":true},{\"nombre\":\"Queso feta\",\"cantidad_g\":50,\"unidad\":\"g\",\"peso_crudo\":true}]', 250.0, 20.0, 10.0, 15.0),
(20, 7, 'comida', 'Pechuga de Pollo con Ensalada', '14:00', '[{\"nombre\":\"Pechuga de pollo\",\"cantidad_g\":120,\"unidad\":\"g\",\"peso_crudo\":true},{\"nombre\":\"Lechuga\",\"cantidad_g\":100,\"unidad\":\"g\",\"peso_crudo\":true},{\"nombre\":\"Tomate\",\"cantidad_g\":100,\"unidad\":\"g\",\"peso_crudo\":true}]', 300.0, 35.0, 10.0, 10.0),
(21, 7, 'cena', 'Salmón con Brócoli', '19:00', '[{\"nombre\":\"Salmón\",\"cantidad_g\":120,\"unidad\":\"g\",\"peso_crudo\":true},{\"nombre\":\"Brócoli\",\"cantidad_g\":100,\"unidad\":\"g\",\"peso_crudo\":true}]', 300.0, 30.0, 10.0, 15.0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `registro_comidas`
--

CREATE TABLE `registro_comidas` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `alimento_id` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `momento` enum('desayuno','media_manana','almuerzo','merienda','cena','pre_entreno','post_entreno') NOT NULL,
  `cantidad_gramos` decimal(7,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `registro_comidas`
--

INSERT INTO `registro_comidas` (`id`, `usuario_id`, `alimento_id`, `fecha`, `momento`, `cantidad_gramos`) VALUES
(1, 1, 1, '2026-03-07', 'desayuno', 100.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rutinas`
--

CREATE TABLE `rutinas` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL DEFAULT 'Mi rutina',
  `tipo` enum('diaria','semanal','mensual') NOT NULL,
  `contenido_json` longtext NOT NULL,
  `prompt_usado` text DEFAULT NULL,
  `activa` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `rutinas`
--

INSERT INTO `rutinas` (`id`, `usuario_id`, `nombre`, `tipo`, `contenido_json`, `prompt_usado`, `activa`, `created_at`) VALUES
(1, 1, 'Mi rutina', 'semanal', '{\"texto\":\"## PLAN NUTRICIONAL\\n- Calor\\u00edas totales: 1900 kcal\\n- Macros: 120g prote\\u00ednas, 200g carbohidratos, 70g grasas\\n- Plan de comidas:\\n  - Desayuno: 3 huevos (180g), 2 rebanadas de pan integral (120g), 1 taza de frutas (150g) = 40g prote\\u00ednas, 60g carbohidratos, 15g grasas\\n  - Media ma\\u00f1ana: 1 batido de prote\\u00ednas (30g), 1 taza de yogur griego (200g), 1 taza de frutas (150g) = 30g prote\\u00ednas, 30g carbohidratos, 0g grasas\\n  - Almuerzo: 120g de pollo a la parrilla, 1 taza de arroz integral (150g), 1 taza de vegetales (50g) = 35g prote\\u00ednas, 40g carbohidratos, 10g grasas\\n  - Merienda: 1 manzana (150g), 1 cucharada de mantequilla de man\\u00ed (16g) = 0g prote\\u00ednas, 30g carbohidratos, 8g grasas\\n  - Cena: 120g de salm\\u00f3n a la parrilla, 1 taza de quinoa (150g), 1 taza de vegetales (50g) = 35g prote\\u00ednas, 40g carbohidratos, 15g grasas\\n- Timing nutricional: 1 hora antes del entrenamiento, 1 hora despu\\u00e9s del entrenamiento, y 2-3 horas entre comidas\\n\\n## PLAN DE ENTRENAMIENTO\\n- D\\u00eda 1: Entrenamiento de pecho y triceps\\n  - Press de banca (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Inclinado de pecho (3 series, 10-15 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Extensiones de triceps (3 series, 12-15 repeticiones, RIR 2, descanso 60-90 segundos)\\n- D\\u00eda 2: Entrenamiento de espalda y b\\u00edceps\\n  - Remo con barra (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Peso muerto (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Curl de b\\u00edceps (3 series, 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n- D\\u00eda 3: Entrenamiento de piernas\\n  - Sentadillas (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Prensa de piernas (3 series, 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Extensiones de piernas (3 series, 12-15 repeticiones, RIR 2, descanso 60-90 segundos)\\n- D\\u00eda 4: Entrenamiento de hombros y abdominales\\n  - Press de hombros (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Elevaciones laterales (3 series, 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Planchas (3 series, 30-60 segundos, RIR 2, descanso 60-90 segundos)\\n- D\\u00eda 5: Entrenamiento de pecho y triceps\\n  - Press de banca inclinado (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Extensiones de triceps con cuerda (3 series, 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Curl de triceps (3 series, 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n\\n## PLAN DE CARDIO\\n- Tipo: Correr o caminar en cinta\\n- Duraci\\u00f3n: 20-30 minutos\\n- Intensidad: Moderada (60-70% de la frecuencia card\\u00edaca m\\u00e1xima)\\n\\n## PROGRESI\\u00d3N\\n- Aumentar el peso o la resistencia en un 2.5-5% cada semana\\n- Aumentar el n\\u00famero de repeticiones en un 2-3 cada semana\\n\\n## INDICACIONES PR\\u00c1CTICAS\\n- 1. Asegurarse de beber al menos 2 litros de agua al d\\u00eda\\n- 2. Dormir entre 7-9 horas cada noche para ayudar en la recuperaci\\u00f3n\\n- 3. Ajustar el plan de comidas seg\\u00fan las necesidades individuales y el progreso\\n\\nPor favor, env\\u00edeme su peso actualizado, medidas, rendimiento y sensaciones para continuar el seguimiento. Esto me permitir\\u00e1 ajustar y personalizar el plan para lograr sus objetivos de recomposici\\u00f3n.\"}', '\nActúa como un médico especialista en nutrición deportiva, recomposición corporal e hipertrofia y preparador físico profesional, usando exclusivamente evidencia científica actual (ISSN, ACSM, NSCA).\n\nNo quiero explicaciones teóricas largas. Quiero decisiones prácticas, estructuradas y justificadas brevemente.\n\nDATOS PERSONALES:\n- Nombre: Kelly Rodriguez\n- Sexo: mujer\n- Edad: 30 años\n- Altura: 160.00 cm\n- Nivel: intermedio\n- Días de entrenamiento: 5 días por semana\n- Objetivo: recomposicion\n- Patologías: ninguna\n- Tiene ciclo menstrual: Sí\n\n\n\nGenera un plan semanal completo con este formato exacto:\n\n## PLAN NUTRICIONAL\n- Calorías totales y macros (proteínas/carbohidratos/grasas en gramos)\n- Plan de comidas con cantidades exactas en gramos\n- Timing nutricional (cuándo comer respecto al entreno)\n\n## PLAN DE ENTRENAMIENTO\n- Rutina completa para 5 días\n- Por cada ejercicio: series, repeticiones, RIR, descanso\n- Orden de ejercicios por día\n\n## PLAN DE CARDIO\n- Tipo, duración e intensidad\n\n## PROGRESIÓN\n- Cómo progresar semana a semana\n\n## INDICACIONES PRÁCTICAS\n- 3 puntos clave para este usuario específico\n\nAl final pídeme que te envíe: peso actualizado, medidas, rendimiento y sensaciones para continuar el seguimiento.\n', 0, '2026-03-07 00:37:49'),
(2, 1, 'Mi rutina', 'diaria', '{\"texto\":\"## PLAN NUTRICIONAL\\n- Calor\\u00edas totales: 1800 kcal (deficit cal\\u00f3rico para recomposici\\u00f3n)\\n- Macros: \\n  - Prote\\u00ednas: 120g (1.5g\\/kg de peso corporal)\\n  - Carbohidratos: 150g (2g\\/kg de peso corporal)\\n  - Grasas: 70g (0.5g\\/kg de peso corporal)\\n- Plan de comidas:\\n  - Desayuno: 3 huevos (180g), 1 taza de avena (100g), 1 banana (100g)\\n  - Media ma\\u00f1ana: 1 batido de prote\\u00ednas (30g), 1 taza de frutas (150g)\\n  - Almuerzo: 120g de pechuga de pollo, 100g de arroz integral, 100g de br\\u00f3coli\\n  - Merienda: 1 yogurt griego (150g), 1\\/2 taza de frutos secos (50g)\\n  - Cena: 120g de salm\\u00f3n, 100g de quinoa, 100g de espinacas\\n- Timing nutricional: \\n  - Comer 1 hora antes del entrenamiento\\n  - Comer 30-60 minutos despu\\u00e9s del entrenamiento (batido de prote\\u00ednas y carbohidratos)\\n\\n## PLAN DE ENTRENAMIENTO\\n- D\\u00eda 1: Pecho y Tr\\u00edceps\\n  - Press de banca (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Inclinaciones (3 series, 10-15 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Extensiones de tr\\u00edceps (3 series, 12-15 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Fondos (3 series, 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n- D\\u00eda 2: Espalda y B\\u00edceps\\n  - Remo (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Peso muerto (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Curl de b\\u00edceps (3 series, 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Curl de martillo (3 series, 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n- D\\u00eda 3: Piernas\\n  - Sentadillas (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Prensa de piernas (3 series, 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Extensiones de piernas (3 series, 12-15 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Curl de piernas (3 series, 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n- D\\u00eda 4: Hombros y Abd\\u00f3men\\n  - Press de hombros (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Elevaciones laterales (3 series, 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Planchas (3 series, 30-60 segundos, RIR 2, descanso 60-90 segundos)\\n  - Russian twists (3 series, 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n- D\\u00eda 5: Entrenamiento de fuerza total\\n  - Peso muerto (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Sentadillas (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Press de banca (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n\\n## PLAN DE CARDIO\\n- Tipo: Cardio de baja intensidad (caminar, correr, bicicleta)\\n- Duraci\\u00f3n: 20-30 minutos\\n- Intensidad: 50-60% de la frecuencia card\\u00edaca m\\u00e1xima\\n\\n## PROGRESI\\u00d3N\\n- Aumentar el peso o la resistencia en 2.5-5kg cada semana\\n- Aumentar el n\\u00famero de repeticiones en 2-3 cada semana\\n\\n## INDICACIONES PR\\u00c1CTICAS\\n- Beber al menos 2 litros de agua al d\\u00eda\\n- Dormir 7-9 horas cada noche\\n- Realizar estiramientos despu\\u00e9s de cada entrenamiento\\n\\nPor favor, env\\u00edame tu peso actualizado, medidas, rendimiento y sensaciones para continuar el seguimiento. Esto me permitir\\u00e1 ajustar el plan y asegurarme de que est\\u00e1s progresando hacia tus objetivos.\"}', '\nActúa como un médico especialista en nutrición deportiva, recomposición corporal e hipertrofia y preparador físico profesional, usando exclusivamente evidencia científica actual (ISSN, ACSM, NSCA).\n\nNo quiero explicaciones teóricas largas. Quiero decisiones prácticas, estructuradas y justificadas brevemente.\n\nDATOS PERSONALES:\n- Nombre: Kelly Rodriguez\n- Sexo: mujer\n- Edad: 30 años\n- Altura: 160.00 cm\n- Nivel: intermedio\n- Días de entrenamiento: 5 días por semana\n- Objetivo: recomposicion\n- Patologías: ninguna\n- Tiene ciclo menstrual: Sí\n\n\n\nGenera un plan diaria completo con este formato exacto:\n\n## PLAN NUTRICIONAL\n- Calorías totales y macros (proteínas/carbohidratos/grasas en gramos)\n- Plan de comidas con cantidades exactas en gramos\n- Timing nutricional (cuándo comer respecto al entreno)\n\n## PLAN DE ENTRENAMIENTO\n- Rutina completa para 5 días\n- Por cada ejercicio: series, repeticiones, RIR, descanso\n- Orden de ejercicios por día\n\n## PLAN DE CARDIO\n- Tipo, duración e intensidad\n\n## PROGRESIÓN\n- Cómo progresar semana a semana\n\n## INDICACIONES PRÁCTICAS\n- 3 puntos clave para este usuario específico\n\nAl final pídeme que te envíe: peso actualizado, medidas, rendimiento y sensaciones para continuar el seguimiento.\n', 1, '2026-03-07 00:56:27'),
(3, 1, 'Mi rutina', 'semanal', '{\"texto\":\"## PLAN NUTRICIONAL\\n- Calor\\u00edas totales: 1800 kcal (para una mujer de 30 a\\u00f1os y 160 cm con objetivo de recomposici\\u00f3n y nivel de actividad alto)\\n- Macros: \\n  - Prote\\u00ednas: 120 g (1.5 g\\/kg de peso corporal, asumiendo un peso de 55 kg)\\n  - Carbohidratos: 200 g (foco en carbohidratos complejos)\\n  - Grasas: 70 g (foco en grasas saludables)\\n- Plan de comidas:\\n  - Desayuno: 3 huevos (180 g), 2 rebanadas de pan integral (60 g), 1 taza de frutas (150 g) = 390 kcal, 30 g prote\\u00ednas, 40 g carbohidratos, 20 g grasas\\n  - Media ma\\u00f1ana: 1 taza de yogur griego (200 g), 1\\/2 taza de frutas (75 g), 1 cucharada de miel (20 g) = 200 kcal, 20 g prote\\u00ednas, 30 g carbohidratos, 0 g grasas\\n  - Almuerzo: 120 g de pollo a la parrilla, 1 taza de arroz integral (150 g), 1 taza de br\\u00f3coli (55 g) = 400 kcal, 40 g prote\\u00ednas, 60 g carbohidratos, 10 g grasas\\n  - Merienda: 1 manzana (150 g), 1 cucharada de mantequilla de man\\u00ed (20 g) = 150 kcal, 4 g prote\\u00ednas, 20 g carbohidratos, 8 g grasas\\n  - Cena: 120 g de salm\\u00f3n a la parrilla, 1 taza de quinoa (150 g), 1 taza de espinacas (30 g) = 450 kcal, 40 g prote\\u00ednas, 60 g carbohidratos, 20 g grasas\\n- Timing nutricional: Comer 1-2 horas antes del entrenamiento, y 30-60 minutos despu\\u00e9s del entrenamiento con un snack de recuperaci\\u00f3n (20-30 g de prote\\u00ednas, 30-40 g de carbohidratos)\\n\\n## PLAN DE ENTRENAMIENTO\\n- D\\u00eda 1: Pecho y Tr\\u00edceps\\n  - Press de banca (3 series de 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Inclinaci\\u00f3n de press de banca (3 series de 10-15 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Extensiones de tr\\u00edceps (3 series de 12-15 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Fondos de tr\\u00edceps (3 series de 12-15 repeticiones, RIR 2, descanso 60-90 segundos)\\n- D\\u00eda 2: Espalda y B\\u00edceps\\n  - Remo con barra (3 series de 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Peso muerto (3 series de 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Curl de b\\u00edceps con barra (3 series de 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Curl de b\\u00edceps con mancuernas (3 series de 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n- D\\u00eda 3: Piernas\\n  - Sentadilla (3 series de 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Prensa de piernas (3 series de 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Extensiones de piernas (3 series de 12-15 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Curl de piernas (3 series de 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n- D\\u00eda 4: Hombros y Abdominales\\n  - Press de hombros (3 series de 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Elevaciones laterales (3 series de 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Elevaciones frontales (3 series de 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Plancha (3 series de 30-60 segundos, RIR 2, descanso 60-90 segundos)\\n- D\\u00eda 5: Entrenamiento de fuerza total\\n  - Peso muerto (3 series de 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Press de banca (3 series de 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Sentadilla (3 series de 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n\\n## PLAN DE CARDIO\\n- Tipo: Caminata en cinta o bicicleta est\\u00e1tica\\n- Duraci\\u00f3n: 20-30 minutos\\n- Intensidad: Moderada (50-60% de la frecuencia card\\u00edaca m\\u00e1xima)\\n\\n## PROGRESI\\u00d3N\\n- Aumentar el peso o la resistencia en un 2.5-5% cada semana\\n- Aumentar el n\\u00famero de repeticiones en un 2-3 cada semana\\n\\n## INDICACIONES PR\\u00c1CTICAS\\n- Beber al menos 2 litros de agua al d\\u00eda\\n- Dormir 7-9 horas cada noche\\n- Realizar estiramientos despu\\u00e9s de cada entrenamiento\\n\\nPor favor, env\\u00edeme su peso actualizado, medidas, rendimiento y sensaciones para continuar el seguimiento. Esto me permitir\\u00e1 ajustar y personalizar el plan de entrenamiento y nutrici\\u00f3n para lograr sus objetivos de recomposici\\u00f3n de manera efectiva y segura.\"}', '\nActúa como un médico especialista en nutrición deportiva, recomposición corporal e hipertrofia y preparador físico profesional, usando exclusivamente evidencia científica actual (ISSN, ACSM, NSCA).\n\nNo quiero explicaciones teóricas largas. Quiero decisiones prácticas, estructuradas y justificadas brevemente.\n\nDATOS PERSONALES:\n- Nombre: Kelly Rodriguez\n- Sexo: mujer\n- Edad: 30 años\n- Altura: 160.00 cm\n- Nivel: intermedio\n- Días de entrenamiento: 5 días por semana\n- Objetivo: recomposicion\n- Patologías: ninguna\n- Tiene ciclo menstrual: Sí\n\n\n\nGenera un plan semanal completo con este formato exacto:\n\n## PLAN NUTRICIONAL\n- Calorías totales y macros (proteínas/carbohidratos/grasas en gramos)\n- Plan de comidas con cantidades exactas en gramos\n- Timing nutricional (cuándo comer respecto al entreno)\n\n## PLAN DE ENTRENAMIENTO\n- Rutina completa para 5 días\n- Por cada ejercicio: series, repeticiones, RIR, descanso\n- Orden de ejercicios por día\n\n## PLAN DE CARDIO\n- Tipo, duración e intensidad\n\n## PROGRESIÓN\n- Cómo progresar semana a semana\n\n## INDICACIONES PRÁCTICAS\n- 3 puntos clave para este usuario específico\n\nAl final pídeme que te envíe: peso actualizado, medidas, rendimiento y sensaciones para continuar el seguimiento.\n', 0, '2026-03-07 01:00:15'),
(4, 1, 'Mi rutina', 'mensual', '{\"texto\":\"## PLAN NUTRICIONAL\\n- Calor\\u00edas totales: 1900 cal\\/d\\u00eda (para una mujer de 30 a\\u00f1os y 160 cm con objetivo de recomposici\\u00f3n)\\n- Macros: 120g prote\\u00ednas, 200g carbohidratos, 70g grasas\\n- Plan de comidas:\\n  - Desayuno: 3 huevos (180g), 2 rebanadas de pan integral (60g), 1 taza de frutas (150g) = 400 cal, 30g prote\\u00ednas, 60g carbohidratos, 20g grasas\\n  - Media ma\\u00f1ana: 1 batido de prote\\u00ednas (30g), 1 taza de frutas (150g) = 200 cal, 25g prote\\u00ednas, 30g carbohidratos, 10g grasas\\n  - Almuerzo: 120g de pollo a la parrilla, 100g de arroz integral, 100g de br\\u00f3coli = 400 cal, 35g prote\\u00ednas, 60g carbohidratos, 10g grasas\\n  - Merienda: 1 taza de yogur griego (200g), 1 taza de frutas (150g) = 200 cal, 20g prote\\u00ednas, 30g carbohidratos, 10g grasas\\n  - Cena: 120g de salm\\u00f3n a la parrilla, 100g de quinoa, 100g de espinacas = 400 cal, 35g prote\\u00ednas, 60g carbohidratos, 15g grasas\\n- Timing nutricional: comer 1 hora antes del entrenamiento, y 30 minutos despu\\u00e9s del entrenamiento (batido de prote\\u00ednas y carbohidratos)\\n\\n## PLAN DE ENTRENAMIENTO\\n- D\\u00eda 1: Pecho y Tr\\u00edceps\\n  - Press de banca (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Press de inclinaci\\u00f3n (3 series, 10-15 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Extensiones de tr\\u00edceps (3 series, 12-15 repeticiones, RIR 2, descanso 60-90 segundos)\\n- D\\u00eda 2: Espalda y B\\u00edceps\\n  - Remo a dos manos (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Peso muerto (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Curl de b\\u00edceps (3 series, 10-15 repeticiones, RIR 2, descanso 60-90 segundos)\\n- D\\u00eda 3: Piernas\\n  - Sentadillas (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Prensa de piernas (3 series, 10-15 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Extensiones de piernas (3 series, 12-15 repeticiones, RIR 2, descanso 60-90 segundos)\\n- D\\u00eda 4: Hombros y Abdominales\\n  - Press de hombros (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Elevaciones laterales (3 series, 10-15 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Planchas (3 series, 30-60 segundos, descanso 60-90 segundos)\\n- D\\u00eda 5: Cardio y Estiramientos\\n  - 30 minutos de cardio a intensidad moderada\\n  - Estiramientos para todos los grupos musculares\\n\\n## PLAN DE CARDIO\\n- Tipo: carrera o bicicleta est\\u00e1tica\\n- Duraci\\u00f3n: 30 minutos\\n- Intensidad: moderada (60-70% de la frecuencia card\\u00edaca m\\u00e1xima)\\n\\n## PROGRESI\\u00d3N\\n- Aumentar el peso o la resistencia en un 2.5-5% cada semana\\n- Aumentar el n\\u00famero de repeticiones en un 2-3 cada semana\\n\\n## INDICACIONES PR\\u00c1CTICAS\\n- Beber al menos 2 litros de agua al d\\u00eda\\n- Dormir 7-9 horas cada noche para ayudar en la recuperaci\\u00f3n\\n- Ajustar el plan de comidas seg\\u00fan las necesidades individuales y el progreso\\n\\nPor favor, env\\u00edame tu peso actualizado, medidas (cintura, cadera, muslo, brazo), rendimiento en los ejercicios y sensaciones generales despu\\u00e9s de un mes para continuar el seguimiento y ajustar el plan seg\\u00fan sea necesario.\"}', '\nActúa como un médico especialista en nutrición deportiva, recomposición corporal e hipertrofia y preparador físico profesional, usando exclusivamente evidencia científica actual (ISSN, ACSM, NSCA).\n\nNo quiero explicaciones teóricas largas. Quiero decisiones prácticas, estructuradas y justificadas brevemente.\n\nDATOS PERSONALES:\n- Nombre: Kelly Rodriguez\n- Sexo: mujer\n- Edad: 30 años\n- Altura: 160.00 cm\n- Nivel: intermedio\n- Días de entrenamiento: 5 días por semana\n- Objetivo: recomposicion\n- Patologías: ninguna\n- Tiene ciclo menstrual: Sí\n\n\n\nGenera un plan mensual completo con este formato exacto:\n\n## PLAN NUTRICIONAL\n- Calorías totales y macros (proteínas/carbohidratos/grasas en gramos)\n- Plan de comidas con cantidades exactas en gramos\n- Timing nutricional (cuándo comer respecto al entreno)\n\n## PLAN DE ENTRENAMIENTO\n- Rutina completa para 5 días\n- Por cada ejercicio: series, repeticiones, RIR, descanso\n- Orden de ejercicios por día\n\n## PLAN DE CARDIO\n- Tipo, duración e intensidad\n\n## PROGRESIÓN\n- Cómo progresar semana a semana\n\n## INDICACIONES PRÁCTICAS\n- 3 puntos clave para este usuario específico\n\nAl final pídeme que te envíe: peso actualizado, medidas, rendimiento y sensaciones para continuar el seguimiento.\n', 1, '2026-03-07 01:00:28'),
(5, 1, 'Mi rutina', 'diaria', '{\"texto\":\"## PLAN NUTRICIONAL\\n- Calor\\u00edas totales: 2200 cal, macros: 120g prote\\u00ednas, 250g carbohidratos, 70g grasas\\n- Plan de comidas:\\n  - Desayuno: 3 huevos (180g), 2 rebanadas de pan integral (120g), 1 vaso de leche sin lactosa (200g)\\n  - Media ma\\u00f1ana: 1 batido de prote\\u00ednas (30g), 1 pl\\u00e1tano (100g)\\n  - Almuerzo: 120g de pollo a la parrilla, 150g de arroz integral, 100g de br\\u00f3coli\\n  - Media tarde: 1 manzana (150g), 1 cucharada de mantequilla de man\\u00ed (16g)\\n  - Cena: 120g de salm\\u00f3n a la parrilla, 150g de quinoa, 100g de zanahorias\\n  - Antes de dormir: 1 vaso de leche sin lactosa (200g), 1 cucharada de case\\u00edna (30g)\\n- Timing nutricional: comer 1 hora antes del entrenamiento, 30 minutos despu\\u00e9s del entrenamiento (batido de prote\\u00ednas y carbohidratos)\\n\\n## PLAN DE ENTRENAMIENTO\\n- D\\u00eda 1: Pecho y Tr\\u00edceps\\n  - Press de banca (3 series, 8-12 repeticiones, RIR 2, 90 segundos de descanso)\\n  - Inclinaciones (3 series, 10-15 repeticiones, RIR 2, 90 segundos de descanso)\\n  - Extensiones de tr\\u00edceps (3 series, 12-15 repeticiones, RIR 2, 90 segundos de descanso)\\n  - Fondos (3 series, 10-12 repeticiones, RIR 2, 90 segundos de descanso)\\n- D\\u00eda 2: Espalda y B\\u00edceps\\n  - Remo (3 series, 8-12 repeticiones, RIR 2, 90 segundos de descanso)\\n  - Peso muerto (3 series, 8-12 repeticiones, RIR 2, 90 segundos de descanso)\\n  - Curl de b\\u00edceps (3 series, 10-12 repeticiones, RIR 2, 90 segundos de descanso)\\n  - Remo a una mano (3 series, 10-12 repeticiones, RIR 2, 90 segundos de descanso)\\n- D\\u00eda 3: Piernas\\n  - Sentadillas (3 series, 8-12 repeticiones, RIR 2, 90 segundos de descanso)\\n  - Prensa de piernas (3 series, 10-12 repeticiones, RIR 2, 90 segundos de descanso)\\n  - Extensiones de piernas (3 series, 12-15 repeticiones, RIR 2, 90 segundos de descanso)\\n  - Curl de piernas (3 series, 10-12 repeticiones, RIR 2, 90 segundos de descanso)\\n- D\\u00eda 4: Hombros y Abd\\u00f3men\\n  - Press de hombros (3 series, 8-12 repeticiones, RIR 2, 90 segundos de descanso)\\n  - Elevaciones laterales (3 series, 10-12 repeticiones, RIR 2, 90 segundos de descanso)\\n  - Crunch (3 series, 10-12 repeticiones, RIR 2, 90 segundos de descanso)\\n  - Russian twist (3 series, 10-12 repeticiones, RIR 2, 90 segundos de descanso)\\n- D\\u00eda 5: Revisi\\u00f3n\\n  - Revisar todos los grupos musculares con ejercicios anteriores\\n\\n## PLAN DE CARDIO\\n- 20 minutos de carrera en la cinta, 3 veces a la semana, a intensidad moderada\\n\\n## PROGRESI\\u00d3N\\n- Aumentar el peso en un 2.5% cada semana, o cuando se complete el n\\u00famero de repeticiones objetivo\\n\\n## INDICACIONES PR\\u00c1CTICAS\\n- Beber al menos 2 litros de agua al d\\u00eda\\n- Dormir 7-8 horas cada noche para una recuperaci\\u00f3n adecuada\\n- Ajustar el plan de comidas seg\\u00fan las necesidades individuales y el progreso\\n\\nPor favor, env\\u00edeme su peso actualizado, medidas corporales (incluyendo cintura y cadera), rendimiento en los ejercicios y sensaciones generales despu\\u00e9s de seguir este plan durante 4 semanas, para continuar el seguimiento y hacer ajustes seg\\u00fan sea necesario.\"}', '\nActúa como un médico especialista en nutrición deportiva, recomposición corporal e hipertrofia y preparador físico profesional, usando exclusivamente evidencia científica actual (ISSN, ACSM, NSCA).\n\nNo quiero explicaciones teóricas largas. Quiero decisiones prácticas, estructuradas y justificadas brevemente.\n\nDATOS PERSONALES:\n- Nombre: Kelly Rodriguez\n- Sexo: mujer\n- Edad: 30 años\n- Altura: 160.00 cm\n- Nivel: intermedio\n- Días de entrenamiento: 5 días por semana\n- Objetivo: ganar musculo\n- Patologías: ninguna\n- Tiene ciclo menstrual: Sí\n\nMEDIDAS CORPORALES ACTUALES:\n- Peso: 54.30 kg\n- Grasa corporal: 15.10%\n- Masa muscular: 36.50 kg\n- IMC: 21.20\n- Cintura:  cm\n- Cadera:  cm\nALIMENTOS HABITUALES DEL USUARIO: Leche Sin lactosa (Celta)\n\nGenera un plan diaria completo con este formato exacto:\n\n## PLAN NUTRICIONAL\n- Calorías totales y macros (proteínas/carbohidratos/grasas en gramos)\n- Plan de comidas con cantidades exactas en gramos\n- Timing nutricional (cuándo comer respecto al entreno)\n\n## PLAN DE ENTRENAMIENTO\n- Rutina completa para 5 días\n- Por cada ejercicio: series, repeticiones, RIR, descanso\n- Orden de ejercicios por día\n\n## PLAN DE CARDIO\n- Tipo, duración e intensidad\n\n## PROGRESIÓN\n- Cómo progresar semana a semana\n\n## INDICACIONES PRÁCTICAS\n- 3 puntos clave para este usuario específico\n\nAl final pídeme que te envíe: peso actualizado, medidas, rendimiento y sensaciones para continuar el seguimiento.\n', 1, '2026-03-07 12:30:40'),
(6, 1, 'Mi rutina', 'diaria', '{\"texto\":\"**PLAN NUTRICIONAL**\\n- Calor\\u00edas totales: 2200 calor\\u00edas\\n- Macros: 170g prote\\u00ednas, 250g carbohidratos, 70g grasas\\n- Plan de comidas:\\n  - Desayuno: 3 huevos (180g), 2 rebanadas de pan integral (120g), 1 vaso de leche sin lactosa (200g) - 400 calor\\u00edas, 30g prote\\u00ednas, 60g carbohidratos, 15g grasas\\n  - Media ma\\u00f1ana: 1 batido de prote\\u00ednas (30g), 1 pl\\u00e1tano (100g) - 200 calor\\u00edas, 25g prote\\u00ednas, 30g carbohidratos, 0g grasas\\n  - Almuerzo: 120g de pollo a la plancha, 150g de arroz integral, 100g de br\\u00f3coli - 400 calor\\u00edas, 40g prote\\u00ednas, 60g carbohidratos, 10g grasas\\n  - Merienda: 1 manzana (150g), 1 cucharada de mantequilla de man\\u00ed (16g) - 150 calor\\u00edas, 0g prote\\u00ednas, 30g carbohidratos, 8g grasas\\n  - Cena: 120g de salm\\u00f3n a la plancha, 150g de quinoa, 100g de espinacas - 400 calor\\u00edas, 40g prote\\u00ednas, 60g carbohidratos, 15g grasas\\n  - Cena tard\\u00eda (antes de dormir): 1 vaso de leche sin lactosa (200g), 1 cucharada de case\\u00edna (30g) - 200 calor\\u00edas, 20g prote\\u00ednas, 30g carbohidratos, 0g grasas\\n- Timing nutricional: \\n  - Desayuno 1 hora antes del entrenamiento\\n  - Media ma\\u00f1ana inmediatamente despu\\u00e9s del entrenamiento\\n  - Almuerzo 2 horas despu\\u00e9s del entrenamiento\\n  - Merienda 2 horas antes del entrenamiento (si el entrenamiento es por la tarde)\\n  - Cena 1 hora despu\\u00e9s del entrenamiento (si el entrenamiento es por la tarde)\\n  - Cena tard\\u00eda 30 minutos antes de dormir\\n\\n**PLAN DE ENTRENAMIENTO**\\n- D\\u00eda 1: Entrenamiento de pecho y tr\\u00edceps\\n  - Press de banca (3 series de 8-12 repeticiones, RIR 2, descanso 90 segundos)\\n  - Inclinaciones (3 series de 10-15 repeticiones, RIR 2, descanso 90 segundos)\\n  - Extensiones de tr\\u00edceps (3 series de 12-15 repeticiones, RIR 2, descanso 60 segundos)\\n  - Fondos (3 series de 10-12 repeticiones, RIR 2, descanso 90 segundos)\\n- D\\u00eda 2: Entrenamiento de espalda y b\\u00edceps\\n  - Remo (3 series de 8-12 repeticiones, RIR 2, descanso 90 segundos)\\n  - Peso muerto (3 series de 8-12 repeticiones, RIR 2, descanso 120 segundos)\\n  - Curl de b\\u00edceps (3 series de 10-12 repeticiones, RIR 2, descanso 60 segundos)\\n  - Remo a una mano (3 series de 10-12 repeticiones, RIR 2, descanso 90 segundos)\\n- D\\u00eda 3: Entrenamiento de piernas\\n  - Sentadillas (3 series de 8-12 repeticiones, RIR 2, descanso 120 segundos)\\n  - Prensa de piernas (3 series de 10-12 repeticiones, RIR 2, descanso 90 segundos)\\n  - Extensiones de piernas (3 series de 12-15 repeticiones, RIR 2, descanso 60 segundos)\\n  - Curl de piernas (3 series de 10-12 repeticiones, RIR 2, descanso 90 segundos)\\n- D\\u00eda 4: Entrenamiento de hombros y abdominales\\n  - Press de hombros (3 series de 8-12 repeticiones, RIR 2, descanso 90 segundos)\\n  - Elevaciones laterales (3 series de 10-12 repeticiones, RIR 2, descanso 60 segundos)\\n  - Elevaciones frontales (3 series de 10-12 repeticiones, RIR 2, descanso 60 segundos)\\n  - Planchas (3 series de 30-60 segundos, RIR 2, descanso 60 segundos)\\n- D\\u00eda 5: Entrenamiento de pecho y tr\\u00edceps\\n  - Press de banca inclinado (3 series de 8-12 repeticiones, RIR 2, descanso 90 segundos)\\n  - Extensiones de tr\\u00edceps con cuerda (3 series de 10-12 repeticiones, RIR 2, descanso 60 segundos)\\n  - Fondos inclinados (3 series de 10-12 repeticiones, RIR 2, descanso 90 segundos)\\n  - Tr\\u00edceps con barra (3 series de 10-12 repeticiones, RIR 2, descanso 60 segundos)\\n\\n**PLAN DE CARDIO**\\n- Tipo: Caminata en cinta o bicicleta est\\u00e1tica\\n- Duraci\\u00f3n: 20-30 minutos\\n- Intensidad: Moderada (50-60% de la frecuencia card\\u00edaca m\\u00e1xima)\\n\\n**PROGRESI\\u00d3N**\\n- Aumentar el peso o la resistencia en 2,5-5 kg cada semana\\n- Aumentar el n\\u00famero de repeticiones en 2-3 cada semana\\n\\n**INDICACIONES PR\\u00c1CTICAS**\\n- Asegurarse de consumir suficientes prote\\u00ednas despu\\u00e9s del entrenamiento para ayudar a la recuperaci\\u00f3n muscular\\n- Asegurarse de hidratarse adecuadamente antes, durante y despu\\u00e9s del entrenamiento\\n- Asegurarse de dormir lo suficiente (7-9 horas) para ayudar a la recuperaci\\u00f3n muscular y la ganancia de masa muscular\\n\\nPor favor, env\\u00edeme su peso actualizado, medidas, rendimiento y sensaciones en los pr\\u00f3ximos 7-10 d\\u00edas para continuar el seguimiento y ajustar el plan seg\\u00fan sea necesario.\"}', '\nActúa como un médico especialista en nutrición deportiva, recomposición corporal e hipertrofia y preparador físico profesional, usando exclusivamente evidencia científica actual (ISSN, ACSM, NSCA).\n\nNo quiero explicaciones teóricas largas. Quiero decisiones prácticas, estructuradas y justificadas brevemente.\n\nDATOS PERSONALES:\n- Nombre: Kelly Rodriguez\n- Sexo: mujer\n- Edad: 30 años\n- Altura: 160.00 cm\n- Nivel: intermedio\n- Días de entrenamiento: 5 días por semana\n- Objetivo: ganar musculo\n- Patologías: ninguna\n- Tiene ciclo menstrual: Sí\n\nMEDIDAS CORPORALES ACTUALES:\n- Peso: 54.30 kg\n- Grasa corporal: 15.10%\n- Masa muscular: 36.50 kg\n- IMC: 21.20\n- Cintura:  cm\n- Cadera:  cm\nALIMENTOS HABITUALES DEL USUARIO: Leche Sin lactosa (Celta)\n\nGenera un plan diaria completo con este formato exacto:\n\n## PLAN NUTRICIONAL\n- Calorías totales y macros (proteínas/carbohidratos/grasas en gramos)\n- Plan de comidas con cantidades exactas en gramos\n- Timing nutricional (cuándo comer respecto al entreno)\n\n## PLAN DE ENTRENAMIENTO\n- Rutina completa para 5 días\n- Por cada ejercicio: series, repeticiones, RIR, descanso\n- Orden de ejercicios por día\n\n## PLAN DE CARDIO\n- Tipo, duración e intensidad\n\n## PROGRESIÓN\n- Cómo progresar semana a semana\n\n## INDICACIONES PRÁCTICAS\n- 3 puntos clave para este usuario específico\n\nAl final pídeme que te envíe: peso actualizado, medidas, rendimiento y sensaciones para continuar el seguimiento.\n', 1, '2026-03-07 12:32:26'),
(7, 1, 'Mi rutina', 'semanal', '{\"texto\":\"## PLAN NUTRICIONAL\\n- Calor\\u00edas totales: 2200 kcal, macros: 120g prote\\u00ednas, 250g carbohidratos, 70g grasas\\n- Plan de comidas:\\n  - Desayuno: 3 huevos (180g), 2 rebanadas de pan integral (60g), 1 vaso de leche sin lactosa (200g) = 440 kcal, 30g prote\\u00ednas, 60g carbohidratos, 15g grasas\\n  - Snack ma\\u00f1ana: 1 batido de prote\\u00ednas (30g), 1 banana (100g) = 200 kcal, 25g prote\\u00ednas, 30g carbohidratos, 0g grasas\\n  - Almuerzo: 120g de pollo a la parrilla, 150g de arroz integral, 100g de br\\u00f3coli = 400 kcal, 40g prote\\u00ednas, 60g carbohidratos, 10g grasas\\n  - Snack tarde: 1 manzana (150g), 20g de almendras = 150 kcal, 0g prote\\u00ednas, 30g carbohidratos, 8g grasas\\n  - Cena: 120g de salm\\u00f3n a la parrilla, 150g de quinoa, 100g de espinacas = 500 kcal, 40g prote\\u00ednas, 60g carbohidratos, 20g grasas\\n- Timing nutricional: comer 1 hora antes del entrenamiento, snack de prote\\u00ednas y carbohidratos 30 minutos despu\\u00e9s del entrenamiento\\n\\n## PLAN DE ENTRENAMIENTO\\n- Lunes (pecho y tr\\u00edceps):\\n  - Press de banca: 3 series de 8-12 repeticiones, RIR 2, descanso 60-90 segundos\\n  - Inclinaciones: 3 series de 10-15 repeticiones, RIR 2, descanso 60-90 segundos\\n  - Extensiones de tr\\u00edceps: 3 series de 12-15 repeticiones, RIR 2, descanso 60-90 segundos\\n- Martes (espaldas y b\\u00edceps):\\n  - Remo: 3 series de 8-12 repeticiones, RIR 2, descanso 60-90 segundos\\n  - Peso muerto: 3 series de 8-12 repeticiones, RIR 2, descanso 60-90 segundos\\n  - Curl de b\\u00edceps: 3 series de 10-12 repeticiones, RIR 2, descanso 60-90 segundos\\n- Mi\\u00e9rcoles (piernas):\\n  - Sentadillas: 3 series de 8-12 repeticiones, RIR 2, descanso 60-90 segundos\\n  - Prensa de piernas: 3 series de 10-12 repeticiones, RIR 2, descanso 60-90 segundos\\n  - Extensiones de piernas: 3 series de 12-15 repeticiones, RIR 2, descanso 60-90 segundos\\n- Jueves (hombros y abdominales):\\n  - Press de hombros: 3 series de 8-12 repeticiones, RIR 2, descanso 60-90 segundos\\n  - Elevaciones laterales: 3 series de 10-12 repeticiones, RIR 2, descanso 60-90 segundos\\n  - Planchas: 3 series de 30-60 segundos, RIR 2, descanso 60-90 segundos\\n- Viernes (pecho y tr\\u00edceps):\\n  - Press de banca inclinado: 3 series de 8-12 repeticiones, RIR 2, descanso 60-90 segundos\\n  - Extensiones de tr\\u00edceps con cuerda: 3 series de 10-12 repeticiones, RIR 2, descanso 60-90 segundos\\n  - Fondos: 3 series de 10-12 repeticiones, RIR 2, descanso 60-90 segundos\\n\\n## PLAN DE CARDIO\\n- Tipo: carrera en cinta, duraci\\u00f3n: 20-30 minutos, intensidad: moderada\\n\\n## PROGRESI\\u00d3N\\n- Aumentar el peso o las repeticiones cada semana en un 2,5-5%\\n\\n## INDICACIONES PR\\u00c1CTICAS\\n- 1. Asegurarse de consumir suficientes prote\\u00ednas despu\\u00e9s del entrenamiento para promover la recuperaci\\u00f3n muscular.\\n- 2. Incorporar variedad en la dieta para asegurar la ingesta de todos los nutrientes necesarios.\\n- 3. Escuchar al cuerpo y descansar cuando sea necesario para evitar lesiones.\\n\\nPor favor, env\\u00edeme su peso actualizado, medidas, rendimiento y sensaciones para continuar el seguimiento despu\\u00e9s de una semana. Esto me permitir\\u00e1 ajustar el plan seg\\u00fan sea necesario para asegurar el progreso hacia su objetivo de ganar m\\u00fasculo.\"}', '\nActúa como un médico especialista en nutrición deportiva, recomposición corporal e hipertrofia y preparador físico profesional, usando exclusivamente evidencia científica actual (ISSN, ACSM, NSCA).\n\nNo quiero explicaciones teóricas largas. Quiero decisiones prácticas, estructuradas y justificadas brevemente.\n\nDATOS PERSONALES:\n- Nombre: Kelly Rodriguez\n- Sexo: mujer\n- Edad: 30 años\n- Altura: 160.00 cm\n- Nivel: intermedio\n- Días de entrenamiento: 5 días por semana\n- Objetivo: ganar musculo\n- Patologías: ninguna\n- Tiene ciclo menstrual: Sí\n\nMEDIDAS CORPORALES ACTUALES:\n- Peso: 54.30 kg\n- Grasa corporal: 15.10%\n- Masa muscular: 36.50 kg\n- IMC: 21.20\n- Cintura:  cm\n- Cadera:  cm\nALIMENTOS HABITUALES DEL USUARIO: Leche Sin lactosa (Celta)\n\nGenera un plan semanal completo con este formato exacto:\n\n## PLAN NUTRICIONAL\n- Calorías totales y macros (proteínas/carbohidratos/grasas en gramos)\n- Plan de comidas con cantidades exactas en gramos\n- Timing nutricional (cuándo comer respecto al entreno)\n\n## PLAN DE ENTRENAMIENTO\n- Rutina completa para 5 días\n- Por cada ejercicio: series, repeticiones, RIR, descanso\n- Orden de ejercicios por día\n\n## PLAN DE CARDIO\n- Tipo, duración e intensidad\n\n## PROGRESIÓN\n- Cómo progresar semana a semana\n\n## INDICACIONES PRÁCTICAS\n- 3 puntos clave para este usuario específico\n\nAl final pídeme que te envíe: peso actualizado, medidas, rendimiento y sensaciones para continuar el seguimiento.\n', 0, '2026-03-07 12:32:47'),
(8, 1, 'Mi rutina', 'diaria', '{\"texto\":\"## PLAN NUTRICIONAL\\n- Calor\\u00edas totales: 2200 kcal, macros: prote\\u00ednas 120g, carbohidratos 250g, grasas 70g\\n- Plan de comidas:\\n  - Desayuno: 3 huevos (180g), 2 rebanadas de pan integral (60g), 1 taza de frutas (150g) = 390 kcal, 30g prote\\u00ednas, 40g carbohidratos, 15g grasas\\n  - Snack ma\\u00f1anero: 1 taza de leche sin lactosa (240g), 1 cucharada de prote\\u00edna en polvo (30g) = 150 kcal, 20g prote\\u00ednas, 20g carbohidratos, 0g grasas\\n  - Almuerzo: 120g de pechuga de pollo, 100g de arroz integral, 100g de br\\u00f3coli = 350 kcal, 40g prote\\u00ednas, 40g carbohidratos, 10g grasas\\n  - Snack vespertino: 1 taza de yogur griego (200g), 1\\/2 taza de frutas (75g) = 100 kcal, 15g prote\\u00ednas, 20g carbohidratos, 0g grasas\\n  - Cena: 120g de salm\\u00f3n, 100g de quinoa, 100g de zanahorias = 350 kcal, 35g prote\\u00ednas, 40g carbohidratos, 15g grasas\\n  - Snack nocturno (antes de dormir): 1 taza de leche sin lactosa (240g), 1 cucharada de case\\u00edna (30g) = 150 kcal, 20g prote\\u00ednas, 20g carbohidratos, 0g grasas\\n- Timing nutricional: 1 hora antes del entrenamiento, 30-60 minutos despu\\u00e9s del entrenamiento, y cada 3 horas durante el d\\u00eda\\n\\n## PLAN DE ENTRENAMIENTO\\n- D\\u00eda 1: Pecho y Tr\\u00edceps\\n  - Press de banca (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Press inclinado (3 series, 10-15 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Extensiones de tr\\u00edceps (3 series, 12-15 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Fondos (3 series, 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n- D\\u00eda 2: Espalda y B\\u00edceps\\n  - Remo (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Peso muerto (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Curl de b\\u00edceps (3 series, 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Hammer curl (3 series, 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n- D\\u00eda 3: Piernas\\n  - Sentadilla (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Peso muerto (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Press de piernas (3 series, 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Extensiones de piernas (3 series, 12-15 repeticiones, RIR 2, descanso 60-90 segundos)\\n- D\\u00eda 4: Hombros y Abdominales\\n  - Press militar (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Elevaciones laterales (3 series, 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Plancha (3 series, 30-60 segundos, RIR 2, descanso 60-90 segundos)\\n  - Crunch (3 series, 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n- D\\u00eda 5: Entrenamiento de fuerza total\\n  - Sentadilla (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Peso muerto (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Press de banca (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Remo (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n\\n## PLAN DE CARDIO\\n- Tipo: Caminata o correr en la cinta\\n- Duraci\\u00f3n: 20-30 minutos\\n- Intensidad: Moderada\\n\\n## PROGRESI\\u00d3N\\n- Aumentar el peso utilizado en 2.5-5 kg cada semana\\n- Aumentar el n\\u00famero de repeticiones en 2-3 cada semana\\n\\n## INDICACIONES PR\\u00c1CTICAS\\n- Asegurarse de consumir suficientes prote\\u00ednas despu\\u00e9s del entrenamiento para ayudar en la recuperaci\\u00f3n muscular\\n- Asegurarse de dormir lo suficiente (7-9 horas) cada noche para ayudar en la recuperaci\\u00f3n muscular\\n- Asegurarse de beber suficiente agua durante el d\\u00eda (al menos 2 litros) para ayudar en la hidrataci\\u00f3n\\n\\nPor favor, env\\u00edeme su peso actualizado, medidas, rendimiento y sensaciones despu\\u00e9s de seguir este plan durante 4 semanas para continuar el seguimiento.\"}', '\nActúa como un médico especialista en nutrición deportiva, recomposición corporal e hipertrofia y preparador físico profesional, usando exclusivamente evidencia científica actual (ISSN, ACSM, NSCA).\n\nNo quiero explicaciones teóricas largas. Quiero decisiones prácticas, estructuradas y justificadas brevemente.\n\nDATOS PERSONALES:\n- Nombre: Kelly Rodriguez\n- Sexo: mujer\n- Edad: 30 años\n- Altura: 160.00 cm\n- Nivel: intermedio\n- Días de entrenamiento: 5 días por semana\n- Objetivo: ganar musculo\n- Patologías: ninguna\n- Tiene ciclo menstrual: Sí\n\nMEDIDAS CORPORALES ACTUALES:\n- Peso: 54.30 kg\n- Grasa corporal: 15.10%\n- Masa muscular: 36.50 kg\n- IMC: 21.20\n- Cintura:  cm\n- Cadera:  cm\nALIMENTOS HABITUALES DEL USUARIO: Leche Sin lactosa (Celta)\n\nGenera un plan diaria completo con este formato exacto:\n\n## PLAN NUTRICIONAL\n- Calorías totales y macros (proteínas/carbohidratos/grasas en gramos)\n- Plan de comidas con cantidades exactas en gramos\n- Timing nutricional (cuándo comer respecto al entreno)\n\n## PLAN DE ENTRENAMIENTO\n- Rutina completa para 5 días\n- Por cada ejercicio: series, repeticiones, RIR, descanso\n- Orden de ejercicios por día\n\n## PLAN DE CARDIO\n- Tipo, duración e intensidad\n\n## PROGRESIÓN\n- Cómo progresar semana a semana\n\n## INDICACIONES PRÁCTICAS\n- 3 puntos clave para este usuario específico\n\nAl final pídeme que te envíe: peso actualizado, medidas, rendimiento y sensaciones para continuar el seguimiento.\n', 1, '2026-03-07 12:32:57'),
(9, 1, 'Rutina semanal - semana 10/2026', 'semanal', '[{\"dia\":1,\"nombre\":\"Pecho y Tríceps\",\"grupo_muscular\":\"pecho, triceps\",\"justificacion_clinica\":\"Priorizando estabilización de core y evitando cargas axiales extremas debido a dolor lumbar. Reduciendo RPE objetivo en 1 punto por fase lútea probable.\",\"ejercicios\":[{\"nombre_espanol\":\"Press de banca\",\"nombre_ingles\":\"barbell bench press\",\"series\":4,\"repeticiones\":\"8-10\",\"rir\":2,\"descanso\":\"90s\",\"sustituto_lesion\":\"Press en máquina si hay dolor de hombro\",\"tecnica_clave\":\"Tempo 3-0-2, escápulas retraídas\"},{\"nombre_espanol\":\"Extensiones de tríceps\",\"nombre_ingles\":\"tricep pushdown\",\"series\":3,\"repeticiones\":\"12-15\",\"rir\":2,\"descanso\":\"60s\",\"sustituto_lesion\":\"Extensiones de tríceps con mancuernas\",\"tecnica_clave\":\"Codo fijo, extensión completa\"},{\"nombre_espanol\":\"Fondos\",\"nombre_ingles\":\"dumbbell fly\",\"series\":3,\"repeticiones\":\"12-15\",\"rir\":2,\"descanso\":\"60s\",\"sustituto_lesion\":\"Fondos en máquina\",\"tecnica_clave\":\"Brazos estirados, sin mover hombros\"},{\"nombre_espanol\":\"Elevaciones laterales\",\"nombre_ingles\":\"lateral raises\",\"series\":3,\"repeticiones\":\"12-15\",\"rir\":2,\"descanso\":\"60s\",\"sustituto_lesion\":\"Elevaciones laterales con polea\",\"tecnica_clave\":\"Brazos estirados, sin arquear la espalda\"}]},{\"dia\":2,\"nombre\":\"Espalda y Bíceps\",\"grupo_muscular\":\"espalda, bíceps\",\"justificacion_clinica\":\"Priorizando cadena posterior y evitando extensiones de rodilla con carga alta debido a dolor de rodilla. Reduciendo RPE objetivo en 1 punto por fase lútea probable.\",\"ejercicios\":[{\"nombre_espanol\":\"Remo a dos manos\",\"nombre_ingles\":\"barbell row\",\"series\":4,\"repeticiones\":\"8-10\",\"rir\":2,\"descanso\":\"90s\",\"sustituto_lesion\":\"Remo en máquina\",\"tecnica_clave\":\"Espalda recta, sin arquear la columna\"},{\"nombre_espanol\":\"Curl de bíceps\",\"nombre_ingles\":\"dumbbell curl\",\"series\":3,\"repeticiones\":\"12-15\",\"rir\":2,\"descanso\":\"60s\",\"sustituto_lesion\":\"Curl de bíceps con barra\",\"tecnica_clave\":\"Codo fijo, flexión completa\"},{\"nombre_espanol\":\"Peso muerto\",\"nombre_ingles\":\"deadlift\",\"series\":3,\"repeticiones\":\"8-10\",\"rir\":2,\"descanso\":\"90s\",\"sustituto_lesion\":\"Peso muerto con mancuernas\",\"tecnica_clave\":\"Espalda recta, sin arquear la columna\"},{\"nombre_espanol\":\"Elevaciones frontales\",\"nombre_ingles\":\"front raises\",\"series\":3,\"repeticiones\":\"12-15\",\"rir\":2,\"descanso\":\"60s\",\"sustituto_lesion\":\"Elevaciones frontales con polea\",\"tecnica_clave\":\"Brazos estirados, sin mover hombros\"},{\"nombre_espanol\":\"Abdominales\",\"nombre_ingles\":\"plank\",\"series\":3,\"repeticiones\":\"30-60s\",\"rir\":2,\"descanso\":\"60s\",\"sustituto_lesion\":\"Abdominales en máquina\",\"tecnica_clave\":\"Cuerpo recto, sin arquear la espalda\"}]},{\"dia\":3,\"nombre\":\"Piernas\",\"grupo_muscular\":\"piernas\",\"justificacion_clinica\":\"Priorizando estabilización de core y evitando cargas axiales extremas debido a dolor lumbar. Reduciendo RPE objetivo en 1 punto por fase lútea probable.\",\"ejercicios\":[{\"nombre_espanol\":\"Goblet Squat\",\"nombre_ingles\":\"goblet squat\",\"series\":4,\"repeticiones\":\"8-10\",\"rir\":2,\"descanso\":\"90s\",\"sustituto_lesion\":\"Sentadilla con mancuernas\",\"tecnica_clave\":\"Espalda recta, sin arquear la columna\"},{\"nombre_espanol\":\"Prensa de piernas\",\"nombre_ingles\":\"leg press\",\"series\":3,\"repeticiones\":\"12-15\",\"rir\":2,\"descanso\":\"60s\",\"sustituto_lesion\":\"Prensa de piernas con mancuernas\",\"tecnica_clave\":\"Piernas estiradas, sin mover caderas\"},{\"nombre_espanol\":\"Extensión de piernas\",\"nombre_ingles\":\"leg extension\",\"series\":3,\"repeticiones\":\"12-15\",\"rir\":2,\"descanso\":\"60s\",\"sustituto_lesion\":\"Extensión de piernas con mancuernas\",\"tecnica_clave\":\"Piernas estiradas, sin mover caderas\"},{\"nombre_espanol\":\"Curl de piernas\",\"nombre_ingles\":\"leg curl\",\"series\":3,\"repeticiones\":\"12-15\",\"rir\":2,\"descanso\":\"60s\",\"sustituto_lesion\":\"Curl de piernas con mancuernas\",\"tecnica_clave\":\"Piernas estiradas, sin mover caderas\"}]},{\"dia\":4,\"nombre\":\"Hombros y Abdominales\",\"grupo_muscular\":\"hombros, abdominales\",\"justificacion_clinica\":\"Priorizando estabilización de core y evitando cargas axiales extremas debido a dolor lumbar. Reduciendo RPE objetivo en 1 punto por fase lútea probable.\",\"ejercicios\":[{\"nombre_espanol\":\"Prensa militar\",\"nombre_ingles\":\"dumbbell shoulder press\",\"series\":4,\"repeticiones\":\"8-10\",\"rir\":2,\"descanso\":\"90s\",\"sustituto_lesion\":\"Prensa militar con barra\",\"tecnica_clave\":\"Hombros bajos, sin arquear la espalda\"},{\"nombre_espanol\":\"Elevaciones laterales\",\"nombre_ingles\":\"lateral raises\",\"series\":3,\"repeticiones\":\"12-15\",\"rir\":2,\"descanso\":\"60s\",\"sustituto_lesion\":\"Elevaciones laterales con polea\",\"tecnica_clave\":\"Brazos estirados, sin mover hombros\"},{\"nombre_espanol\":\"Abdominales\",\"nombre_ingles\":\"crunches\",\"series\":3,\"repeticiones\":\"12-15\",\"rir\":2,\"descanso\":\"60s\",\"sustituto_lesion\":\"Abdominales en máquina\",\"tecnica_clave\":\"Cuerpo recto, sin arquear la espalda\"},{\"nombre_espanol\":\"Elevaciones frontales\",\"nombre_ingles\":\"front raises\",\"series\":3,\"repeticiones\":\"12-15\",\"rir\":2,\"descanso\":\"60s\",\"sustituto_lesion\":\"Elevaciones frontales con polea\",\"tecnica_clave\":\"Brazos estirados, sin mover hombros\"}]},{\"dia\":5,\"nombre\":\"Cardio y Estiramientos\",\"grupo_muscular\":\"cardio, estiramientos\",\"justificacion_clinica\":\"Priorizando estabilización de core y evitando cargas axiales extremas debido a dolor lumbar. Reduciendo RPE objetivo en 1 punto por fase lútea probable.\",\"ejercicios\":[{\"nombre_espanol\":\"Correr\",\"nombre_ingles\":\"running\",\"series\":1,\"repeticiones\":\"20-30 minutos\",\"rir\":2,\"descanso\":\"0s\",\"sustituto_lesion\":\"Caminar en cinta\",\"tecnica_clave\":\"Postura recta, sin arquear la espalda\"},{\"nombre_espanol\":\"Estiramientos de piernas\",\"nombre_ingles\":\"leg stretches\",\"series\":3,\"repeticiones\":\"30-60s\",\"rir\":2,\"descanso\":\"60s\",\"sustituto_lesion\":\"Estiramientos de piernas con bandas\",\"tecnica_clave\":\"Piernas estiradas, sin mover caderas\"},{\"nombre_espanol\":\"Estiramientos de espalda\",\"nombre_ingles\":\"back stretches\",\"series\":3,\"repeticiones\":\"30-60s\",\"rir\":2,\"descanso\":\"60s\",\"sustituto_lesion\":\"Estiramientos de espalda con bandas\",\"tecnica_clave\":\"Espalda recta, sin arquear la columna\"},{\"nombre_espanol\":\"Estiramientos de hombros\",\"nombre_ingles\":\"shoulder stretches\",\"series\":3,\"repeticiones\":\"30-60s\",\"rir\":2,\"descanso\":\"60s\",\"sustituto_lesion\":\"Estiramientos de hombros con bandas\",\"tecnica_clave\":\"Hombros bajos, sin arquear la espalda\"},{\"nombre_espanol\":\"Estiramientos de abdominales\",\"nombre_ingles\":\"abdominal stretches\",\"series\":3,\"repeticiones\":\"30-60s\",\"rir\":2,\"descanso\":\"60s\",\"sustituto_lesion\":\"Estiramientos de abdominales con bandas\",\"tecnica_clave\":\"Cuerpo recto, sin arquear la espalda\"}]}]', NULL, 1, '2026-03-07 17:36:09');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `foto_perfil` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `sexo` enum('hombre','mujer','otro') NOT NULL,
  `fecha_nacimiento` date NOT NULL,
  `altura_cm` decimal(5,2) NOT NULL,
  `peso_actual` decimal(5,2) DEFAULT NULL,
  `peso_objetivo` decimal(5,2) DEFAULT NULL,
  `grasa_objetivo` decimal(4,1) DEFAULT NULL,
  `objetivo` enum('perder_grasa','ganar_musculo','recomposicion','mantenimiento') NOT NULL,
  `dias_entrenamiento` tinyint(4) NOT NULL DEFAULT 3,
  `nivel` enum('principiante','intermedio','avanzado') NOT NULL DEFAULT 'principiante',
  `tiene_ciclo` tinyint(1) DEFAULT 0,
  `fecha_ultimo_ciclo` date DEFAULT NULL,
  `duracion_ciclo` tinyint(4) DEFAULT 28,
  `token` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `alergias` text DEFAULT NULL COMMENT 'JSON array: ["gluten","lactosa"]',
  `alimentos_no_gusta` text DEFAULT NULL COMMENT 'JSON array: ["higado","brocoli"]',
  `alimentos_favoritos` text DEFAULT NULL COMMENT 'JSON array: ["pollo","arroz","huevos"]',
  `tipo_dieta` varchar(50) DEFAULT NULL COMMENT 'omnivora|vegetariana|vegana|keto|mediterranea',
  `presupuesto_semana` decimal(8,2) DEFAULT NULL COMMENT 'Presupuesto semanal para comida en euros',
  `foto_perfil_url` varchar(500) DEFAULT NULL COMMENT 'URL pública de la foto (se actualiza al subir)',
  `comidas_diarias` tinyint(4) DEFAULT 5 COMMENT '3=básico, 4=+merienda, 5=+media mañana, 6=todas'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `nombre`, `email`, `foto_perfil`, `password`, `sexo`, `fecha_nacimiento`, `altura_cm`, `peso_actual`, `peso_objetivo`, `grasa_objetivo`, `objetivo`, `dias_entrenamiento`, `nivel`, `tiene_ciclo`, `fecha_ultimo_ciclo`, `duracion_ciclo`, `token`, `created_at`, `alergias`, `alimentos_no_gusta`, `alimentos_favoritos`, `tipo_dieta`, `presupuesto_semana`, `foto_perfil_url`, `comidas_diarias`) VALUES
(1, 'Kelly Rodriguez', 'kelly@forja.com', 'uploads/fotos_perfil/usuario_1_1773093354.jpeg', '$2y$10$wY1gAC99YQdsmaS7ClJ0xuf9IhDX7m4/HKC945zXeoZYFlYpmAItu', 'mujer', '1995-03-15', 160.00, 54.00, 70.00, 20.0, 'ganar_musculo', 5, 'intermedio', 1, NULL, 28, 'd112dbe584cb4cd263f234619c23fe89ee113201fe64860fa0ba11f8cb139de2_1_1773093202', '2026-03-06 22:36:27', NULL, NULL, NULL, NULL, NULL, NULL, 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario_patologias`
--

CREATE TABLE `usuario_patologias` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `patologia` enum('sop','hipotiroidismo','resistencia_insulina','endometriosis','diabetes_tipo2','ninguna') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `usuario_patologias`
--

INSERT INTO `usuario_patologias` (`id`, `usuario_id`, `patologia`) VALUES
(3, 1, 'ninguna');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `alimentos`
--
ALTER TABLE `alimentos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indices de la tabla `analisis_sangre`
--
ALTER TABLE `analisis_sangre`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indices de la tabla `checkin_fotos`
--
ALTER TABLE `checkin_fotos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indices de la tabla `ciclo_menstrual`
--
ALTER TABLE `ciclo_menstrual`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indices de la tabla `ejercicios`
--
ALTER TABLE `ejercicios`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_ejercicio_sustitucion` (`sustitucion_id`);

--
-- Indices de la tabla `ejercicios_imagenes`
--
ALTER TABLE `ejercicios_imagenes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre_ingles` (`nombre_ingles`);

--
-- Indices de la tabla `log_entreno`
--
ALTER TABLE `log_entreno`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`),
  ADD KEY `plan_detalle_id` (`plan_detalle_id`),
  ADD KEY `ejercicio_id` (`ejercicio_id`);

--
-- Indices de la tabla `medidas`
--
ALTER TABLE `medidas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indices de la tabla `planes_entrenamiento`
--
ALTER TABLE `planes_entrenamiento`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indices de la tabla `plan_detalle`
--
ALTER TABLE `plan_detalle`
  ADD PRIMARY KEY (`id`),
  ADD KEY `plan_id` (`plan_id`),
  ADD KEY `ejercicio_id` (`ejercicio_id`);

--
-- Indices de la tabla `plan_nutricional`
--
ALTER TABLE `plan_nutricional`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_plan_nut_usuario_dia` (`usuario_id`,`dia_semana`),
  ADD KEY `idx_plan_nut_entreno` (`plan_entreno_id`);

--
-- Indices de la tabla `plan_nutricional_comidas`
--
ALTER TABLE `plan_nutricional_comidas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `plan_nutricional_id` (`plan_nutricional_id`);

--
-- Indices de la tabla `registro_comidas`
--
ALTER TABLE `registro_comidas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`),
  ADD KEY `alimento_id` (`alimento_id`);

--
-- Indices de la tabla `rutinas`
--
ALTER TABLE `rutinas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indices de la tabla `usuario_patologias`
--
ALTER TABLE `usuario_patologias`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `alimentos`
--
ALTER TABLE `alimentos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `analisis_sangre`
--
ALTER TABLE `analisis_sangre`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `checkin_fotos`
--
ALTER TABLE `checkin_fotos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `ciclo_menstrual`
--
ALTER TABLE `ciclo_menstrual`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `ejercicios_imagenes`
--
ALTER TABLE `ejercicios_imagenes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT de la tabla `log_entreno`
--
ALTER TABLE `log_entreno`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `medidas`
--
ALTER TABLE `medidas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `planes_entrenamiento`
--
ALTER TABLE `planes_entrenamiento`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `plan_detalle`
--
ALTER TABLE `plan_detalle`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=284;

--
-- AUTO_INCREMENT de la tabla `plan_nutricional`
--
ALTER TABLE `plan_nutricional`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `plan_nutricional_comidas`
--
ALTER TABLE `plan_nutricional_comidas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT de la tabla `registro_comidas`
--
ALTER TABLE `registro_comidas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `rutinas`
--
ALTER TABLE `rutinas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `usuario_patologias`
--
ALTER TABLE `usuario_patologias`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `alimentos`
--
ALTER TABLE `alimentos`
  ADD CONSTRAINT `alimentos_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `analisis_sangre`
--
ALTER TABLE `analisis_sangre`
  ADD CONSTRAINT `analisis_sangre_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `checkin_fotos`
--
ALTER TABLE `checkin_fotos`
  ADD CONSTRAINT `checkin_fotos_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `ciclo_menstrual`
--
ALTER TABLE `ciclo_menstrual`
  ADD CONSTRAINT `ciclo_menstrual_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `ejercicios`
--
ALTER TABLE `ejercicios`
  ADD CONSTRAINT `fk_ejercicio_sustitucion` FOREIGN KEY (`sustitucion_id`) REFERENCES `ejercicios` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `log_entreno`
--
ALTER TABLE `log_entreno`
  ADD CONSTRAINT `log_entreno_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `log_entreno_ibfk_2` FOREIGN KEY (`plan_detalle_id`) REFERENCES `plan_detalle` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `log_entreno_ibfk_3` FOREIGN KEY (`ejercicio_id`) REFERENCES `ejercicios` (`id`);

--
-- Filtros para la tabla `medidas`
--
ALTER TABLE `medidas`
  ADD CONSTRAINT `medidas_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `planes_entrenamiento`
--
ALTER TABLE `planes_entrenamiento`
  ADD CONSTRAINT `planes_entrenamiento_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `plan_detalle`
--
ALTER TABLE `plan_detalle`
  ADD CONSTRAINT `plan_detalle_ibfk_1` FOREIGN KEY (`plan_id`) REFERENCES `planes_entrenamiento` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `plan_detalle_ibfk_2` FOREIGN KEY (`ejercicio_id`) REFERENCES `ejercicios` (`id`);

--
-- Filtros para la tabla `plan_nutricional`
--
ALTER TABLE `plan_nutricional`
  ADD CONSTRAINT `plan_nutricional_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `plan_nutricional_ibfk_2` FOREIGN KEY (`plan_entreno_id`) REFERENCES `planes_entrenamiento` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `plan_nutricional_comidas`
--
ALTER TABLE `plan_nutricional_comidas`
  ADD CONSTRAINT `plan_nutricional_comidas_ibfk_1` FOREIGN KEY (`plan_nutricional_id`) REFERENCES `plan_nutricional` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `registro_comidas`
--
ALTER TABLE `registro_comidas`
  ADD CONSTRAINT `registro_comidas_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `registro_comidas_ibfk_2` FOREIGN KEY (`alimento_id`) REFERENCES `alimentos` (`id`);

--
-- Filtros para la tabla `rutinas`
--
ALTER TABLE `rutinas`
  ADD CONSTRAINT `rutinas_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `usuario_patologias`
--
ALTER TABLE `usuario_patologias`
  ADD CONSTRAINT `usuario_patologias_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
