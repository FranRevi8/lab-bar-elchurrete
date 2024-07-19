drop database if exists bar_el_churrete;

create database bar_el_churrete;

use bar_el_churrete;

CREATE TABLE Establecimientos (
    id_establecimiento INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    direccion VARCHAR(255),
    telefono VARCHAR(20)
);

CREATE TABLE Empleados (
    id_empleado INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    telefono VARCHAR(20),
    email VARCHAR(100),
    id_establecimiento INT,
    FOREIGN KEY (id_establecimiento) REFERENCES Establecimientos(id_establecimiento)
);

CREATE TABLE Turnos (
    id_turno INT PRIMARY KEY AUTO_INCREMENT,
    descripcion VARCHAR(50)
);

CREATE TABLE Empleados_Turnos (
    id_empleado_turno INT PRIMARY KEY AUTO_INCREMENT,
    id_empleado INT,
    id_turno INT,
    fecha DATE,
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado),
    FOREIGN KEY (id_turno) REFERENCES Turnos(id_turno)
);

CREATE TABLE Productos (
    id_producto INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    descripcion TEXT,
    precio DECIMAL(10, 2)
);

CREATE TABLE Desayunos (
    id_desayuno INT PRIMARY KEY AUTO_INCREMENT,
    id_producto INT,
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
);

CREATE TABLE Comidas_Cenas (
    id_comida_cena INT PRIMARY KEY AUTO_INCREMENT,
    id_producto INT,
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
);

CREATE TABLE Churros (
    id_churro INT PRIMARY KEY AUTO_INCREMENT,
    id_producto INT,
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
);

CREATE TABLE Pedidos (
    id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    id_establecimiento INT,
    id_empleado INT,
    fecha DATE,
    total DECIMAL(10, 2),
    FOREIGN KEY (id_establecimiento) REFERENCES Establecimientos(id_establecimiento),
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado)
);

