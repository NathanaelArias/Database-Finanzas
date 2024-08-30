-- ================================================
-- Hecho por: Nathanael Arias Salas
-- Fecha: 29-8-2024
-- Correo: salasnathanael@gmail.com 
-- Proyecto: Base de datos Finanzas Personales
-- ================================================

CREATE DATABASE Finanzas
go

use Finanzas


CREATE TABLE Bancos(
	Idbanco int IDENTITY(1,1) NOT NULL Primary Key,
	numerocuenta varchar(12)  NOT NULL,
	Nombrebanco  varchar(50)  NOT NULL)
go

CREATE TABLE Ccuentas(
	Idcuenta [varchar](8) NOT NULL Primary Key,
	nivel1 nchar(1) NOT NULL,
	nivel2 nchar(1) NOT NULL,
	nivel3 nchar(1) NOT NULL,
	nivel4 nchar(2) NOT NULL,
	nivel5 nchar(3) NOT NULL,
	nombrecuenta varchar(50) NOT NULL)
go

CREATE TABLE Clientes(
	Idcliente   int IDENTITY(1,1) NOT NULL Primary key,
	nombre      varchar(25)   NOT NULL,
	apellidos   varchar(25)   NOT NULL,
	cedula      varchar(15)   NULL,
	razonsocial varchar(35)   NULL,
	contacto    varchar(35)   NULL,
	direccion   varchar(150)  NULL,
	email       varchar(100)  NULL,
	telcasa     varchar(8)    NULL,
	teloficina  varchar(8)    NULL,
	telmovil    varchar(8)    NULL,
	saldo       money         NULL)
go

CREATE TABLE Unidades_Medidas(
	Idunidadmedida int IDENTITY(1,1) NOT NULL Primary Key,
	descripcion    varchar(10) NOT NULL)
go

CREATE TABLE Codigos(
	IdCodigo       int IDENTITY(1,1) NOT NULL Primary Key,
	descripcion    varchar(50) NOT NULL,
	Idunidadmedida int         NOT NULL,
	precio         money       NOT NULL,
CONSTRAINT FK_Idunidadmedida   foreign key (Idunidadmedida)   references Unidades_Medidas(Idunidadmedida))
go



CREATE TABLE Parametros(
	IdParametro     int IDENTITY(1,1) NOT NULL Primary Key,
	impuestoventas  decimal(12, 2) NOT NULL)
go


CREATE TABLE Proveedores(
	idproveedor  int IDENTITY(1,1) NOT NULL Primary Key,
	nombre       varchar(25)   NOT NULL,
	apellidos    varchar(25)   NOT NULL,
	cedula       varchar(15)   NULL,
	razonsocial  varchar(35)   NULL,
	contacto     varchar(35)   NULL,
	direccion    varchar(150)  NULL,
	email        varchar(100)  NULL,
	telcasa      varchar(8)    NULL,
	teloficina   varchar(8)    NULL,
	telmovil     varchar(8)    NULL,
	saldo        money         NULL)
go



CREATE TABLE Usuarios(
	idusuario  int IDENTITY(1,1) NOT NULL Primary Key,
	usuario    varchar(12)  NOT NULL,
	clave      varchar(12)  NOT NULL,
	nombre     varchar(25)  NOT NULL,
	apellidos  varchar(25)  NOT NULL,
	cedula     varchar(15)  NULL,
	direccion  varchar(150) NULL,
	email      varchar(100) NULL,
	telcasa    varchar(8)   NULL,
	teloficina varchar(8)   NULL,
	telmovil   varchar(8)   NULL)
go



