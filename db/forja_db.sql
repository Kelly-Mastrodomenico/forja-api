-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 07-03-2026 a las 18:32:18
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
  `id` int(11) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `grupo_muscular` enum('pecho','espalda','hombros','biceps','triceps','cuadriceps','isquiotibiales','gluteos','pantorrillas','abdomen','trapecio') NOT NULL,
  `tipo` enum('compuesto','aislamiento','cardio') NOT NULL,
  `activacion_emg` tinyint(4) DEFAULT 5,
  `descripcion` text DEFAULT NULL,
  `video_url` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `log_entreno`
--

CREATE TABLE `log_entreno` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `ejercicio_id` int(11) NOT NULL,
  `series_completadas` tinyint(4) DEFAULT NULL,
  `reps_completadas` tinyint(4) DEFAULT NULL,
  `peso_kg` decimal(6,2) DEFAULT NULL,
  `rir` tinyint(4) DEFAULT NULL,
  `rpe` tinyint(4) DEFAULT NULL,
  `fatiga_post` tinyint(4) DEFAULT NULL,
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
(1, 1, 'Mi rutina', 'semanal', '{\"texto\":\"## PLAN NUTRICIONAL\\n- Calor\\u00edas totales: 1900 kcal\\n- Macros: 120g prote\\u00ednas, 200g carbohidratos, 70g grasas\\n- Plan de comidas:\\n  - Desayuno: 3 huevos (180g), 2 rebanadas de pan integral (120g), 1 taza de frutas (150g) = 40g prote\\u00ednas, 60g carbohidratos, 15g grasas\\n  - Media ma\\u00f1ana: 1 batido de prote\\u00ednas (30g), 1 taza de yogur griego (200g), 1 taza de frutas (150g) = 30g prote\\u00ednas, 30g carbohidratos, 0g grasas\\n  - Almuerzo: 120g de pollo a la parrilla, 1 taza de arroz integral (150g), 1 taza de vegetales (50g) = 35g prote\\u00ednas, 40g carbohidratos, 10g grasas\\n  - Merienda: 1 manzana (150g), 1 cucharada de mantequilla de man\\u00ed (16g) = 0g prote\\u00ednas, 30g carbohidratos, 8g grasas\\n  - Cena: 120g de salm\\u00f3n a la parrilla, 1 taza de quinoa (150g), 1 taza de vegetales (50g) = 35g prote\\u00ednas, 40g carbohidratos, 15g grasas\\n- Timing nutricional: 1 hora antes del entrenamiento, 1 hora despu\\u00e9s del entrenamiento, y 2-3 horas entre comidas\\n\\n## PLAN DE ENTRENAMIENTO\\n- D\\u00eda 1: Entrenamiento de pecho y triceps\\n  - Press de banca (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Inclinado de pecho (3 series, 10-15 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Extensiones de triceps (3 series, 12-15 repeticiones, RIR 2, descanso 60-90 segundos)\\n- D\\u00eda 2: Entrenamiento de espalda y b\\u00edceps\\n  - Remo con barra (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Peso muerto (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Curl de b\\u00edceps (3 series, 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n- D\\u00eda 3: Entrenamiento de piernas\\n  - Sentadillas (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Prensa de piernas (3 series, 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Extensiones de piernas (3 series, 12-15 repeticiones, RIR 2, descanso 60-90 segundos)\\n- D\\u00eda 4: Entrenamiento de hombros y abdominales\\n  - Press de hombros (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Elevaciones laterales (3 series, 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Planchas (3 series, 30-60 segundos, RIR 2, descanso 60-90 segundos)\\n- D\\u00eda 5: Entrenamiento de pecho y triceps\\n  - Press de banca inclinado (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Extensiones de triceps con cuerda (3 series, 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Curl de triceps (3 series, 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n\\n## PLAN DE CARDIO\\n- Tipo: Correr o caminar en cinta\\n- Duraci\\u00f3n: 20-30 minutos\\n- Intensidad: Moderada (60-70% de la frecuencia card\\u00edaca m\\u00e1xima)\\n\\n## PROGRESI\\u00d3N\\n- Aumentar el peso o la resistencia en un 2.5-5% cada semana\\n- Aumentar el n\\u00famero de repeticiones en un 2-3 cada semana\\n\\n## INDICACIONES PR\\u00c1CTICAS\\n- 1. Asegurarse de beber al menos 2 litros de agua al d\\u00eda\\n- 2. Dormir entre 7-9 horas cada noche para ayudar en la recuperaci\\u00f3n\\n- 3. Ajustar el plan de comidas seg\\u00fan las necesidades individuales y el progreso\\n\\nPor favor, env\\u00edeme su peso actualizado, medidas, rendimiento y sensaciones para continuar el seguimiento. Esto me permitir\\u00e1 ajustar y personalizar el plan para lograr sus objetivos de recomposici\\u00f3n.\"}', '\nActúa como un médico especialista en nutrición deportiva, recomposición corporal e hipertrofia y preparador físico profesional, usando exclusivamente evidencia científica actual (ISSN, ACSM, NSCA).\n\nNo quiero explicaciones teóricas largas. Quiero decisiones prácticas, estructuradas y justificadas brevemente.\n\nDATOS PERSONALES:\n- Nombre: Kelly Rodriguez\n- Sexo: mujer\n- Edad: 30 años\n- Altura: 160.00 cm\n- Nivel: intermedio\n- Días de entrenamiento: 5 días por semana\n- Objetivo: recomposicion\n- Patologías: ninguna\n- Tiene ciclo menstrual: Sí\n\n\n\nGenera un plan semanal completo con este formato exacto:\n\n## PLAN NUTRICIONAL\n- Calorías totales y macros (proteínas/carbohidratos/grasas en gramos)\n- Plan de comidas con cantidades exactas en gramos\n- Timing nutricional (cuándo comer respecto al entreno)\n\n## PLAN DE ENTRENAMIENTO\n- Rutina completa para 5 días\n- Por cada ejercicio: series, repeticiones, RIR, descanso\n- Orden de ejercicios por día\n\n## PLAN DE CARDIO\n- Tipo, duración e intensidad\n\n## PROGRESIÓN\n- Cómo progresar semana a semana\n\n## INDICACIONES PRÁCTICAS\n- 3 puntos clave para este usuario específico\n\nAl final pídeme que te envíe: peso actualizado, medidas, rendimiento y sensaciones para continuar el seguimiento.\n', 1, '2026-03-07 00:37:49'),
(2, 1, 'Mi rutina', 'diaria', '{\"texto\":\"## PLAN NUTRICIONAL\\n- Calor\\u00edas totales: 1800 kcal (deficit cal\\u00f3rico para recomposici\\u00f3n)\\n- Macros: \\n  - Prote\\u00ednas: 120g (1.5g\\/kg de peso corporal)\\n  - Carbohidratos: 150g (2g\\/kg de peso corporal)\\n  - Grasas: 70g (0.5g\\/kg de peso corporal)\\n- Plan de comidas:\\n  - Desayuno: 3 huevos (180g), 1 taza de avena (100g), 1 banana (100g)\\n  - Media ma\\u00f1ana: 1 batido de prote\\u00ednas (30g), 1 taza de frutas (150g)\\n  - Almuerzo: 120g de pechuga de pollo, 100g de arroz integral, 100g de br\\u00f3coli\\n  - Merienda: 1 yogurt griego (150g), 1\\/2 taza de frutos secos (50g)\\n  - Cena: 120g de salm\\u00f3n, 100g de quinoa, 100g de espinacas\\n- Timing nutricional: \\n  - Comer 1 hora antes del entrenamiento\\n  - Comer 30-60 minutos despu\\u00e9s del entrenamiento (batido de prote\\u00ednas y carbohidratos)\\n\\n## PLAN DE ENTRENAMIENTO\\n- D\\u00eda 1: Pecho y Tr\\u00edceps\\n  - Press de banca (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Inclinaciones (3 series, 10-15 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Extensiones de tr\\u00edceps (3 series, 12-15 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Fondos (3 series, 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n- D\\u00eda 2: Espalda y B\\u00edceps\\n  - Remo (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Peso muerto (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Curl de b\\u00edceps (3 series, 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Curl de martillo (3 series, 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n- D\\u00eda 3: Piernas\\n  - Sentadillas (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Prensa de piernas (3 series, 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Extensiones de piernas (3 series, 12-15 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Curl de piernas (3 series, 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n- D\\u00eda 4: Hombros y Abd\\u00f3men\\n  - Press de hombros (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Elevaciones laterales (3 series, 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Planchas (3 series, 30-60 segundos, RIR 2, descanso 60-90 segundos)\\n  - Russian twists (3 series, 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n- D\\u00eda 5: Entrenamiento de fuerza total\\n  - Peso muerto (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Sentadillas (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Press de banca (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n\\n## PLAN DE CARDIO\\n- Tipo: Cardio de baja intensidad (caminar, correr, bicicleta)\\n- Duraci\\u00f3n: 20-30 minutos\\n- Intensidad: 50-60% de la frecuencia card\\u00edaca m\\u00e1xima\\n\\n## PROGRESI\\u00d3N\\n- Aumentar el peso o la resistencia en 2.5-5kg cada semana\\n- Aumentar el n\\u00famero de repeticiones en 2-3 cada semana\\n\\n## INDICACIONES PR\\u00c1CTICAS\\n- Beber al menos 2 litros de agua al d\\u00eda\\n- Dormir 7-9 horas cada noche\\n- Realizar estiramientos despu\\u00e9s de cada entrenamiento\\n\\nPor favor, env\\u00edame tu peso actualizado, medidas, rendimiento y sensaciones para continuar el seguimiento. Esto me permitir\\u00e1 ajustar el plan y asegurarme de que est\\u00e1s progresando hacia tus objetivos.\"}', '\nActúa como un médico especialista en nutrición deportiva, recomposición corporal e hipertrofia y preparador físico profesional, usando exclusivamente evidencia científica actual (ISSN, ACSM, NSCA).\n\nNo quiero explicaciones teóricas largas. Quiero decisiones prácticas, estructuradas y justificadas brevemente.\n\nDATOS PERSONALES:\n- Nombre: Kelly Rodriguez\n- Sexo: mujer\n- Edad: 30 años\n- Altura: 160.00 cm\n- Nivel: intermedio\n- Días de entrenamiento: 5 días por semana\n- Objetivo: recomposicion\n- Patologías: ninguna\n- Tiene ciclo menstrual: Sí\n\n\n\nGenera un plan diaria completo con este formato exacto:\n\n## PLAN NUTRICIONAL\n- Calorías totales y macros (proteínas/carbohidratos/grasas en gramos)\n- Plan de comidas con cantidades exactas en gramos\n- Timing nutricional (cuándo comer respecto al entreno)\n\n## PLAN DE ENTRENAMIENTO\n- Rutina completa para 5 días\n- Por cada ejercicio: series, repeticiones, RIR, descanso\n- Orden de ejercicios por día\n\n## PLAN DE CARDIO\n- Tipo, duración e intensidad\n\n## PROGRESIÓN\n- Cómo progresar semana a semana\n\n## INDICACIONES PRÁCTICAS\n- 3 puntos clave para este usuario específico\n\nAl final pídeme que te envíe: peso actualizado, medidas, rendimiento y sensaciones para continuar el seguimiento.\n', 1, '2026-03-07 00:56:27'),
(3, 1, 'Mi rutina', 'semanal', '{\"texto\":\"## PLAN NUTRICIONAL\\n- Calor\\u00edas totales: 1800 kcal (para una mujer de 30 a\\u00f1os y 160 cm con objetivo de recomposici\\u00f3n y nivel de actividad alto)\\n- Macros: \\n  - Prote\\u00ednas: 120 g (1.5 g\\/kg de peso corporal, asumiendo un peso de 55 kg)\\n  - Carbohidratos: 200 g (foco en carbohidratos complejos)\\n  - Grasas: 70 g (foco en grasas saludables)\\n- Plan de comidas:\\n  - Desayuno: 3 huevos (180 g), 2 rebanadas de pan integral (60 g), 1 taza de frutas (150 g) = 390 kcal, 30 g prote\\u00ednas, 40 g carbohidratos, 20 g grasas\\n  - Media ma\\u00f1ana: 1 taza de yogur griego (200 g), 1\\/2 taza de frutas (75 g), 1 cucharada de miel (20 g) = 200 kcal, 20 g prote\\u00ednas, 30 g carbohidratos, 0 g grasas\\n  - Almuerzo: 120 g de pollo a la parrilla, 1 taza de arroz integral (150 g), 1 taza de br\\u00f3coli (55 g) = 400 kcal, 40 g prote\\u00ednas, 60 g carbohidratos, 10 g grasas\\n  - Merienda: 1 manzana (150 g), 1 cucharada de mantequilla de man\\u00ed (20 g) = 150 kcal, 4 g prote\\u00ednas, 20 g carbohidratos, 8 g grasas\\n  - Cena: 120 g de salm\\u00f3n a la parrilla, 1 taza de quinoa (150 g), 1 taza de espinacas (30 g) = 450 kcal, 40 g prote\\u00ednas, 60 g carbohidratos, 20 g grasas\\n- Timing nutricional: Comer 1-2 horas antes del entrenamiento, y 30-60 minutos despu\\u00e9s del entrenamiento con un snack de recuperaci\\u00f3n (20-30 g de prote\\u00ednas, 30-40 g de carbohidratos)\\n\\n## PLAN DE ENTRENAMIENTO\\n- D\\u00eda 1: Pecho y Tr\\u00edceps\\n  - Press de banca (3 series de 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Inclinaci\\u00f3n de press de banca (3 series de 10-15 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Extensiones de tr\\u00edceps (3 series de 12-15 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Fondos de tr\\u00edceps (3 series de 12-15 repeticiones, RIR 2, descanso 60-90 segundos)\\n- D\\u00eda 2: Espalda y B\\u00edceps\\n  - Remo con barra (3 series de 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Peso muerto (3 series de 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Curl de b\\u00edceps con barra (3 series de 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Curl de b\\u00edceps con mancuernas (3 series de 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n- D\\u00eda 3: Piernas\\n  - Sentadilla (3 series de 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Prensa de piernas (3 series de 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Extensiones de piernas (3 series de 12-15 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Curl de piernas (3 series de 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n- D\\u00eda 4: Hombros y Abdominales\\n  - Press de hombros (3 series de 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Elevaciones laterales (3 series de 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Elevaciones frontales (3 series de 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Plancha (3 series de 30-60 segundos, RIR 2, descanso 60-90 segundos)\\n- D\\u00eda 5: Entrenamiento de fuerza total\\n  - Peso muerto (3 series de 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Press de banca (3 series de 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Sentadilla (3 series de 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n\\n## PLAN DE CARDIO\\n- Tipo: Caminata en cinta o bicicleta est\\u00e1tica\\n- Duraci\\u00f3n: 20-30 minutos\\n- Intensidad: Moderada (50-60% de la frecuencia card\\u00edaca m\\u00e1xima)\\n\\n## PROGRESI\\u00d3N\\n- Aumentar el peso o la resistencia en un 2.5-5% cada semana\\n- Aumentar el n\\u00famero de repeticiones en un 2-3 cada semana\\n\\n## INDICACIONES PR\\u00c1CTICAS\\n- Beber al menos 2 litros de agua al d\\u00eda\\n- Dormir 7-9 horas cada noche\\n- Realizar estiramientos despu\\u00e9s de cada entrenamiento\\n\\nPor favor, env\\u00edeme su peso actualizado, medidas, rendimiento y sensaciones para continuar el seguimiento. Esto me permitir\\u00e1 ajustar y personalizar el plan de entrenamiento y nutrici\\u00f3n para lograr sus objetivos de recomposici\\u00f3n de manera efectiva y segura.\"}', '\nActúa como un médico especialista en nutrición deportiva, recomposición corporal e hipertrofia y preparador físico profesional, usando exclusivamente evidencia científica actual (ISSN, ACSM, NSCA).\n\nNo quiero explicaciones teóricas largas. Quiero decisiones prácticas, estructuradas y justificadas brevemente.\n\nDATOS PERSONALES:\n- Nombre: Kelly Rodriguez\n- Sexo: mujer\n- Edad: 30 años\n- Altura: 160.00 cm\n- Nivel: intermedio\n- Días de entrenamiento: 5 días por semana\n- Objetivo: recomposicion\n- Patologías: ninguna\n- Tiene ciclo menstrual: Sí\n\n\n\nGenera un plan semanal completo con este formato exacto:\n\n## PLAN NUTRICIONAL\n- Calorías totales y macros (proteínas/carbohidratos/grasas en gramos)\n- Plan de comidas con cantidades exactas en gramos\n- Timing nutricional (cuándo comer respecto al entreno)\n\n## PLAN DE ENTRENAMIENTO\n- Rutina completa para 5 días\n- Por cada ejercicio: series, repeticiones, RIR, descanso\n- Orden de ejercicios por día\n\n## PLAN DE CARDIO\n- Tipo, duración e intensidad\n\n## PROGRESIÓN\n- Cómo progresar semana a semana\n\n## INDICACIONES PRÁCTICAS\n- 3 puntos clave para este usuario específico\n\nAl final pídeme que te envíe: peso actualizado, medidas, rendimiento y sensaciones para continuar el seguimiento.\n', 1, '2026-03-07 01:00:15'),
(4, 1, 'Mi rutina', 'mensual', '{\"texto\":\"## PLAN NUTRICIONAL\\n- Calor\\u00edas totales: 1900 cal\\/d\\u00eda (para una mujer de 30 a\\u00f1os y 160 cm con objetivo de recomposici\\u00f3n)\\n- Macros: 120g prote\\u00ednas, 200g carbohidratos, 70g grasas\\n- Plan de comidas:\\n  - Desayuno: 3 huevos (180g), 2 rebanadas de pan integral (60g), 1 taza de frutas (150g) = 400 cal, 30g prote\\u00ednas, 60g carbohidratos, 20g grasas\\n  - Media ma\\u00f1ana: 1 batido de prote\\u00ednas (30g), 1 taza de frutas (150g) = 200 cal, 25g prote\\u00ednas, 30g carbohidratos, 10g grasas\\n  - Almuerzo: 120g de pollo a la parrilla, 100g de arroz integral, 100g de br\\u00f3coli = 400 cal, 35g prote\\u00ednas, 60g carbohidratos, 10g grasas\\n  - Merienda: 1 taza de yogur griego (200g), 1 taza de frutas (150g) = 200 cal, 20g prote\\u00ednas, 30g carbohidratos, 10g grasas\\n  - Cena: 120g de salm\\u00f3n a la parrilla, 100g de quinoa, 100g de espinacas = 400 cal, 35g prote\\u00ednas, 60g carbohidratos, 15g grasas\\n- Timing nutricional: comer 1 hora antes del entrenamiento, y 30 minutos despu\\u00e9s del entrenamiento (batido de prote\\u00ednas y carbohidratos)\\n\\n## PLAN DE ENTRENAMIENTO\\n- D\\u00eda 1: Pecho y Tr\\u00edceps\\n  - Press de banca (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Press de inclinaci\\u00f3n (3 series, 10-15 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Extensiones de tr\\u00edceps (3 series, 12-15 repeticiones, RIR 2, descanso 60-90 segundos)\\n- D\\u00eda 2: Espalda y B\\u00edceps\\n  - Remo a dos manos (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Peso muerto (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Curl de b\\u00edceps (3 series, 10-15 repeticiones, RIR 2, descanso 60-90 segundos)\\n- D\\u00eda 3: Piernas\\n  - Sentadillas (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Prensa de piernas (3 series, 10-15 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Extensiones de piernas (3 series, 12-15 repeticiones, RIR 2, descanso 60-90 segundos)\\n- D\\u00eda 4: Hombros y Abdominales\\n  - Press de hombros (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Elevaciones laterales (3 series, 10-15 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Planchas (3 series, 30-60 segundos, descanso 60-90 segundos)\\n- D\\u00eda 5: Cardio y Estiramientos\\n  - 30 minutos de cardio a intensidad moderada\\n  - Estiramientos para todos los grupos musculares\\n\\n## PLAN DE CARDIO\\n- Tipo: carrera o bicicleta est\\u00e1tica\\n- Duraci\\u00f3n: 30 minutos\\n- Intensidad: moderada (60-70% de la frecuencia card\\u00edaca m\\u00e1xima)\\n\\n## PROGRESI\\u00d3N\\n- Aumentar el peso o la resistencia en un 2.5-5% cada semana\\n- Aumentar el n\\u00famero de repeticiones en un 2-3 cada semana\\n\\n## INDICACIONES PR\\u00c1CTICAS\\n- Beber al menos 2 litros de agua al d\\u00eda\\n- Dormir 7-9 horas cada noche para ayudar en la recuperaci\\u00f3n\\n- Ajustar el plan de comidas seg\\u00fan las necesidades individuales y el progreso\\n\\nPor favor, env\\u00edame tu peso actualizado, medidas (cintura, cadera, muslo, brazo), rendimiento en los ejercicios y sensaciones generales despu\\u00e9s de un mes para continuar el seguimiento y ajustar el plan seg\\u00fan sea necesario.\"}', '\nActúa como un médico especialista en nutrición deportiva, recomposición corporal e hipertrofia y preparador físico profesional, usando exclusivamente evidencia científica actual (ISSN, ACSM, NSCA).\n\nNo quiero explicaciones teóricas largas. Quiero decisiones prácticas, estructuradas y justificadas brevemente.\n\nDATOS PERSONALES:\n- Nombre: Kelly Rodriguez\n- Sexo: mujer\n- Edad: 30 años\n- Altura: 160.00 cm\n- Nivel: intermedio\n- Días de entrenamiento: 5 días por semana\n- Objetivo: recomposicion\n- Patologías: ninguna\n- Tiene ciclo menstrual: Sí\n\n\n\nGenera un plan mensual completo con este formato exacto:\n\n## PLAN NUTRICIONAL\n- Calorías totales y macros (proteínas/carbohidratos/grasas en gramos)\n- Plan de comidas con cantidades exactas en gramos\n- Timing nutricional (cuándo comer respecto al entreno)\n\n## PLAN DE ENTRENAMIENTO\n- Rutina completa para 5 días\n- Por cada ejercicio: series, repeticiones, RIR, descanso\n- Orden de ejercicios por día\n\n## PLAN DE CARDIO\n- Tipo, duración e intensidad\n\n## PROGRESIÓN\n- Cómo progresar semana a semana\n\n## INDICACIONES PRÁCTICAS\n- 3 puntos clave para este usuario específico\n\nAl final pídeme que te envíe: peso actualizado, medidas, rendimiento y sensaciones para continuar el seguimiento.\n', 1, '2026-03-07 01:00:28'),
(5, 1, 'Mi rutina', 'diaria', '{\"texto\":\"## PLAN NUTRICIONAL\\n- Calor\\u00edas totales: 2200 cal, macros: 120g prote\\u00ednas, 250g carbohidratos, 70g grasas\\n- Plan de comidas:\\n  - Desayuno: 3 huevos (180g), 2 rebanadas de pan integral (120g), 1 vaso de leche sin lactosa (200g)\\n  - Media ma\\u00f1ana: 1 batido de prote\\u00ednas (30g), 1 pl\\u00e1tano (100g)\\n  - Almuerzo: 120g de pollo a la parrilla, 150g de arroz integral, 100g de br\\u00f3coli\\n  - Media tarde: 1 manzana (150g), 1 cucharada de mantequilla de man\\u00ed (16g)\\n  - Cena: 120g de salm\\u00f3n a la parrilla, 150g de quinoa, 100g de zanahorias\\n  - Antes de dormir: 1 vaso de leche sin lactosa (200g), 1 cucharada de case\\u00edna (30g)\\n- Timing nutricional: comer 1 hora antes del entrenamiento, 30 minutos despu\\u00e9s del entrenamiento (batido de prote\\u00ednas y carbohidratos)\\n\\n## PLAN DE ENTRENAMIENTO\\n- D\\u00eda 1: Pecho y Tr\\u00edceps\\n  - Press de banca (3 series, 8-12 repeticiones, RIR 2, 90 segundos de descanso)\\n  - Inclinaciones (3 series, 10-15 repeticiones, RIR 2, 90 segundos de descanso)\\n  - Extensiones de tr\\u00edceps (3 series, 12-15 repeticiones, RIR 2, 90 segundos de descanso)\\n  - Fondos (3 series, 10-12 repeticiones, RIR 2, 90 segundos de descanso)\\n- D\\u00eda 2: Espalda y B\\u00edceps\\n  - Remo (3 series, 8-12 repeticiones, RIR 2, 90 segundos de descanso)\\n  - Peso muerto (3 series, 8-12 repeticiones, RIR 2, 90 segundos de descanso)\\n  - Curl de b\\u00edceps (3 series, 10-12 repeticiones, RIR 2, 90 segundos de descanso)\\n  - Remo a una mano (3 series, 10-12 repeticiones, RIR 2, 90 segundos de descanso)\\n- D\\u00eda 3: Piernas\\n  - Sentadillas (3 series, 8-12 repeticiones, RIR 2, 90 segundos de descanso)\\n  - Prensa de piernas (3 series, 10-12 repeticiones, RIR 2, 90 segundos de descanso)\\n  - Extensiones de piernas (3 series, 12-15 repeticiones, RIR 2, 90 segundos de descanso)\\n  - Curl de piernas (3 series, 10-12 repeticiones, RIR 2, 90 segundos de descanso)\\n- D\\u00eda 4: Hombros y Abd\\u00f3men\\n  - Press de hombros (3 series, 8-12 repeticiones, RIR 2, 90 segundos de descanso)\\n  - Elevaciones laterales (3 series, 10-12 repeticiones, RIR 2, 90 segundos de descanso)\\n  - Crunch (3 series, 10-12 repeticiones, RIR 2, 90 segundos de descanso)\\n  - Russian twist (3 series, 10-12 repeticiones, RIR 2, 90 segundos de descanso)\\n- D\\u00eda 5: Revisi\\u00f3n\\n  - Revisar todos los grupos musculares con ejercicios anteriores\\n\\n## PLAN DE CARDIO\\n- 20 minutos de carrera en la cinta, 3 veces a la semana, a intensidad moderada\\n\\n## PROGRESI\\u00d3N\\n- Aumentar el peso en un 2.5% cada semana, o cuando se complete el n\\u00famero de repeticiones objetivo\\n\\n## INDICACIONES PR\\u00c1CTICAS\\n- Beber al menos 2 litros de agua al d\\u00eda\\n- Dormir 7-8 horas cada noche para una recuperaci\\u00f3n adecuada\\n- Ajustar el plan de comidas seg\\u00fan las necesidades individuales y el progreso\\n\\nPor favor, env\\u00edeme su peso actualizado, medidas corporales (incluyendo cintura y cadera), rendimiento en los ejercicios y sensaciones generales despu\\u00e9s de seguir este plan durante 4 semanas, para continuar el seguimiento y hacer ajustes seg\\u00fan sea necesario.\"}', '\nActúa como un médico especialista en nutrición deportiva, recomposición corporal e hipertrofia y preparador físico profesional, usando exclusivamente evidencia científica actual (ISSN, ACSM, NSCA).\n\nNo quiero explicaciones teóricas largas. Quiero decisiones prácticas, estructuradas y justificadas brevemente.\n\nDATOS PERSONALES:\n- Nombre: Kelly Rodriguez\n- Sexo: mujer\n- Edad: 30 años\n- Altura: 160.00 cm\n- Nivel: intermedio\n- Días de entrenamiento: 5 días por semana\n- Objetivo: ganar musculo\n- Patologías: ninguna\n- Tiene ciclo menstrual: Sí\n\nMEDIDAS CORPORALES ACTUALES:\n- Peso: 54.30 kg\n- Grasa corporal: 15.10%\n- Masa muscular: 36.50 kg\n- IMC: 21.20\n- Cintura:  cm\n- Cadera:  cm\nALIMENTOS HABITUALES DEL USUARIO: Leche Sin lactosa (Celta)\n\nGenera un plan diaria completo con este formato exacto:\n\n## PLAN NUTRICIONAL\n- Calorías totales y macros (proteínas/carbohidratos/grasas en gramos)\n- Plan de comidas con cantidades exactas en gramos\n- Timing nutricional (cuándo comer respecto al entreno)\n\n## PLAN DE ENTRENAMIENTO\n- Rutina completa para 5 días\n- Por cada ejercicio: series, repeticiones, RIR, descanso\n- Orden de ejercicios por día\n\n## PLAN DE CARDIO\n- Tipo, duración e intensidad\n\n## PROGRESIÓN\n- Cómo progresar semana a semana\n\n## INDICACIONES PRÁCTICAS\n- 3 puntos clave para este usuario específico\n\nAl final pídeme que te envíe: peso actualizado, medidas, rendimiento y sensaciones para continuar el seguimiento.\n', 1, '2026-03-07 12:30:40'),
(6, 1, 'Mi rutina', 'diaria', '{\"texto\":\"**PLAN NUTRICIONAL**\\n- Calor\\u00edas totales: 2200 calor\\u00edas\\n- Macros: 170g prote\\u00ednas, 250g carbohidratos, 70g grasas\\n- Plan de comidas:\\n  - Desayuno: 3 huevos (180g), 2 rebanadas de pan integral (120g), 1 vaso de leche sin lactosa (200g) - 400 calor\\u00edas, 30g prote\\u00ednas, 60g carbohidratos, 15g grasas\\n  - Media ma\\u00f1ana: 1 batido de prote\\u00ednas (30g), 1 pl\\u00e1tano (100g) - 200 calor\\u00edas, 25g prote\\u00ednas, 30g carbohidratos, 0g grasas\\n  - Almuerzo: 120g de pollo a la plancha, 150g de arroz integral, 100g de br\\u00f3coli - 400 calor\\u00edas, 40g prote\\u00ednas, 60g carbohidratos, 10g grasas\\n  - Merienda: 1 manzana (150g), 1 cucharada de mantequilla de man\\u00ed (16g) - 150 calor\\u00edas, 0g prote\\u00ednas, 30g carbohidratos, 8g grasas\\n  - Cena: 120g de salm\\u00f3n a la plancha, 150g de quinoa, 100g de espinacas - 400 calor\\u00edas, 40g prote\\u00ednas, 60g carbohidratos, 15g grasas\\n  - Cena tard\\u00eda (antes de dormir): 1 vaso de leche sin lactosa (200g), 1 cucharada de case\\u00edna (30g) - 200 calor\\u00edas, 20g prote\\u00ednas, 30g carbohidratos, 0g grasas\\n- Timing nutricional: \\n  - Desayuno 1 hora antes del entrenamiento\\n  - Media ma\\u00f1ana inmediatamente despu\\u00e9s del entrenamiento\\n  - Almuerzo 2 horas despu\\u00e9s del entrenamiento\\n  - Merienda 2 horas antes del entrenamiento (si el entrenamiento es por la tarde)\\n  - Cena 1 hora despu\\u00e9s del entrenamiento (si el entrenamiento es por la tarde)\\n  - Cena tard\\u00eda 30 minutos antes de dormir\\n\\n**PLAN DE ENTRENAMIENTO**\\n- D\\u00eda 1: Entrenamiento de pecho y tr\\u00edceps\\n  - Press de banca (3 series de 8-12 repeticiones, RIR 2, descanso 90 segundos)\\n  - Inclinaciones (3 series de 10-15 repeticiones, RIR 2, descanso 90 segundos)\\n  - Extensiones de tr\\u00edceps (3 series de 12-15 repeticiones, RIR 2, descanso 60 segundos)\\n  - Fondos (3 series de 10-12 repeticiones, RIR 2, descanso 90 segundos)\\n- D\\u00eda 2: Entrenamiento de espalda y b\\u00edceps\\n  - Remo (3 series de 8-12 repeticiones, RIR 2, descanso 90 segundos)\\n  - Peso muerto (3 series de 8-12 repeticiones, RIR 2, descanso 120 segundos)\\n  - Curl de b\\u00edceps (3 series de 10-12 repeticiones, RIR 2, descanso 60 segundos)\\n  - Remo a una mano (3 series de 10-12 repeticiones, RIR 2, descanso 90 segundos)\\n- D\\u00eda 3: Entrenamiento de piernas\\n  - Sentadillas (3 series de 8-12 repeticiones, RIR 2, descanso 120 segundos)\\n  - Prensa de piernas (3 series de 10-12 repeticiones, RIR 2, descanso 90 segundos)\\n  - Extensiones de piernas (3 series de 12-15 repeticiones, RIR 2, descanso 60 segundos)\\n  - Curl de piernas (3 series de 10-12 repeticiones, RIR 2, descanso 90 segundos)\\n- D\\u00eda 4: Entrenamiento de hombros y abdominales\\n  - Press de hombros (3 series de 8-12 repeticiones, RIR 2, descanso 90 segundos)\\n  - Elevaciones laterales (3 series de 10-12 repeticiones, RIR 2, descanso 60 segundos)\\n  - Elevaciones frontales (3 series de 10-12 repeticiones, RIR 2, descanso 60 segundos)\\n  - Planchas (3 series de 30-60 segundos, RIR 2, descanso 60 segundos)\\n- D\\u00eda 5: Entrenamiento de pecho y tr\\u00edceps\\n  - Press de banca inclinado (3 series de 8-12 repeticiones, RIR 2, descanso 90 segundos)\\n  - Extensiones de tr\\u00edceps con cuerda (3 series de 10-12 repeticiones, RIR 2, descanso 60 segundos)\\n  - Fondos inclinados (3 series de 10-12 repeticiones, RIR 2, descanso 90 segundos)\\n  - Tr\\u00edceps con barra (3 series de 10-12 repeticiones, RIR 2, descanso 60 segundos)\\n\\n**PLAN DE CARDIO**\\n- Tipo: Caminata en cinta o bicicleta est\\u00e1tica\\n- Duraci\\u00f3n: 20-30 minutos\\n- Intensidad: Moderada (50-60% de la frecuencia card\\u00edaca m\\u00e1xima)\\n\\n**PROGRESI\\u00d3N**\\n- Aumentar el peso o la resistencia en 2,5-5 kg cada semana\\n- Aumentar el n\\u00famero de repeticiones en 2-3 cada semana\\n\\n**INDICACIONES PR\\u00c1CTICAS**\\n- Asegurarse de consumir suficientes prote\\u00ednas despu\\u00e9s del entrenamiento para ayudar a la recuperaci\\u00f3n muscular\\n- Asegurarse de hidratarse adecuadamente antes, durante y despu\\u00e9s del entrenamiento\\n- Asegurarse de dormir lo suficiente (7-9 horas) para ayudar a la recuperaci\\u00f3n muscular y la ganancia de masa muscular\\n\\nPor favor, env\\u00edeme su peso actualizado, medidas, rendimiento y sensaciones en los pr\\u00f3ximos 7-10 d\\u00edas para continuar el seguimiento y ajustar el plan seg\\u00fan sea necesario.\"}', '\nActúa como un médico especialista en nutrición deportiva, recomposición corporal e hipertrofia y preparador físico profesional, usando exclusivamente evidencia científica actual (ISSN, ACSM, NSCA).\n\nNo quiero explicaciones teóricas largas. Quiero decisiones prácticas, estructuradas y justificadas brevemente.\n\nDATOS PERSONALES:\n- Nombre: Kelly Rodriguez\n- Sexo: mujer\n- Edad: 30 años\n- Altura: 160.00 cm\n- Nivel: intermedio\n- Días de entrenamiento: 5 días por semana\n- Objetivo: ganar musculo\n- Patologías: ninguna\n- Tiene ciclo menstrual: Sí\n\nMEDIDAS CORPORALES ACTUALES:\n- Peso: 54.30 kg\n- Grasa corporal: 15.10%\n- Masa muscular: 36.50 kg\n- IMC: 21.20\n- Cintura:  cm\n- Cadera:  cm\nALIMENTOS HABITUALES DEL USUARIO: Leche Sin lactosa (Celta)\n\nGenera un plan diaria completo con este formato exacto:\n\n## PLAN NUTRICIONAL\n- Calorías totales y macros (proteínas/carbohidratos/grasas en gramos)\n- Plan de comidas con cantidades exactas en gramos\n- Timing nutricional (cuándo comer respecto al entreno)\n\n## PLAN DE ENTRENAMIENTO\n- Rutina completa para 5 días\n- Por cada ejercicio: series, repeticiones, RIR, descanso\n- Orden de ejercicios por día\n\n## PLAN DE CARDIO\n- Tipo, duración e intensidad\n\n## PROGRESIÓN\n- Cómo progresar semana a semana\n\n## INDICACIONES PRÁCTICAS\n- 3 puntos clave para este usuario específico\n\nAl final pídeme que te envíe: peso actualizado, medidas, rendimiento y sensaciones para continuar el seguimiento.\n', 1, '2026-03-07 12:32:26'),
(7, 1, 'Mi rutina', 'semanal', '{\"texto\":\"## PLAN NUTRICIONAL\\n- Calor\\u00edas totales: 2200 kcal, macros: 120g prote\\u00ednas, 250g carbohidratos, 70g grasas\\n- Plan de comidas:\\n  - Desayuno: 3 huevos (180g), 2 rebanadas de pan integral (60g), 1 vaso de leche sin lactosa (200g) = 440 kcal, 30g prote\\u00ednas, 60g carbohidratos, 15g grasas\\n  - Snack ma\\u00f1ana: 1 batido de prote\\u00ednas (30g), 1 banana (100g) = 200 kcal, 25g prote\\u00ednas, 30g carbohidratos, 0g grasas\\n  - Almuerzo: 120g de pollo a la parrilla, 150g de arroz integral, 100g de br\\u00f3coli = 400 kcal, 40g prote\\u00ednas, 60g carbohidratos, 10g grasas\\n  - Snack tarde: 1 manzana (150g), 20g de almendras = 150 kcal, 0g prote\\u00ednas, 30g carbohidratos, 8g grasas\\n  - Cena: 120g de salm\\u00f3n a la parrilla, 150g de quinoa, 100g de espinacas = 500 kcal, 40g prote\\u00ednas, 60g carbohidratos, 20g grasas\\n- Timing nutricional: comer 1 hora antes del entrenamiento, snack de prote\\u00ednas y carbohidratos 30 minutos despu\\u00e9s del entrenamiento\\n\\n## PLAN DE ENTRENAMIENTO\\n- Lunes (pecho y tr\\u00edceps):\\n  - Press de banca: 3 series de 8-12 repeticiones, RIR 2, descanso 60-90 segundos\\n  - Inclinaciones: 3 series de 10-15 repeticiones, RIR 2, descanso 60-90 segundos\\n  - Extensiones de tr\\u00edceps: 3 series de 12-15 repeticiones, RIR 2, descanso 60-90 segundos\\n- Martes (espaldas y b\\u00edceps):\\n  - Remo: 3 series de 8-12 repeticiones, RIR 2, descanso 60-90 segundos\\n  - Peso muerto: 3 series de 8-12 repeticiones, RIR 2, descanso 60-90 segundos\\n  - Curl de b\\u00edceps: 3 series de 10-12 repeticiones, RIR 2, descanso 60-90 segundos\\n- Mi\\u00e9rcoles (piernas):\\n  - Sentadillas: 3 series de 8-12 repeticiones, RIR 2, descanso 60-90 segundos\\n  - Prensa de piernas: 3 series de 10-12 repeticiones, RIR 2, descanso 60-90 segundos\\n  - Extensiones de piernas: 3 series de 12-15 repeticiones, RIR 2, descanso 60-90 segundos\\n- Jueves (hombros y abdominales):\\n  - Press de hombros: 3 series de 8-12 repeticiones, RIR 2, descanso 60-90 segundos\\n  - Elevaciones laterales: 3 series de 10-12 repeticiones, RIR 2, descanso 60-90 segundos\\n  - Planchas: 3 series de 30-60 segundos, RIR 2, descanso 60-90 segundos\\n- Viernes (pecho y tr\\u00edceps):\\n  - Press de banca inclinado: 3 series de 8-12 repeticiones, RIR 2, descanso 60-90 segundos\\n  - Extensiones de tr\\u00edceps con cuerda: 3 series de 10-12 repeticiones, RIR 2, descanso 60-90 segundos\\n  - Fondos: 3 series de 10-12 repeticiones, RIR 2, descanso 60-90 segundos\\n\\n## PLAN DE CARDIO\\n- Tipo: carrera en cinta, duraci\\u00f3n: 20-30 minutos, intensidad: moderada\\n\\n## PROGRESI\\u00d3N\\n- Aumentar el peso o las repeticiones cada semana en un 2,5-5%\\n\\n## INDICACIONES PR\\u00c1CTICAS\\n- 1. Asegurarse de consumir suficientes prote\\u00ednas despu\\u00e9s del entrenamiento para promover la recuperaci\\u00f3n muscular.\\n- 2. Incorporar variedad en la dieta para asegurar la ingesta de todos los nutrientes necesarios.\\n- 3. Escuchar al cuerpo y descansar cuando sea necesario para evitar lesiones.\\n\\nPor favor, env\\u00edeme su peso actualizado, medidas, rendimiento y sensaciones para continuar el seguimiento despu\\u00e9s de una semana. Esto me permitir\\u00e1 ajustar el plan seg\\u00fan sea necesario para asegurar el progreso hacia su objetivo de ganar m\\u00fasculo.\"}', '\nActúa como un médico especialista en nutrición deportiva, recomposición corporal e hipertrofia y preparador físico profesional, usando exclusivamente evidencia científica actual (ISSN, ACSM, NSCA).\n\nNo quiero explicaciones teóricas largas. Quiero decisiones prácticas, estructuradas y justificadas brevemente.\n\nDATOS PERSONALES:\n- Nombre: Kelly Rodriguez\n- Sexo: mujer\n- Edad: 30 años\n- Altura: 160.00 cm\n- Nivel: intermedio\n- Días de entrenamiento: 5 días por semana\n- Objetivo: ganar musculo\n- Patologías: ninguna\n- Tiene ciclo menstrual: Sí\n\nMEDIDAS CORPORALES ACTUALES:\n- Peso: 54.30 kg\n- Grasa corporal: 15.10%\n- Masa muscular: 36.50 kg\n- IMC: 21.20\n- Cintura:  cm\n- Cadera:  cm\nALIMENTOS HABITUALES DEL USUARIO: Leche Sin lactosa (Celta)\n\nGenera un plan semanal completo con este formato exacto:\n\n## PLAN NUTRICIONAL\n- Calorías totales y macros (proteínas/carbohidratos/grasas en gramos)\n- Plan de comidas con cantidades exactas en gramos\n- Timing nutricional (cuándo comer respecto al entreno)\n\n## PLAN DE ENTRENAMIENTO\n- Rutina completa para 5 días\n- Por cada ejercicio: series, repeticiones, RIR, descanso\n- Orden de ejercicios por día\n\n## PLAN DE CARDIO\n- Tipo, duración e intensidad\n\n## PROGRESIÓN\n- Cómo progresar semana a semana\n\n## INDICACIONES PRÁCTICAS\n- 3 puntos clave para este usuario específico\n\nAl final pídeme que te envíe: peso actualizado, medidas, rendimiento y sensaciones para continuar el seguimiento.\n', 1, '2026-03-07 12:32:47'),
(8, 1, 'Mi rutina', 'diaria', '{\"texto\":\"## PLAN NUTRICIONAL\\n- Calor\\u00edas totales: 2200 kcal, macros: prote\\u00ednas 120g, carbohidratos 250g, grasas 70g\\n- Plan de comidas:\\n  - Desayuno: 3 huevos (180g), 2 rebanadas de pan integral (60g), 1 taza de frutas (150g) = 390 kcal, 30g prote\\u00ednas, 40g carbohidratos, 15g grasas\\n  - Snack ma\\u00f1anero: 1 taza de leche sin lactosa (240g), 1 cucharada de prote\\u00edna en polvo (30g) = 150 kcal, 20g prote\\u00ednas, 20g carbohidratos, 0g grasas\\n  - Almuerzo: 120g de pechuga de pollo, 100g de arroz integral, 100g de br\\u00f3coli = 350 kcal, 40g prote\\u00ednas, 40g carbohidratos, 10g grasas\\n  - Snack vespertino: 1 taza de yogur griego (200g), 1\\/2 taza de frutas (75g) = 100 kcal, 15g prote\\u00ednas, 20g carbohidratos, 0g grasas\\n  - Cena: 120g de salm\\u00f3n, 100g de quinoa, 100g de zanahorias = 350 kcal, 35g prote\\u00ednas, 40g carbohidratos, 15g grasas\\n  - Snack nocturno (antes de dormir): 1 taza de leche sin lactosa (240g), 1 cucharada de case\\u00edna (30g) = 150 kcal, 20g prote\\u00ednas, 20g carbohidratos, 0g grasas\\n- Timing nutricional: 1 hora antes del entrenamiento, 30-60 minutos despu\\u00e9s del entrenamiento, y cada 3 horas durante el d\\u00eda\\n\\n## PLAN DE ENTRENAMIENTO\\n- D\\u00eda 1: Pecho y Tr\\u00edceps\\n  - Press de banca (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Press inclinado (3 series, 10-15 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Extensiones de tr\\u00edceps (3 series, 12-15 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Fondos (3 series, 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n- D\\u00eda 2: Espalda y B\\u00edceps\\n  - Remo (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Peso muerto (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Curl de b\\u00edceps (3 series, 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Hammer curl (3 series, 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n- D\\u00eda 3: Piernas\\n  - Sentadilla (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Peso muerto (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Press de piernas (3 series, 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Extensiones de piernas (3 series, 12-15 repeticiones, RIR 2, descanso 60-90 segundos)\\n- D\\u00eda 4: Hombros y Abdominales\\n  - Press militar (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Elevaciones laterales (3 series, 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Plancha (3 series, 30-60 segundos, RIR 2, descanso 60-90 segundos)\\n  - Crunch (3 series, 10-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n- D\\u00eda 5: Entrenamiento de fuerza total\\n  - Sentadilla (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Peso muerto (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Press de banca (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n  - Remo (3 series, 8-12 repeticiones, RIR 2, descanso 60-90 segundos)\\n\\n## PLAN DE CARDIO\\n- Tipo: Caminata o correr en la cinta\\n- Duraci\\u00f3n: 20-30 minutos\\n- Intensidad: Moderada\\n\\n## PROGRESI\\u00d3N\\n- Aumentar el peso utilizado en 2.5-5 kg cada semana\\n- Aumentar el n\\u00famero de repeticiones en 2-3 cada semana\\n\\n## INDICACIONES PR\\u00c1CTICAS\\n- Asegurarse de consumir suficientes prote\\u00ednas despu\\u00e9s del entrenamiento para ayudar en la recuperaci\\u00f3n muscular\\n- Asegurarse de dormir lo suficiente (7-9 horas) cada noche para ayudar en la recuperaci\\u00f3n muscular\\n- Asegurarse de beber suficiente agua durante el d\\u00eda (al menos 2 litros) para ayudar en la hidrataci\\u00f3n\\n\\nPor favor, env\\u00edeme su peso actualizado, medidas, rendimiento y sensaciones despu\\u00e9s de seguir este plan durante 4 semanas para continuar el seguimiento.\"}', '\nActúa como un médico especialista en nutrición deportiva, recomposición corporal e hipertrofia y preparador físico profesional, usando exclusivamente evidencia científica actual (ISSN, ACSM, NSCA).\n\nNo quiero explicaciones teóricas largas. Quiero decisiones prácticas, estructuradas y justificadas brevemente.\n\nDATOS PERSONALES:\n- Nombre: Kelly Rodriguez\n- Sexo: mujer\n- Edad: 30 años\n- Altura: 160.00 cm\n- Nivel: intermedio\n- Días de entrenamiento: 5 días por semana\n- Objetivo: ganar musculo\n- Patologías: ninguna\n- Tiene ciclo menstrual: Sí\n\nMEDIDAS CORPORALES ACTUALES:\n- Peso: 54.30 kg\n- Grasa corporal: 15.10%\n- Masa muscular: 36.50 kg\n- IMC: 21.20\n- Cintura:  cm\n- Cadera:  cm\nALIMENTOS HABITUALES DEL USUARIO: Leche Sin lactosa (Celta)\n\nGenera un plan diaria completo con este formato exacto:\n\n## PLAN NUTRICIONAL\n- Calorías totales y macros (proteínas/carbohidratos/grasas en gramos)\n- Plan de comidas con cantidades exactas en gramos\n- Timing nutricional (cuándo comer respecto al entreno)\n\n## PLAN DE ENTRENAMIENTO\n- Rutina completa para 5 días\n- Por cada ejercicio: series, repeticiones, RIR, descanso\n- Orden de ejercicios por día\n\n## PLAN DE CARDIO\n- Tipo, duración e intensidad\n\n## PROGRESIÓN\n- Cómo progresar semana a semana\n\n## INDICACIONES PRÁCTICAS\n- 3 puntos clave para este usuario específico\n\nAl final pídeme que te envíe: peso actualizado, medidas, rendimiento y sensaciones para continuar el seguimiento.\n', 1, '2026-03-07 12:32:57');

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
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `nombre`, `email`, `foto_perfil`, `password`, `sexo`, `fecha_nacimiento`, `altura_cm`, `peso_actual`, `peso_objetivo`, `grasa_objetivo`, `objetivo`, `dias_entrenamiento`, `nivel`, `tiene_ciclo`, `fecha_ultimo_ciclo`, `duracion_ciclo`, `token`, `created_at`) VALUES
(1, 'Kelly Rodriguez', 'kelly@forja.com', NULL, '$2y$10$wY1gAC99YQdsmaS7ClJ0xuf9IhDX7m4/HKC945zXeoZYFlYpmAItu', 'mujer', '1995-03-15', 160.00, NULL, 62.00, 20.0, 'ganar_musculo', 5, 'intermedio', 1, NULL, 28, '26309bb408bcc621581a4519d57860d98a36d997a80354d4e4557c53cb168798_1_1772844552', '2026-03-06 22:36:27');

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
  ADD PRIMARY KEY (`id`);

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
  ADD KEY `ejercicio_id` (`ejercicio_id`);

--
-- Indices de la tabla `medidas`
--
ALTER TABLE `medidas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`);

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
-- AUTO_INCREMENT de la tabla `ejercicios`
--
ALTER TABLE `ejercicios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `ejercicios_imagenes`
--
ALTER TABLE `ejercicios_imagenes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `log_entreno`
--
ALTER TABLE `log_entreno`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `medidas`
--
ALTER TABLE `medidas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `registro_comidas`
--
ALTER TABLE `registro_comidas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `rutinas`
--
ALTER TABLE `rutinas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

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
-- Filtros para la tabla `log_entreno`
--
ALTER TABLE `log_entreno`
  ADD CONSTRAINT `log_entreno_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `log_entreno_ibfk_2` FOREIGN KEY (`ejercicio_id`) REFERENCES `ejercicios` (`id`);

--
-- Filtros para la tabla `medidas`
--
ALTER TABLE `medidas`
  ADD CONSTRAINT `medidas_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

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