CREATE TABLE Detalle_Pedidos (
    id_detalle_pedido INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT,
    id_producto INT,
    cantidad INT,
    subtotal DECIMAL(10, 2),
    FOREIGN KEY (id_pedido) REFERENCES Pedidos(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
);

CREATE TABLE Inventario (
    id_ingrediente INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    cantidad_disponible INT
);

CREATE TABLE Movimientos_Inventario (
    id_movimiento INT PRIMARY KEY AUTO_INCREMENT,
    id_ingrediente INT,
    tipo_movimiento ENUM('entrada', 'salida'),
    cantidad INT,
    fecha DATE,
    id_producto INT NULL,
    FOREIGN KEY (id_ingrediente) REFERENCES Inventario(id_ingrediente),
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
);

CREATE TABLE Clientes (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    telefono VARCHAR(20),
    email VARCHAR(100)
);

CREATE TABLE Promociones (
    id_promocion INT PRIMARY KEY AUTO_INCREMENT,
    descripcion TEXT,
    fecha_inicio DATE,
    fecha_fin DATE,
    descuento DECIMAL(5, 2)
);

CREATE TABLE Promociones_Productos (
    id_promocion_producto INT PRIMARY KEY AUTO_INCREMENT,
    id_promocion INT,
    id_producto INT,
    FOREIGN KEY (id_promocion) REFERENCES Promociones(id_promocion),
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
);

CREATE TABLE Opiniones (
    id_opinion INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT,
    id_pedido INT,
    valoracion INT CHECK (valoracion BETWEEN 1 AND 5),
    comentario TEXT,
    fecha DATE,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (id_pedido) REFERENCES Pedidos(id_pedido)
);

CREATE TABLE Reservas (
    id_reserva INT PRIMARY KEY AUTO_INCREMENT,
    numero_reserva INT UNIQUE,
    id_cliente INT,
    id_establecimiento INT,
    fecha_reserva DATE,
    hora_reserva TIME,
    numero_personas INT,
    estado ENUM('activa', 'cancelada', 'realizada'),
    fecha_creacion DATETIME DEFAULT NOW(),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (id_establecimiento) REFERENCES Establecimientos(id_establecimiento)
);

CREATE TABLE Proveedores (
    id_proveedor INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    contacto VARCHAR(100)
);

CREATE TABLE Proveedores_Ingredientes (
    id_proveedor_ingrediente INT PRIMARY KEY AUTO_INCREMENT,
    id_proveedor INT,
    id_ingrediente INT,
    FOREIGN KEY (id_proveedor) REFERENCES Proveedores(id_proveedor),
    FOREIGN KEY (id_ingrediente) REFERENCES Inventario(id_ingrediente)
);

DELIMITER $$

CREATE FUNCTION generar_numero_reserva()
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE num_reserva INT;
    DECLARE num_reserva_existe INT;

    REPEAT
        SET num_reserva = FLOOR(1 + (RAND() * 100000));
        SELECT COUNT(*) INTO num_reserva_existe FROM Reservas WHERE numero_reserva = num_reserva;
    UNTIL num_reserva_existe = 0
    END REPEAT;

    RETURN num_reserva;
END $$

CREATE TRIGGER before_insert_reservas
BEFORE INSERT ON Reservas
FOR EACH ROW
BEGIN
    SET NEW.numero_reserva = generar_numero_reserva();
  	SET NEW.fecha_creacion = NOW();
END $$

DELIMITER ;

-- Índices para mejorar la eficiencia de las consultas:
-- Productos
CREATE INDEX idx_productos_nombre ON Productos(nombre);

-- Pedidos
CREATE INDEX idx_pedidos_id_establecimiento ON Pedidos(id_establecimiento);
CREATE INDEX idx_pedidos_id_empleado ON Pedidos(id_empleado);
CREATE INDEX idx_pedidos_fecha ON Pedidos(fecha);

-- Clientes
CREATE INDEX idx_clientes_nombre ON Clientes(nombre);
CREATE INDEX idx_clientes_apellido ON Clientes(apellido);
CREATE INDEX idx_clientes_email ON Clientes(email);

-- Promociones_Productos
CREATE INDEX idx_promociones_productos_id_promocion ON Promociones_Productos(id_promocion);
CREATE INDEX idx_promociones_productos_id_producto ON Promociones_Productos(id_producto);

-- Reservas
CREATE INDEX idx_reservas_id_cliente ON Reservas(id_cliente);
CREATE INDEX idx_reservas_id_establecimiento ON Reservas(id_establecimiento);
CREATE INDEX idx_reservas_fecha_reserva ON Reservas(fecha_reserva);
CREATE INDEX idx_reservas_numero_reserva ON Reservas(numero_reserva);


INSERT INTO Establecimientos (nombre, direccion, telefono) VALUES
('Bar El Churrete - Centro', 'Calle Principal 123', '123-456-7890'),
('Bar El Churrete - Norte', 'Avenida Norte 456', '123-456-7891');

INSERT INTO Empleados (nombre, apellido, telefono, email, id_establecimiento) VALUES
('Juan', 'Pérez', '123-456-7892', 'juan.perez@bar.com', 1),
('María', 'García', '123-456-7893', 'maria.garcia@bar.com', 1),
('Pedro', 'López', '123-456-7894', 'pedro.lopez@bar.com', 2),
('Ana', 'Martínez', '123-456-7895', 'ana.martinez@bar.com', 2);

INSERT INTO Turnos (descripcion) VALUES
('Mañana'),
('Tarde'),
('Noche'),
('Refuerzo');

INSERT INTO Empleados_Turnos (id_empleado, id_turno, fecha) VALUES
(1, 1, '2024-07-01'),
(2, 2, '2024-07-01'),
(3, 3, '2024-07-01'),
(4, 4, '2024-07-01');

INSERT INTO Productos (nombre, descripcion, precio) VALUES
('Café', 'Café negro', 1.50),
('Churro Clásico', 'Churro tradicional', 0.80),
('Tostada', 'Tostada con mantequilla', 2.00),
('Tortilla', 'Tortilla española', 3.50),
('Churro de Chocolate', 'Churro relleno de chocolate', 1.20),
('Ensalada', 'Ensalada mixta', 4.50),
('Sándwich', 'Sándwich de jamón y queso', 3.00);

INSERT INTO Desayunos (id_producto) VALUES
(1),
(3);

INSERT INTO Comidas_Cenas (id_producto) VALUES
(4),
(6),
(7);

INSERT INTO Churros (id_producto) VALUES
(2),
(5);

INSERT INTO Clientes (nombre, apellido, telefono, email) VALUES
('Carlos', 'Sánchez', '123-456-7896', 'carlos.sanchez@cliente.com'),
('Lucía', 'Ramírez', '123-456-7897', 'lucia.ramirez@cliente.com');

INSERT INTO Pedidos (id_establecimiento, id_empleado, fecha, total) VALUES
(1, 1, '2024-07-01', 10.00),
(2, 3, '2024-07-02', 15.00);

INSERT INTO Detalle_Pedidos (id_pedido, id_producto, cantidad, subtotal) VALUES
(1, 1, 2, 3.00),
(1, 2, 5, 4.00),
(2, 4, 1, 3.50),
(2, 6, 2, 9.00);

INSERT INTO Inventario (nombre, cantidad_disponible) VALUES
('Harina', 100),
('Aceite', 50),
('Azúcar', 30),
('Café', 20);

INSERT INTO Movimientos_Inventario (id_ingrediente, tipo_movimiento, cantidad, fecha, id_producto) VALUES
(1, 'entrada', 20, '2024-07-01', NULL),
(2, 'salida', 10, '2024-07-01', 2),
(3, 'entrada', 5, '2024-07-02', NULL),
(4, 'salida', 2, '2024-07-02', 1);

INSERT INTO Promociones (descripcion, fecha_inicio, fecha_fin, descuento) VALUES
('Descuento del 10% en churros', '2024-07-01', '2024-07-07', 10.00);

INSERT INTO Promociones_Productos (id_promocion, id_producto) VALUES
(1, 2),
(1, 5);

INSERT INTO Opiniones (id_cliente, id_pedido, valoracion, comentario, fecha) VALUES
(1, 1, 5, 'Excelente servicio', '2024-07-01'),
(2, 2, 4, 'Muy buena comida', '2024-07-02');


INSERT INTO Reservas (numero_reserva, id_cliente, id_establecimiento, fecha_reserva, hora_reserva, numero_personas, estado, fecha_creacion) VALUES
(12345, 1, 1, '2024-07-03', '12:00:00', 4, 'activa', NOW()),
(12346, 2, 2, '2024-07-04', '18:00:00', 2, 'activa', NOW());

INSERT INTO Proveedores (nombre, contacto) VALUES
('Proveedor A', 'contactoA@proveedor.com'),
('Proveedor B', 'contactoB@proveedor.com');

INSERT INTO Proveedores_Ingredientes (id_proveedor, id_ingrediente) VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 4);