CREATE TABLE Transacciones(
	IdTransaccion    int IDENTITY(1,1) NOT NULL Primary Key,
	Idusuario        int            NOT NULL,
	IdCliente        int            NULL,
	IdProveedor      int            NULL,
	Idcuenta         varchar(8)     NOT NULL,
        IdBanco          int        NOT NULL,
	habilitadetalle  nchar(1)       NOT NULL,
	Descripcion      varchar(50)    NULL,
	fecha            date           NULL,
	subtotal         money          NOT NULL,
	descuento        money          NOT NULL,
	impuestoventas   decimal(12, 2) NOT NULL,
	total            money          NOT NULL,
CONSTRAINT FK_IdUsuario   foreign key (IdUsuario)   references usuarios(idusuario),
constraint FK_IdCliente   foreign key (IdCliente)   references clientes(IdCliente),
constraint FK_IdProveedor foreign key (IdProveedor) references Proveedores(IdProveedor),
constraint FK_IdCuenta    foreign key (Idcuenta)    references ccuentas(Idcuenta),
CONSTRAINT FK_Idbanco     Foreign key (idbanco)     references Bancos (Idbanco))
go



CREATE TABLE Transacciones_Detalles(
	IdTransaccion   int   NULL,
	IdCodigo        int   NULL,
	Idunidadmedida  int   NULL,
	cantidad        int   NULL,
	precio          money NULL, 
constraint FK_IdTransaccion   foreign key (IdTransaccion)  references transacciones(IdTransaccion),
constraint FK_IdCodigo        foreign key (IdCodigo)       references codigos(IdCodigo))
go
-- Crear los procedimientos almacenados
-- ----PROCEDIMIENTOS ALMACENADOS PARA LA TABLA: USUARIOS------------------------------------------------>


Create Procedure proc_InsertarUsuario
@Usuario    varchar(25),
@clave      varchar(25),
@nombre     varchar(25),
@apellidos  varchar(35),
@cedula     varchar(15),
@direccion  varchar(160),
@email      varchar(50),
@telcasa    varchar(8),
@teloficina varchar(8),
@telmovil   varchar(8)
As
Insert Into Usuarios
	(usuario, clave, nombre, apellidos, cedula, email, TelCasa, TelOficina, Telmovil)
	Values(@Usuario, @clave, @nombre, @apellidos, @cedula, @email, @telcasa, @telOficina, @telmovil)
go
-- ---------------------------------------------------------------------------------------------------->


-- ================================================
Create Procedure proc_ModificarUsuario
@IdUsuario  Int,
@Usuario    varchar(25),
@clave      varchar(25),
@nombre     varchar(25),
@apellidos  varchar(35),
@cedula     varchar(15),
@direccion  varchar(160),
@email      varchar(50),
@telcasa    varchar(8),
@teloficina varchar(8),
@telmovil   varchar(8)
As
Update Usuarios
Set usuario=@usuario, clave=@clave, nombre=@nombre, apellidos=@apellidos, cedula=@cedula, direccion=@direccion, 
	email=@email, telcasa=@telcasa, teloficina=@teloficina, telmovil=@telmovil 
Where IdUsuario=@IdUsuario
go



-- ================================================
Create Procedure proc_EliminarUsuario
@IdUsuario Int
As
Delete From Usuarios Where IdUsuario=@IdUsuario
go
-- ---------------------------------------------------------------------------------------------------->
-- ================================================

Create Procedure proc_ConsultarUsuario
As
SELECT IdUsuario, usuario, clave, nombre, apellidos, cedula, direccion, email, telcasa, teloficina, telmovil
FROM     Usuarios
go
-- ----PROCEDIMIENTOS ALMACENADOS PARA LA TABLA: PROVEEDORES------------------------------------------------>


Create Procedure proc_InsertarProveedor
@nombre      varchar(25),
@apellidos   varchar(25),
@cedula      varchar(15),
@razonsocial varchar(35),
@contacto    varchar(35),
@direccion   varchar(150),
@email       varchar(100),
@telcasa     varchar(8),
@teloficina  varchar(8),
@telmovil    varchar(8),
@saldo       money
As
Insert Into Proveedores
	(nombre, apellidos, cedula, razonsocial, contacto, direccion, email, TelCasa, TelOficina, Telmovil, saldo)
	Values(@nombre, @apellidos, @cedula, @razonsocial, @contacto, @direccion, @email, @telcasa, @telOficina, @telmovil, @saldo)
