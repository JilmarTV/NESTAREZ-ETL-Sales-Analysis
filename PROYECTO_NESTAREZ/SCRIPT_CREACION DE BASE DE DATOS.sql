-- CREAR BASE DE DATOS
-- =====================================================
CREATE DATABASE DW_NESTAREZ;
GO

USE DW_NESTAREZ;
GO

-- =====================================================
-- DIMENSION TIEMPO
-- =====================================================

CREATE TABLE DIM_TIEMPO
(
    ID_FECHA INT PRIMARY KEY,      -- Formato YYYYMMDD

    FECHA DATE NOT NULL,

    DIA INT NOT NULL,

    NOMBRE_DIA VARCHAR(20) NOT NULL,

    MES INT NOT NULL,

    NOMBRE_MES VARCHAR(20) NOT NULL,

    TRIMESTRE INT NOT NULL,

    ANIO INT NOT NULL
);
GO

-- =====================================================
-- DIMENSION PRODUCTO
-- La categoría se almacena como atributo descriptivo
-- para mantener Star Schema puro.
-- =====================================================

CREATE TABLE DIM_PRODUCTO
(
    ID_PRODUCTO INT IDENTITY(1,1) PRIMARY KEY,

    NOMBRE_PRODUCTO VARCHAR(150) NOT NULL,

    CATEGORIA VARCHAR(100) NOT NULL
);
GO

-- =====================================================
-- DIMENSION SUCURSAL
-- =====================================================

CREATE TABLE DIM_SUCURSAL
(
    ID_SUCURSAL INT IDENTITY(1,1) PRIMARY KEY,

    NOMBRE_SUCURSAL VARCHAR(100) NOT NULL,

    DIRECCION VARCHAR(250) NOT NULL,

    TELEFONO VARCHAR(20),

    HORA_APERTURA VARCHAR(10),

    HORA_CIERRE VARCHAR(10)
);
GO

-- =====================================================
-- TABLA DE HECHOS
-- =====================================================

CREATE TABLE FACT_VENTAS
(
    ID_VENTA BIGINT IDENTITY(1,1) PRIMARY KEY,

    ID_FECHA INT NOT NULL,

    ID_PRODUCTO INT NOT NULL,

    ID_SUCURSAL INT NOT NULL,

    CANTIDAD_VENDIDA INT NOT NULL
        CHECK (CANTIDAD_VENDIDA > 0),

    PRECIO_UNITARIO DECIMAL(10,2) NOT NULL
        CHECK (PRECIO_UNITARIO > 0),

    TOTAL_VENTA DECIMAL(12,2) NOT NULL
        CHECK (TOTAL_VENTA >= 0),

    CONSTRAINT FK_FACT_TIEMPO
        FOREIGN KEY(ID_FECHA)
        REFERENCES DIM_TIEMPO(ID_FECHA),

    CONSTRAINT FK_FACT_PRODUCTO
        FOREIGN KEY(ID_PRODUCTO)
        REFERENCES DIM_PRODUCTO(ID_PRODUCTO),

    CONSTRAINT FK_FACT_SUCURSAL
        FOREIGN KEY(ID_SUCURSAL)
        REFERENCES DIM_SUCURSAL(ID_SUCURSAL)
);
GO

/*=========================================================
  ÍNDICES PARA POWER BI Y CONSULTAS OLAP
=========================================================*/

CREATE NONCLUSTERED INDEX IX_FACT_VENTAS_FECHA
ON FACT_VENTAS(ID_FECHA);
GO

CREATE NONCLUSTERED INDEX IX_FACT_VENTAS_PRODUCTO
ON FACT_VENTAS(ID_PRODUCTO);
GO

CREATE NONCLUSTERED INDEX IX_FACT_VENTAS_SUCURSAL
ON FACT_VENTAS(ID_SUCURSAL);
GO

CREATE NONCLUSTERED INDEX IX_DIM_TIEMPO_ANIO_MES
ON DIM_TIEMPO(ANIO, MES);
GO

CREATE NONCLUSTERED INDEX IX_DIM_PRODUCTO_CATEGORIA
ON DIM_PRODUCTO(CATEGORIA);
GO

select * from FACT_VENTAS
