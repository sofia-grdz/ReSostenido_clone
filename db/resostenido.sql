DROP DATABASE IF EXISTS resostenido;

CREATE DATABASE resostenido;

USE resostenido;

CREATE TABLE usuarios (
  id int(11) AUTO_INCREMENT,
  email VARCHAR(255) UNIQUE NOT NULL,
  nombre VARCHAR(55) NOT NULL,
  apellidos VARCHAR(110) NOT NULL,
  numero_telefono VARCHAR(15) NOT NULL,
  contrasenia VARCHAR(60) NOT NULL,
  es_admin BOOLEAN DEFAULT 0,
  verificado BOOLEAN DEFAULT 0,
  PRIMARY KEY(id)
);

CREATE TABLE tokens_verificacion (
  token VARCHAR(64) UNIQUE NOT NULL,
  fecha_expiracion DATETIME NOT NULL,
  id_usuario int(11) NOT NULL,
  CONSTRAINT fk_usuario_token_verificacion
  FOREIGN KEY (id_usuario) REFERENCES usuarios(id)
);

CREATE TABLE tokens_recuperacion_contrasenia (
  token VARCHAR(64) UNIQUE NOT NULL,
  id_usuario int(11) NOT NULL,
  CONSTRAINT fk_usuario_token_recuperacion
  FOREIGN KEY (id_usuario) REFERENCES usuarios(id)
);

CREATE TABLE servicios (
  id int(11) AUTO_INCREMENT,
  precio DECIMAL(10, 2) NOT NULL,
  grupo VARCHAR(55),
  nombre_instrumento VARCHAR(55) NOT NULL,
  descripcion VARCHAR(255),
  url_imagen VARCHAR(255),
  activo BOOLEAN DEFAULT 1,
  PRIMARY KEY(id)
);

CREATE TABLE citas (
  id int(11) AUTO_INCREMENT,
  fecha DATE NOT NULL,
  hora TIME NOT NULL,
  motivo VARCHAR(255),
  id_servicio int(11) NOT NULL,
  id_usuario int(11) NOT NULL,
  CONSTRAINT fk_servicio_cita
  FOREIGN KEY (id_servicio) REFERENCES servicios(id),
  CONSTRAINT fk_servicio_usuario
  FOREIGN KEY (id_usuario) REFERENCES usuarios(id),
  PRIMARY KEY(id)
);

DELIMITER $$
DROP FUNCTION IF EXISTS validar_disponibilidad_fecha_cita;
CREATE FUNCTION validar_disponibilidad_fecha_cita(fecha DATE, hora TIME, fecha_y_hora_actual DATETIME)
  RETURNS JSON 
  BEGIN

    DECLARE indice_dia_en_la_semana INT;
    DECLARE cantidad_citas INT;

    SET fecha_y_hora_actual = IFNULL(fecha_y_hora_actual, CONVERT_TZ(UTC_TIMESTAMP(), '+00:00', '-07:00'));

    SET indice_dia_en_la_semana = WEEKDAY(fecha);

    IF indice_dia_en_la_semana = 6 THEN
      RETURN JSON_OBJECT('disponible', false, 'mensaje', 'El taller no se encuentra abierto los domingos');
    END IF;
    
    IF NOT hora >= '09:00:00' OR NOT hora <= '17:00:00' THEN
      RETURN JSON_OBJECT('disponible', false, 'mensaje', 'El taller se encuentra abierto desde las 9:00 AM hasta las 6:00 PM, solo se pueden agendar citas desde las 9:00 AM hasta las 5:00 PM');
    END IF;

    IF ADDTIME(CONVERT(fecha, DATETIME), hora) <= fecha_y_hora_actual THEN
      RETURN JSON_OBJECT('disponible', false, 'mensaje', 'Esa fecha ya pasó');
    END IF;

    SET cantidad_citas = (
      SELECT COUNT(*)
      FROM citas
      WHERE citas.fecha = fecha
    );

    IF cantidad_citas >= 8 THEN
      RETURN JSON_OBJECT('disponible', false, 'mensaje', 'Ya hay 8 citas para este dia');
    END IF;
    
    RETURN JSON_OBJECT('disponible', true, 'mensaje', NULL);
  END;$$
DELIMITER ;

/*-- Inserta información para Guitarras
INSERT INTO servicios (precio, grupo, nombre_instrumento, descripcion, url_imagen)
VALUES (350.00, 'Guitarras', 'Guitarra acústica', 'Calibración', 'landingpage-1.jpg');

INSERT INTO servicios (precio, grupo, nombre_instrumento, descripcion, url_imagen)
VALUES (350.00, 'Guitarras', 'Guitarra eléctrica 6 cuerdas', 'Calibración', 'landingpage-1.jpg');

INSERT INTO servicios (precio, grupo, nombre_instrumento, descripcion, url_imagen)
VALUES (400.00, 'Guitarras', 'Guitarra eléctrica 7 cuerdas', 'Calibración', 'landingpage-1.jpg');

INSERT INTO servicios (precio, grupo, nombre_instrumento, descripcion, url_imagen)
VALUES (450.00, 'Guitarras', 'Guitarra eléctrica 8 cuerdas', 'Calibración', 'landingpage-1.jpg');

INSERT INTO servicios (precio, grupo, nombre_instrumento, descripcion, url_imagen)
VALUES (450.00, 'Guitarras', 'Guitarra eléctrica con Floyd Rose o Kahler', 'Calibración', 'landingpage-1.jpg');

-- Inserta información para Bajos
INSERT INTO servicios (precio, grupo, nombre_instrumento, descripcion, url_imagen)
VALUES (350.00, 'Bajos', 'Bajo 4 cuerdas', 'Calibración', 'landingpage-1.jpg');

INSERT INTO servicios (precio, grupo, nombre_instrumento, descripcion, url_imagen)
VALUES (400.00, 'Bajos', 'Bajo 5 cuerdas', 'Calibración', 'landingpage-1.jpg');

INSERT INTO servicios (precio, grupo, nombre_instrumento, descripcion, url_imagen)
VALUES (450.00, 'Bajos', 'Bajo 6 cuerdas', 'Calibración', 'landingpage-1.jpg');

-- Inserta información para otros instrumentos
INSERT INTO servicios (precio, grupo, nombre_instrumento, descripcion, url_imagen)
VALUES (450.00, 'Otros', 'Bajo quinto', 'Calibración', 'landingpage-1.jpg');

INSERT INTO servicios (precio, grupo, nombre_instrumento, descripcion, url_imagen)
VALUES (450.00, 'Otros', 'Docerola', 'Calibración', 'landingpage-1.jpg');

INSERT INTO servicios (precio, grupo, nombre_instrumento, descripcion, url_imagen)
VALUES (450.00, 'Otros', 'Bajo sexto', 'Calibración', 'landingpage-1.jpg');




INSERT INTO usuarios (email, nombre, apellidos, numero_telefono, contrasenia, es_admin, verificado) VALUES ('si@gmail.com', 'asd', 'pasdo', '1234124', 'axf234', 0, 1);

INSERT INTO citas (fecha, hora, motivo, id_servicio, id_usuario) VALUES ('2023-10-19', '08:28', 'test', 1, 1);
*/