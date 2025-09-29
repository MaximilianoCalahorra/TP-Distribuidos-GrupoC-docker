USE `tp-distribuidos-grupoc`;

INSERT INTO roles (nombre) VALUES 
('PRESIDENTE'),
('VOCAL'),
('COORDINADOR'),
('VOLUNTARIO');

INSERT INTO usuarios (nombre_de_usuario, nombre, apellido, email, clave, telefono, activo, id_rol) VALUES
('j.perez', 'Juan', 'Pérez', 'j.perez@empuje-comunitario.com', '$2a$10$n7tX2QQirdHE8RcCgKIbiuKT0ZI3hfe9TchIKhx0TYd.ccJdZ2F3q', '+54112345678', 1, 1);