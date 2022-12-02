/*
  Consultas Equipo 6
  Miguel Angel Gomez Martinez
  Aldo Gabriel Robledo Herrera
  Diego Alvarado Venegas

* Determinar el total de las ventas de los productos con la categor�a que se prueba
* de argumento de entrada en la consulta, para cada uno de los territorios registrados
* en la base de datos.
* */

CREAR PROCEDIMIENTO sp_totalVentas @p_categoryID int
como
empezar 
	SELECCIONE
	entonces _ Id. de territorio ,
	SUM ( T . lineTotal ) as total_Ventas
DE
	AdventureWorks2019 . Ventas .SalesOrderHeader soh
unir internamente
    (
	SELECCIONE
		Id. de pedido de ventas,
		identificaci�n de producto,
		Cantidad,
		linea total
	DE
		AdventureWorks2019 . Ventas .SalesOrderDetail sod
	D�NDE
		ID de producto en (
		SELECCIONE
			identificaci�n de producto
		DE
			AdventureWorks2019 . Producci�n .Producto
		D�NDE
			ProductSubcategoryID en (
			SELECCIONE
				ID de subcategor�a de producto
			DE
				AdventureWorks2019 . Producci�n .ProductSubcategory
			D�NDE
				ProductCategoryID en (
				SELECCIONE
					Id. de categor�a de producto
				DE
					AdventureWorks2019 . Producci�n .ProductCategory
				D�NDE
					ProductCategoryID = @p_categoryID
   				)
   			)
)) como T
    en
	entonces _ IDPedidoVenta  =  T . Id. de pedido de ventas
Agrupar por
	entonces _ ID de territorio
PEDIR por
	total_Ventas DESC
final

/*
* Determinar el producto m�s solicitado para la regi�n (atributo group de
* salesterritory)�Noth America�y en que territorio de la regi�n tiene mayor
* demanda.
* Quitando el Top 1, da la lista de todos los productos
* */

CREAR PROCEDIMIENTO sp_productoSolicitado @p_groupT nvarchar ( 50 )  
COMO
EMPEZAR 
	SELECCIONA  TOP  1  SUM ( T . lineTotal ) como total_ventas, p . Nombre  como Nombre, p�g . Identificaci�n de producto
DE
	AdventureWorks2019 . Producci�n .Producto p
uni�n interna (
	SELECCIONE
		Identificaci�n de producto,
		linea total
	DE
		AdventureWorks2019 . Ventas .SalesOrderDetail sod
	D�NDE
		SalesOrderID en (
		SELECCIONE
			Id. de pedido de ventas
		DE
			AdventureWorks2019 . Ventas .SalesOrderHeader soh
		D�NDE
			Id. de territorio en (
			SELECCIONE
				Id. de territorio
			DE
				AdventureWorks2019 . Ventas .SalesTerritory st
			D�NDE
				[Grupo] = @p_groupT
			)
		)
	) como T
	en
	p�g . ID de producto  =  T . Identificaci�n de producto
AGRUPAR POR
	p�g . nombre ,
	p�g . Identificaci�n de producto
PEDIR por
	total_ventas DESC
FINAL 


/* Ejercicio 5-c
Actualizar el stock disponible en un 5% de los productos de la categor�a que se
pruebe como argumento de entrada en una localidad que se pruebe como
entrada en la instrucci�n de actualizaci�n. */
CREAR  O ALTERAR PROCEDIMIENTO ActuStock @CAT nvarchar ( 25 ) AS
EMPEZAR 
DECLARAR @PID int ;
set @PID = ( SELECCIONE ProductID FROM [PRODUCCI�N ENLAZADA]. productionAW . Production .ProductInventory PRID DONDE
PRID . ID de ubicaci�n  en ( SELECCIONE ID de producto DE [PRODUCCI�N ENLAZADA]. producci�nAW . Producci�n .Subcategor�a de producto WHERE ID de categor�a de producto = @CAT ));
actualizar [PRODUCCI�N VINCULADA]. producci�nAW . Producci�n .ProductInventory set Cantidad = Cantidad * 1 . 05  DONDE IDProducto  =  @PID;
FINAL