-- Ya tenemos todo funcionando y con datos falsos: toca hacer consultas:

-- Ventas diarias:

SELECT 
    DATE(fecha) AS fecha,
    SUM(total) AS total_ventas_diarias
FROM 
    Pedidos
GROUP BY 
    DATE(fecha)
ORDER BY 
    fecha;
    
-- Ventas semanales:
   
SELECT 
    YEAR(fecha) AS año,
    WEEK(fecha) AS semana,
    SUM(total) AS total_ventas_semanales
FROM 
    Pedidos
GROUP BY 
    año, semana
ORDER BY 
    año, semana;
    
-- Ventas mensuales:
   
SELECT 
    YEAR(fecha) AS año,
    MONTH(fecha) AS mes,
    SUM(total) AS total_ventas_mensuales
FROM 
    Pedidos
GROUP BY 
    año, mes
ORDER BY 
    año, mes;
    
-- Platos más vendidos:
   
SELECT 
    P.nombre AS producto,
    SUM(DP.cantidad) AS cantidad_vendida,
    SUM(DP.subtotal) AS total_ingresos
FROM 
    Detalle_Pedidos DP
JOIN 
    Productos P ON DP.id_producto = P.id_producto
GROUP BY 
    P.nombre
ORDER BY 
    cantidad_vendida DESC
LIMIT 5;

-- Búsqueda de ingredientes con poco stock:

SELECT 
    I.nombre AS ingrediente,
    I.cantidad_disponible AS stock_actual
FROM 
    Inventario I
WHERE 
    I.cantidad_disponible < 50
ORDER BY 
    I.cantidad_disponible ASC;
    
   
   
   
-- Ahora Vamos a crear procedimientos para hacer cambios en el menú:
   
-- Empezamos con la tabla que guardará el historial.
   
CREATE TABLE Historial_Cambios_Menu (
    id_historial INT PRIMARY KEY AUTO_INCREMENT,
    id_producto INT,
    accion ENUM('añadir', 'modificar', 'eliminar'),
    fecha DATETIME DEFAULT NOW(),
    descripcion TEXT,
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
);
   
DELIMITER //

CREATE PROCEDURE AñadirPlato(
    IN p_nombre VARCHAR(100),
    IN p_descripcion TEXT,
    IN p_precio DECIMAL(10, 2),
    IN p_categoria ENUM('desayuno', 'comida_cena', 'churro')
)
BEGIN
    DECLARE v_id_producto INT;

    -- Insertar el nuevo producto en la tabla Productos
    INSERT INTO Productos (nombre, descripcion, precio) 
    VALUES (p_nombre, p_descripcion, p_precio);

    -- Obtener el id del producto recién insertado
    SET v_id_producto = LAST_INSERT_ID();

    -- Insertar en la tabla correspondiente de la categoría
    IF p_categoria = 'desayuno' THEN
        INSERT INTO Desayunos (id_producto) VALUES (v_id_producto);
    ELSEIF p_categoria = 'comida_cena' THEN
        INSERT INTO Comidas_Cenas (id_producto) VALUES (v_id_producto);
    ELSEIF p_categoria = 'churro' THEN
        INSERT INTO Churros (id_producto) VALUES (v_id_producto);
    END IF;

    -- Registrar en el historial de cambios
    INSERT INTO Historial_Cambios_Menu (id_producto, accion, descripcion)
    VALUES (v_id_producto, 'añadir', CONCAT('Añadido el plato: ', p_nombre));
END //

DELIMITER ;
   
DELIMITER //

CREATE PROCEDURE ModificarPlato(
    IN p_id_producto INT,
    IN p_nombre VARCHAR(100),
    IN p_descripcion TEXT,
    IN p_precio DECIMAL(10, 2)
)
BEGIN
    -- Actualizar los datos del producto
    UPDATE Productos
    SET nombre = p_nombre, descripcion = p_descripcion, precio = p_precio
    WHERE id_producto = p_id_producto;

    -- Registrar en el historial de cambios
    INSERT INTO Historial_Cambios_Menu (id_producto, accion, descripcion)
    VALUES (p_id_producto, 'modificar', CONCAT('Modificado el plato: ', p_nombre));
END //

DELIMITER ;  
   
CALL AñadirPlato('Croissant', 'Croissant con mantequilla', 1.50, 'desayuno');
   
CALL ModificarPlato(1, 'Café con Leche', 'Café con leche y azúcar', 2.00);   
   
   
   
   
   
   
   
   
   
   
   
   