go


Create Procedure proc_ModificarProveedor
@IdProveedor  Int,
@nombre       varchar(25),
@apellidos    varchar(35),
@cedula       varchar(15),
@razonsocial  varchar(35),
@contacto     varchar(35),
@direccion    varchar(150),
@email        varchar(100),
@telcasa      varchar(8),
@teloficina   varchar(8),
@telmovil     varchar(8),
@saldo        money
As
Update Proveedores
Set nombre=@nombre, apellidos=@apellidos, cedula=@cedula, razonsocial=@razonsocial, contacto=@contacto, direccion=@direccion, 
	email=@email, telcasa=@telcasa, teloficina=@teloficina, telmovil=@telmovil, saldo=@saldo 
Where IdProveedor=@Idproveedor
go


Create Procedure proc_EliminarProveedor
@IdProveedor Int
As
Delete From Proveedores Where IdProveedor=@IdProveedor
go


-- ================================================
Create Procedure proc_ConsultarProveedor
As
SELECT IdProveedor, nombre, apellidos, cedula, razonsocial, contacto, direccion, email, telcasa, teloficina, telmovil, saldo
FROM     Proveedores
go
-- ----PROCEDIMIENTOS ALMACENADOS PARA LA TABLA: BANCOS------------------------------------------------>


Create Procedure proc_InsertarBanco
@numerocuenta  varchar(12),
@Nombrebanco   varchar(50)
As
Insert Into Bancos
	(numerocuenta, nombrebanco) Values(@numerocuenta , @Nombrebanco)
go


Create Procedure proc_ModificarBanco
@Idbanco      Int,
@numerocuenta varchar(12),
@Nombrebanco  varchar(50)
As
Update Bancos
Set numerocuenta=numerocuenta, Nombrebanco=@Nombrebanco Where Idbanco=@Idbanco
go


Create Procedure proc_EliminarBanco
@Idbanco Int
As
Delete From Bancos Where Idbanco=@Idbanco
go


Create Procedure proc_ConsultarBanco
As
SELECT Idbanco, numerocuenta, Nombrebanco
FROM     Bancos
go
-- ----PROCEDIMIENTOS ALMACENADOS PARA LA TABLA: CCUENTAS------------------------------------------------>

Create Procedure proc_InsertarCcuenta
@IdCuenta     varchar(8),
@nivel1       nchar(1),
@nivel2       nchar(1),
@nivel3       nchar(1),
@nivel4       nchar(2),
@nivel5       nchar(3),
@nombrecuenta varchar(50)
As
Insert Into Ccuentas
	(Idcuenta, nivel1, nivel2, nivel3, nivel4, nivel5, nombrecuenta)
	Values (@IdCuenta, @nivel1, @nivel2, @nivel3, @nivel4, @nivel5, @nombrecuenta)
go


Create Procedure proc_ModificarCcuenta
@Idcuenta      Int,
@nivel1        nchar(1),
@nivel2        nchar(1),
@nivel3        nchar(1),
@nivel4        nchar(2),
@nivel5        nchar(3),
@nombrecuenta  varchar(50)
As
Update Ccuentas
Set nivel1=@nivel1, nivel2=@nivel2, nivel3=@nivel3, 
	nivel4=@nivel4, nivel5=@nivel5,nombrecuenta=@nombrecuenta 
Where Idcuenta=@Idcuenta
go


Create Procedure proc_EliminarCcuenta
@Idcuenta Int
As
Delete From Ccuentas Where Idcuenta=@Idcuenta
go


Create Procedure proc_ConsultarCcuenta
As
SELECT Idcuenta, nivel1, nivel2, nivel3, nivel4, nivel5, nombrecuenta
FROM     Ccuentas
go
-- ----PROCEDIMIENTOS ALMACENADOS PARA LA TABLA: CLIENTES------------------------------------------------>



