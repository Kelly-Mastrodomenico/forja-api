CREATE DATABASE IF NOT EXISTS forja_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE forja_db;

CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    sexo ENUM('hombre','mujer','otro') NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    altura_cm DECIMAL(5,2) NOT NULL,
    peso_actual DECIMAL(5,2),
    objetivo ENUM('perder_grasa','ganar_musculo','recomposicion','mantenimiento') NOT NULL,
    dias_entrenamiento TINYINT NOT NULL DEFAULT 3,
    nivel ENUM('principiante','intermedio','avanzado') NOT NULL DEFAULT 'principiante',
    tiene_ciclo BOOLEAN DEFAULT FALSE,
    fecha_ultimo_ciclo DATE NULL,
    duracion_ciclo TINYINT DEFAULT 28,
    token VARCHAR(255) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE usuario_patologias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    patologia ENUM('sop','hipotiroidismo','resistencia_insulina',
                   'endometriosis','diabetes_tipo2','ninguna') NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

CREATE TABLE medidas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    fecha DATE NOT NULL,
    peso_kg DECIMAL(5,2),
    grasa_corporal DECIMAL(5,2),
    masa_muscular DECIMAL(5,2),
    masa_esqueletica DECIMAL(5,2),
    contenido_agua DECIMAL(5,2),
    imc DECIMAL(5,2),
    grasa_visceral TINYINT,
    metabolismo_basal INT,
    cintura_cm DECIMAL(5,2),
    cadera_cm DECIMAL(5,2),
    pecho_cm DECIMAL(5,2),
    cuello_cm DECIMAL(5,2),
    bicep_der_cm DECIMAL(5,2),
    bicep_izq_cm DECIMAL(5,2),
    cuadriceps_der_cm DECIMAL(5,2),
    cuadriceps_izq_cm DECIMAL(5,2),
    pantorrilla_der_cm DECIMAL(5,2),
    pantorrilla_izq_cm DECIMAL(5,2),
    fuente ENUM('manual','foto_bascula','bluetooth') DEFAULT 'manual',
    notas TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

CREATE TABLE alimentos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NULL,
    nombre VARCHAR(150) NOT NULL,
    marca VARCHAR(100),
    calorias_100g DECIMAL(7,2),
    proteinas_100g DECIMAL(7,2),
    carbohidratos_100g DECIMAL(7,2),
    grasas_100g DECIMAL(7,2),
    fibra_100g DECIMAL(7,2),
    es_escaneado BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE SET NULL
);

CREATE TABLE registro_comidas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    alimento_id INT NOT NULL,
    fecha DATE NOT NULL,
    momento ENUM('desayuno','media_manana','almuerzo','merienda',
                 'cena','pre_entreno','post_entreno') NOT NULL,
    cantidad_gramos DECIMAL(7,2) NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (alimento_id) REFERENCES alimentos(id)
);

CREATE TABLE rutinas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    tipo ENUM('diaria','semanal','mensual') NOT NULL,
    contenido_json LONGTEXT NOT NULL,
    prompt_usado TEXT,
    activa BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

CREATE TABLE ejercicios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    grupo_muscular ENUM('pecho','espalda','hombros','biceps','triceps',
                        'cuadriceps','isquiotibiales','gluteos',
                        'pantorrillas','abdomen','trapecio') NOT NULL,
    tipo ENUM('compuesto','aislamiento','cardio') NOT NULL,
    activacion_emg TINYINT DEFAULT 5,
    descripcion TEXT,
    video_url VARCHAR(255)
);

CREATE TABLE log_entreno (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    fecha DATE NOT NULL,
    ejercicio_id INT NOT NULL,
    series_completadas TINYINT,
    reps_completadas TINYINT,
    peso_kg DECIMAL(6,2),
    rir TINYINT,
    rpe TINYINT,
    fatiga_post TINYINT,
    notas VARCHAR(255),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (ejercicio_id) REFERENCES ejercicios(id)
);

CREATE TABLE checkin_fotos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    fecha DATE NOT NULL,
    foto_url VARCHAR(255) NOT NULL,
    analisis_ia TEXT,
    tipo ENUM('frontal','lateral','posterior') NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

CREATE TABLE analisis_sangre (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    fecha DATE NOT NULL,
    pdf_url VARCHAR(255),
    valores_json TEXT,
    recomendaciones_ia TEXT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

CREATE TABLE ciclo_menstrual (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    duracion_dias TINYINT DEFAULT 28,
    sintomas TEXT,
    fase_actual ENUM('folicular','ovulatoria','lutea','menstruacion'),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);