/* Ejercicio 5-d
Determinar si hay clientes que realizan �rdenes en territorios diferentes al que
se encuentran. */
CREAR  O ALTERAR PROCEDIMIENTO DiferentesTerritorios AS
EMPEZAR
SELECCIONA  SACU . TerritoryID  como TerritorioC, SAOH . TerritoryID  como TerritorioO, SATE.[Nombre] como Territorio
DESDE [VENTAS-ENLAZADAS]. ventasAW . Ventas .Cliente SACU
UNI�N INTERNA [VENTAS ENLAZADAS]. ventasAW . Ventas .SalesOrderHeader SAOH ON  SACU . N�meroCuenta  !=  SAOH . N�mero de cuenta
UNI�N INTERNA [VENTAS ENLAZADAS]. ventasAW . Ventas .VentasTerritorio SATE EN  SACU . Id. de territorio  =  SAOH . Id. de territorio
GRUPO POR  SACU . TerritoryID , SAOH . TerritoryID , SATE.[Nombre]
FINAL





 

CREAR PROCEDIMIENTO sp_OrderQtyUpdate @p_SalesOrderID int ,
@p_OrderQty int
COMO
EMPEZAR
	SI  EXISTE (
	SELECCIONE
		c�sped _ OrderQty  como Cantidad_Productos,
		p�g . Nombre  como Nombre_Producto,
		c�sped _ Id. de pedido de ventas
	DE
		AdventureWorks2019 . Ventas .SalesOrderDetail sod
	uni�n interna  AdventureWorks2019 . Producci�n .Producto p
	en
		c�sped _ ID de producto  =  p . Identificaci�n de producto
		y  c�sped . IDPedidoVentas  = @p_IDPedidoVentas
	)
		actualizar  AdventureWorks2019 . Ventas .SalesOrderDetail set OrderQty = @p_OrderQty where SalesOrderID = @p_SalesOrderID
M�S 
	IMPRIMIR  ' No se pudo actualizar'
FINAL
	

/*
	 * Actualizar el m�todo de env�o de una orden que se recibe como argumento en la instrucci�n de actualizaci�n.
	 * */	
	
CREAR PROCEDIMIENTO sp_shipMethodUpdate @p_SalesOrderID int ,
@p_ShipMethodID int
COMO
EMPEZAR 
	SI  EXISTE (
	SELECCIONE
		sm _ Nombre  como M�todo_Envio,
		sm _ ShipMethodID  como ID_Metodo,
		entonces _ ShipMethodID  como ID_Metodo_Seleccionado,
		entonces _ Id. de pedido de ventas
	DE
		AdventureWorks2019 . Ventas .SalesOrderHeader soh
	uni�n interna  AdventureWorks2019 . Compra de .ShipMethod sm
	en
		entonces _ ShipMethodID  =  sm . ShipMethodID
	d�nde
		entonces _ IDPedidoVentas  = @p_IDPedidoVentas
	)
	ACTUALIZAR  AdventureWorks2019 . Ventas .SalesOrderHeader set ShipMethodID = @p_ShipMethodID WHERE SalesOrderID = @p_SalesOrderID
	M�S 
		IMPRIMIR  ' No se pudo actualizar'
FINAL

/*
	 * Actualizar el correo electr�nico de un cliente que se recibe como argumento en la instrucci�n de actualizaci�n.
	 * */

ALTERAR PROCEDIMIENTO sp_emailAddressUpdate @p_EmailAddressOld nvarchar ( 50 ),@p_EmailAddressNew nvarchar ( 50 )
COMO 
EMPEZAR 
	SI  EXISTE (
		SELECCIONE  p�g . FirstName  como Nombre, ea . Direcci�n de correo electr�nico  como correo electr�nico
	DESDE  AdventureWorks2019 . Persona .Persona p
	uni�n interna  AdventureWorks2019 . Persona .EmailAddress ea
	en la  p�g . BusinessEntityID  =  ea . ID de entidad empresarial 
	donde  ea . Direcci�n de correo electr�nico = @p_EmailAddressOld 
	)
	ACTUALIZAR  AdventureWorks2019 . Persona .EmailAddress set EmailAddress = @p_EmailAddressNew WHERE EmailAddressID = @p_EmailAddressOld
	M�S 
		IMPRIMIR  ' No se pudo actualizar'
	
FINAL