Create Procedure proc_InsertarCliente
@nombre       varchar(25),
@apellidos    varchar(25),
@cedula       varchar(15),
@razonsocial  varchar(35),
@contacto     varchar(35),
@direccion    varchar(150),
@email        varchar(100),
@telcasa      varchar(8),
@teloficina   varchar(8),
@telmovil     varchar(8),
@saldo        money
As
Insert Into Clientes
	(nombre, apellidos, cedula, razonsocial, contacto, direccion, email, telcasa, teloficina, telmovil, saldo)
	Values (@nombre, @apellidos, @cedula, @razonsocial, @contacto, @direccion, @email, @telcasa, @teloficina, @telmovil, @saldo)
go


Create Procedure proc_ModificarCliente
@Idcliente    Int,
@nombre       varchar(25),
@apellidos    varchar(25),
@cedula       varchar(15),
@razonsocial  varchar(35),
@contacto     varchar(35),
@direccion    varchar(150),
@email        varchar(100),
@telcasa      varchar(8),
@teloficina   varchar(8),
@telmovil     varchar(8),
@saldo        money
As
Update Clientes
Set nombre=@nombre, apellidos=@apellidos, cedula=@cedula,razonsocial=razonsocial, contacto=@contacto,direccion=@direccion,
email=@email, telcasa=@telcasa, teloficina=@teloficina, telmovil=@telmovil, saldo=@saldo 
Where Idcliente=@Idcliente
go


Create Procedure proc_EliminarCliente
@IdCliente Int
As
Delete From Clientes Where Idcliente=@Idcliente
go


Create Procedure proc_ConsultarCliente
As
SELECT Idcliente, nombre, apellidos, cedula, razonsocial, contacto, direccion, email, telcasa, teloficina, telmovil, saldo
FROM     Clientes
go
-- ----PROCEDIMIENTOS ALMACENADOS PARA LA TABLA: CODIGOS------------------------------------------------>



Create Procedure proc_InsertarCodigo
@descripcion varchar(50),
@Idunidadmedida int,
@precio money
As
Insert Into codigos
	(descripcion, idunidadmedida, precio)
	Values (@descripcion, @Idunidadmedida, @precio)
go


@IdCodigo        Int,
@descripcion     varchar(50),
@IdUnidadmedida  int,
@precio          money
As
Update Codigos
Set descripcion=@descripcion, IdUnidadMedida=@IdunidadMedida, precio=@precio 
Where IdCodigo=@IdCodigo
go


Create Procedure proc_EliminarCodigo
@IdCodigo Int
As
Delete From Codigos Where IdCodigo=@IdCodigo
go



Create Procedure proc_ConsultarCodigo
As
SELECT IdCodigo, descripcion, idunidadmedida, precio
FROM     Codigos
go
-- ----PROCEDIMIENTOS ALMACENADOS PARA LA TABLA: PARAMETROS-------------------------------------------->



Create Procedure proc_InsertarParametro
@impuestoventas int
As
Insert Into Parametros
	(impuestoventas) Values (@impuestoventas)
go



Create Procedure proc_ModificarParametro
@IdParametro    Int,
@impuestoventas decimal(12, 2)
As
Update Parametros
Set impuestoventas=@impuestoventas 
Where IdParametro=@IdParametro
go



Create Procedure proc_EliminarParametro
@IdParametro Int
As
Delete From Parametros Where IdParametro=@IdParametro
go



Create Procedure proc_ConsultarParametro
As
SELECT IdParametro, impuestoventas
FROM     Parametros
go



Create Procedure proc_InsertarTransaccion
@IdUsuario        int,
@IdCliente        Int,
@IdProveedor      int,
@IdCuenta         varchar(8),
@habilitadetalle  nchar(1),
@descripcion      varchar(50),
@fecha            date,
@subtotal         money,
@descuento        money,
@impuestoventas   decimal(12, 2),
@total            money
As
Insert Into Transacciones
	(Idusuario, idcliente, idproveedor, idcuenta, habilitadetalle, 
	descripcion, fecha, subtotal, descuento, impuestoventas, total)
