DROP DATABASE IF EXISTS austral;
CREATE DATABASE austral;
USE austral;
CREATE TABLE autores (
    id_autor INT AUTO_INCREMENT,
    nombre VARCHAR(80) NOT NULL,
    pais VARCHAR(60) NULL,
    genero ENUM('Cómic', 'Ensayo', 'Infantil', 'Novela', 'Poesía') NOT NULL,
    PRIMARY KEY (id_autor)
);
CREATE TABLE colecciones (
    id_coleccion INT AUTO_INCREMENT,
    titulo VARCHAR(120) NOT NULL,
    fecha_publicacion DATE NOT NULL,
    PRIMARY KEY (id_coleccion)
);
CREATE TABLE libros (
    id_libro INT AUTO_INCREMENT,
    id_autor INT NOT NULL,
    id_coleccion INT NULL,
    titulo VARCHAR(120) NOT NULL,
    paginas INT NOT NULL,
    ejemplares_vendidos INT NOT NULL,
    anio INT NOT NULL,
    PRIMARY KEY (id_libro),
    FOREIGN KEY (id_autor) REFERENCES autores(id_autor),
    FOREIGN KEY (id_coleccion) REFERENCES colecciones(id_coleccion)
);
CREATE TABLE pagos (
    id_pago INT AUTO_INCREMENT,
    id_autor INT NOT NULL,
    fecha_pago DATE NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_pago),
    FOREIGN KEY (id_autor) REFERENCES autores(id_autor)
);
INSERT INTO autores (nombre, pais, genero) VALUES
('Elena Pizarro', 'Chile', 'Novela'),
('Harold Finch', 'Inglaterra', 'Ensayo'),
('Rodrigo Bahamonde', 'Chile', 'Poesía'),
('Valentina Correa', 'Argentina', 'Infantil'),
('Nora Keller', 'Estados Unidos', 'Novela'),
('Kenji Arakawa', NULL, 'Cómic');

INSERT INTO libros
(id_autor, titulo, paginas, ejemplares_vendidos, anio)
VALUES
(1, 'Cielo de Enero', 210, 1500, 2024),
(1, 'Marea Baja', 185, 800, 2023),
(1, 'El Norte', 200, 2200, 2024),
(2, 'Estrellas que Caen', 240, 3000, 2022),
(2, 'Máquinas', 215, 450, 2024),
(3, 'Luz Artificial', 300, 1200, 2024),
(3, 'Ruido Blanco', 280, 600, 2023),
(4, 'El Barrio de Lila', 190, 5000, 2024),
(4, 'Antes del Amanecer', 205, 2700, 2024),
(4, 'La Calle 8', 175, 900, 2023),
(5, 'Flor de Hierro', 195, 4100, 2024),
(5, 'Hora Dorada', 220, 1800, 2022);
SELECT nombre, genero
FROM autores
WHERE pais <> 'Chile'
   OR pais IS NULL
ORDER BY nombre;
SELECT titulo, paginas
FROM libros
WHERE paginas BETWEEN 190 AND 220
ORDER BY paginas ASC;
SELECT
    COUNT(*) AS total_libros,
    SUM(ejemplares_vendidos) AS total_ejemplares_vendidos,
    AVG(paginas) AS promedio_paginas,
    MIN(anio) AS anio_mas_antiguo,
    MAX(ejemplares_vendidos) AS mayor_venta_libro
FROM libros;
SELECT DISTINCT genero
FROM autores
ORDER BY genero ASC;
SELECT
    autores.nombre,
    COUNT(*) AS cantidad_libros_2024
FROM autores
JOIN libros
    ON autores.id_autor = libros.id_autor
WHERE libros.anio = 2024
GROUP BY autores.id_autor, autores.nombre
HAVING COUNT(*) > 1
ORDER BY autores.nombre ASC;
SELECT
    titulo,
    ejemplares_vendidos
FROM libros
WHERE anio = 2024
AND ejemplares_vendidos > 2000
ORDER BY ejemplares_vendidos DESC
LIMIT 3;
INSERT INTO libros
(id_autor, titulo, paginas, ejemplares_vendidos, anio)
VALUES
(3, 'Papel Mojado', 260, 50, 2024);
-- 1. SELECT previo: comprobar que el libro existe
SELECT *
FROM libros
WHERE titulo = 'Papel Mojado';
-- 2. DELETE: eliminar el libro
SET SQL_SAFE_UPDATES = 0;
DELETE FROM libros
WHERE titulo = 'Papel Mojado';
SET SQL_SAFE_UPDATES = 1;
-- 3. SELECT posterior: comprobar que ya no existe
SELECT *
FROM libros
WHERE titulo = 'Papel Mojado';
SELECT titulo, ejemplares_vendidos
FROM libros
WHERE titulo = 'Cielo de Enero';
-- Desactivar temporalmente el modo seguro
SET SQL_SAFE_UPDATES = 0;
-- Aumentar en 100 los ejemplares vendidos
UPDATE libros
SET ejemplares_vendidos = ejemplares_vendidos + 100
WHERE titulo = 'Cielo de Enero';
-- Comprobar el resultado
SELECT titulo, ejemplares_vendidos
FROM libros
WHERE titulo = 'Cielo de Enero';
-- Volver a activar el modo seguro
SET SQL_SAFE_UPDATES = 1;
-- 9.1. Insertar las colecciones
INSERT INTO colecciones (titulo, fecha_publicacion)
VALUES
('Colección General Austral', '2024-01-15'),
('Colección Poesía Moderna', '2023-06-20');
-- CONSULTA 9
SELECT
    id_libro,
    titulo,
    id_coleccion
FROM libros;
SELECT *
FROM colecciones;
-- Asociar libros a sus colecciones
UPDATE libros
SET id_coleccion = 1
WHERE id_libro IN (1, 2, 3, 4, 5, 8, 9, 10, 11, 12);

UPDATE libros
SET id_coleccion = 2
WHERE id_libro IN (6, 7);
-- CONSULTA 9: Relacionar libros con sus colecciones

SELECT
    l.titulo AS titulo_libro,
    c.titulo AS titulo_coleccion,
    c.fecha_publicacion
FROM libros l
INNER JOIN colecciones c
    ON l.id_coleccion = c.id_coleccion
ORDER BY l.titulo ASC;
-- CONSULTA 10: Pagos a los autores
SHOW TABLES;
DESCRIBE pagos;
-- 10.1 Insertar pagos de prueba
INSERT INTO pagos (id_autor, fecha_pago, monto)
VALUES
(1, '2024-03-15', 150000.00),
(1, '2024-06-20', 200000.00),
(2, '2024-04-10', 175000.00);
-- CONSULTA 10.1: Pagos realizados a los autores
SELECT
    a.nombre AS autor,
    p.fecha_pago,
    p.monto
FROM pagos p
INNER JOIN autores a
    ON p.id_autor = a.id_autor
ORDER BY a.nombre, p.fecha_pago;
-- CONSULTA 10.2: Total pagado a cada autor
SELECT
    a.nombre AS autor,
    COALESCE(SUM(p.monto), 0) AS total_pagado
FROM autores a
LEFT JOIN pagos p
    ON a.id_autor = p.id_autor
GROUP BY a.id_autor, a.nombre
ORDER BY a.nombre;
