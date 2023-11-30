USE master;
GO

IF (NOT EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DIAMONDSTORESYSTEM'))
BEGIN
    CREATE DATABASE DIAMONDSTORESYSTEM;
END;
GO

USE DIAMONDSTORESYSTEM;
GO

CREATE TABLE categorias (
    id_cate INT IDENTITY(1, 1),
    nombre VARCHAR(100) NOT NULL,
    CONSTRAINT PK_categorias PRIMARY KEY (id_cate)
);

CREATE TABLE productos (
    id_prod INT IDENTITY(1, 1),
    nombre VARCHAR(100) NOT NULL,
    id_cate INT NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL,
    imagen VARBINARY(MAX), -- Assuming you want to store images as VARBINARY
    CONSTRAINT PK_productos PRIMARY KEY (id_prod),
    CONSTRAINT FK_productos_categorias FOREIGN KEY (id_cate) REFERENCES categorias (id_cate) 
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);
GO
ALTER TABLE productos
ADD CONSTRAINT UQ_ProductName UNIQUE (nombre);


CREATE TABLE usuario (
    userid INT IDENTITY(1, 1),
    userapellido VARCHAR(100) NOT NULL,
    usernombre VARCHAR(100) NOT NULL,
    usersexo VARCHAR(50) NOT NULL,
    userTurno VARCHAR(50) NOT NULL,
    userUsuario VARCHAR(20) NOT NULL,
    userClave VARCHAR(100) NOT NULL,
    CONSTRAINT PK_usuario PRIMARY KEY (userid)
);
GO


CREATE TABLE pedidos (
    idpedido INT IDENTITY(1, 1),
    nombreCliente VARCHAR(100) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    cantidad INT NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
	total DECIMAL(10, 2) NOT NULL,
	metodoPago VARCHAR(100)NOT NULL,
    
    CONSTRAINT PK_pedidos PRIMARY KEY (idpedido),
    CONSTRAINT FK_pedidos_productos FOREIGN KEY (nombre) REFERENCES productos (nombre) 
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);


CREATE PROCEDURE pa_selectCategoria
AS
SELECT id_cate, nombre
FROM categorias;
GO

-- EXEC pa_selectCategoria; -- You can execute this later

CREATE PROCEDURE pr_InsertarCategoria
(
    @nombre VARCHAR(100)
)
AS
INSERT INTO categorias (nombre)
VALUES (@nombre);
SELECT @@IDENTITY AS id_cate;
RETURN;
GO

-- EXEC pr_InsertarCategoria 'Maquillaje';
-- EXEC pr_InsertarCategoria 'Skin Care';


CREATE PROCEDURE pa_selectProducto
     @nombre VARCHAR(100) -- Ajusta el tamaño según tus necesidades
AS
BEGIN
    SELECT  nombre, id_cate, precio, stock, imagen
    FROM productos
    WHERE nombre LIKE '%%%' + @Nombre + '%%%';
END;

-- EXEC pa_selectProducto; -- You can execute this later

CREATE PROCEDURE pr_InsertarProducto
(
    @nombre VARCHAR(100),
    @id_cate INT,
    @precio DECIMAL(10, 2),
    @stock INT,
    @imagen VARBINARY(MAX)
)
AS
INSERT INTO productos (nombre, id_cate, precio, stock, imagen)
VALUES (@nombre, @id_cate, @precio, @stock, @imagen);
SELECT @@IDENTITY AS id_prod;
RETURN;
GO



-- Procedimiento almacenado para actualizar el stock de un producto
CREATE PROCEDURE pr_ActualizarStock
    @nombreProducto VARCHAR(100),
    @nuevoStock INT
AS
BEGIN
    UPDATE productos
    SET stock = stock + @nuevoStock
    WHERE nombre = @nombreProducto;
END;




-- Crear el procedimiento almacenado pa_eliminarProducto
CREATE PROCEDURE pa_eliminarProducto
    @nombreProducto VARCHAR(100)
AS
BEGIN
    -- Realizar la eliminación del producto basado en el nombre
    DELETE FROM productos
    WHERE nombre = @nombreProducto;
END;


CREATE PROCEDURE pr_InsertarPedido
(
    @nombreCliente VARCHAR(100),
    @nombre VARCHAR(100),
    @cantidad INT,
    @precio DECIMAL(10, 2),
	@total DECIMAL(10, 2),
	@metodoPago VARCHAR(100)
)
AS
INSERT INTO pedidos (nombreCliente, nombre, cantidad, precio, total, metodoPago)
VALUES (@nombreCliente, @nombre, @cantidad, @precio, @total, @metodoPago);
SELECT @@IDENTITY AS idpedido;
RETURN;
GO

select * from pedidos

CREATE PROCEDURE pa_selectPedido
AS
SELECT nombreCliente, nombre, cantidad, precio, total, metodoPago
FROM pedidos;
GO

CREATE PROCEDURE pa_eliminarPedido
    @nombreCliente VARCHAR(100)
AS
BEGIN
    -- Realizar la eliminación del producto basado en el nombre
    DELETE FROM pedidos
    WHERE nombreCliente = @nombreCliente;
END
EXEC pa_eliminarPedido 'Lucia'

select * from pedidos
CREATE PROCEDURE pr_ActualizarStockSegunCantidad
    @nombreProducto VARCHAR(100),
    @cantidadVendida INT
AS
BEGIN
    UPDATE productos
    SET stock = stock - @cantidadVendida
    WHERE nombre = @nombreProducto;
END;



--EXEC pa_eliminarPedido @nombreCliente = 'Ana Lucia';


CREATE PROCEDURE pr_LlamarUsuario
    @usuario VARCHAR(20),
    @clave VARCHAR(100)
AS
BEGIN
    SELECT userid, userapellido, usernombre, usersexo, userTurno, userUsuario
    FROM usuario
    WHERE userUsuario = @usuario AND userClave = @clave;
END;

   
CREATE PROCEDURE pr_InsertarUsuario
(
    @userapellido VARCHAR(100),
    @usernombre VARCHAR(100),
    @usersexo VARCHAR(100),
    @userTurno VARCHAR(100),
    @userUsuario VARCHAR(100),
    @userClave VARCHAR(100)
)
AS
INSERT INTO usuario(userapellido, usernombre, usersexo, userTurno, userUsuario, userClave)
VALUES (@userapellido, @usernombre, @usersexo, @userTurno, @userUsuario, @userClave);
SELECT @@IDENTITY AS userid;
RETURN;
GO

EXEC pr_InsertarUsuario 'Lopez', 'Valeria', 'Femenino', 'Mañana', 'val23', '12345';
EXEC pr_InsertarUsuario 'Lavado', 'Sherly', 'Femenino', 'Tarde', 'sher32', '2521';















-- Para insertar datos en la tabla de categorías
EXEC pr_InsertarCategoria 'Maquillaje';
EXEC pr_InsertarCategoria 'Skin Care';

-- Para insertar datos en la tabla de productos
EXEC pr_InsertarProducto 'TRIO RUBOR BELLASPA', 1, 10.00, 35, NULL;
EXEC pr_InsertarProducto 'JABON EXFOLIANTE MISHKI', 2, 45.00, 45, NULL;