Values (@IdUsuario, @IdCliente, @IdProveedor, @IdCuenta, @HabilitaDetalle, 
	@Descripcion, @fecha, @subtotal, @descuento, @impuestoventas, @total)
go



Create Procedure proc_ModificarTransaccion
@IdTransaccion    int,
@IdUsuario        int,
@IdCliente        Int,
@IdProveedor      int,
@IdCuenta         varchar(8),
@habilitadetalle  nchar(1),
@descripcion      varchar(50),
@fecha            date,
@subtotal         money,
@descuento        money,
@impuestoventas   decimal(12, 2),
@total            money
As
Update Transacciones
Set Idusuario=@Idusuario, Idcliente=@Idcliente, Idproveedor=@IdProveedor, Idcuenta=@IdCuenta, habilitadetalle=@habilitadetalle, 
	descripcion=@descripcion, fecha=@fecha, subtotal=@subtotal, descuento=@descuento, impuestoventas=@impuestoventas, total=@total
Where IdTransaccion=@IdTransaccion
go



Create Procedure proc_EliminarTransaccion
@IdTransaccion Int
As
Delete From Transacciones Where IdTransaccion=@IdTransaccion
go



Create Procedure proc_ConsultarTransaccion
As
SELECT IdTransaccion, Idusuario, Idcliente, IdProveedor, Idcuenta, habilitadetalle, 
	descripcion, fecha, subtotal, descuento, impuestoventas, total
FROM     Transacciones
go
-- ----PROCEDIMIENTOS ALMACENADOS PARA LA TABLA: TRANSACCIONES_DETALLES-------------------------------->



Create Procedure proc_InsertarTransaccion_Detalle
@IdTransaccion   int,
@IdCodigo        Int,
@IdUnidadMedida  int,
@cantidad        int,
@precio          money
As
Insert Into Transacciones_detalles
	(IdTransaccion, IdCodigo, IdUnidadMedida, Cantidad, Precio)
Values (@IdTransaccion, @IdCodigo, @IdunidadMedida, @Cantidad, @Precio)
go


Create Procedure proc_ModificarTransaccion_detalle
@IdTransaccion   int,
@IdCodigo        Int,
@IdUnidadMedida  int,
@cantidad        int,
@precio          money
As
Update Transacciones_detalles
Set IdCodigo=@IdCodigo, IdUnidadMedida=@IdUnidadMedida, cantidad=@cantidad, precio=@precio
Where IdTransaccion=@IdTransaccion
go

Create Procedure proc_EliminarTransaccion_detalle
@IdTransaccion Int
As
Delete From Transacciones_detalles Where IdTransaccion=@IdTransaccion
go


-- ================================================
Create Procedure proc_ConsultarTransaccion_detalle
As
SELECT IdTransaccion, IdCodigo, IdUnidadMedida, Cantidad, Precio
FROM     Transacciones_detalles
go
-- ----PROCEDIMIENTOS ALMACENADOS PARA LA TABLA: TRANSACCIONES_DETALLES-------------------------------->



@descripcion varchar(10)
As
Insert Into unidades_medidas (descripcion) Values (@descripcion)
go



Create Procedure proc_ModificarUnidad_Medida
@IdUnidadMedida int,
@descripcion varchar(10)
As
Update unidades_medidas
Set descripcion=@descripcion
Where IdUnidadMedida=@IdUnidadMedida
go


Create Procedure proc_EliminarUnidades_Medida
@Idunidadmedida Int
As
Delete From unidades_medidas Where Idunidadmedida=@Idunidadmedida
go


Create Procedure proc_ConsultarUnidades_Medida
As
SELECT IdUnidadMedida, Descripcion
FROM     unidades_medidas
go
