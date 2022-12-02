/*
  Consultas Equipo 6
  Miguel Angel Gomez Martinez
  Aldo Gabriel Robledo Herrera
  Diego Alvarado Venegas

* Determinar el total de las ventas de los productos con la categoría que se prueba
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
		identificación de producto,
		Cantidad,
		linea total
	DE
		AdventureWorks2019 . Ventas .SalesOrderDetail sod
	DÓNDE
		ID de producto en (
		SELECCIONE
			identificación de producto
		DE
			AdventureWorks2019 . Producción .Producto
		DÓNDE
			ProductSubcategoryID en (
			SELECCIONE
				ID de subcategoría de producto
			DE
				AdventureWorks2019 . Producción .ProductSubcategory
			DÓNDE
				ProductCategoryID en (
				SELECCIONE
					Id. de categoría de producto
				DE
					AdventureWorks2019 . Producción .ProductCategory
				DÓNDE
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
* Determinar el producto más solicitado para la región (atributo group de
* salesterritory)“Noth America”y en que territorio de la región tiene mayor
* demanda.
* Quitando el Top 1, da la lista de todos los productos
* */

CREAR PROCEDIMIENTO sp_productoSolicitado @p_groupT nvarchar ( 50 )  
COMO
EMPEZAR 
	SELECCIONA  TOP  1  SUM ( T . lineTotal ) como total_ventas, p . Nombre  como Nombre, pág . Identificación de producto
DE
	AdventureWorks2019 . Producción .Producto p
unión interna (
	SELECCIONE
		Identificación de producto,
		linea total
	DE
		AdventureWorks2019 . Ventas .SalesOrderDetail sod
	DÓNDE
		SalesOrderID en (
		SELECCIONE
			Id. de pedido de ventas
		DE
			AdventureWorks2019 . Ventas .SalesOrderHeader soh
		DÓNDE
			Id. de territorio en (
			SELECCIONE
				Id. de territorio
			DE
				AdventureWorks2019 . Ventas .SalesTerritory st
			DÓNDE
				[Grupo] = @p_groupT
			)
		)
	) como T
	en
	pág . ID de producto  =  T . Identificación de producto
AGRUPAR POR
	pág . nombre ,
	pág . Identificación de producto
PEDIR por
	total_ventas DESC
FINAL 


/* Ejercicio 5-c
Actualizar el stock disponible en un 5% de los productos de la categoría que se
pruebe como argumento de entrada en una localidad que se pruebe como
entrada en la instrucción de actualización. */
CREAR  O ALTERAR PROCEDIMIENTO ActuStock @CAT nvarchar ( 25 ) AS
EMPEZAR 
DECLARAR @PID int ;
set @PID = ( SELECCIONE ProductID FROM [PRODUCCIÓN ENLAZADA]. productionAW . Production .ProductInventory PRID DONDE
PRID . ID de ubicación  en ( SELECCIONE ID de producto DE [PRODUCCIÓN ENLAZADA]. producciónAW . Producción .Subcategoría de producto WHERE ID de categoría de producto = @CAT ));
actualizar [PRODUCCIÓN VINCULADA]. producciónAW . Producción .ProductInventory set Cantidad = Cantidad * 1 . 05  DONDE IDProducto  =  @PID;
FINAL



/* Ejercicio 5-d
Determinar si hay clientes que realizan órdenes en territorios diferentes al que
se encuentran. */
CREAR  O ALTERAR PROCEDIMIENTO DiferentesTerritorios AS
EMPEZAR
SELECCIONA  SACU . TerritoryID  como TerritorioC, SAOH . TerritoryID  como TerritorioO, SATE.[Nombre] como Territorio
DESDE [VENTAS-ENLAZADAS]. ventasAW . Ventas .Cliente SACU
UNIÓN INTERNA [VENTAS ENLAZADAS]. ventasAW . Ventas .SalesOrderHeader SAOH ON  SACU . NúmeroCuenta  !=  SAOH . Número de cuenta
UNIÓN INTERNA [VENTAS ENLAZADAS]. ventasAW . Ventas .VentasTerritorio SATE EN  SACU . Id. de territorio  =  SAOH . Id. de territorio
GRUPO POR  SACU . TerritoryID , SAOH . TerritoryID , SATE.[Nombre]
FINAL





 

CREAR PROCEDIMIENTO sp_OrderQtyUpdate @p_SalesOrderID int ,
@p_OrderQty int
COMO
EMPEZAR
	SI  EXISTE (
	SELECCIONE
		césped _ OrderQty  como Cantidad_Productos,
		pág . Nombre  como Nombre_Producto,
		césped _ Id. de pedido de ventas
	DE
		AdventureWorks2019 . Ventas .SalesOrderDetail sod
	unión interna  AdventureWorks2019 . Producción .Producto p
	en
		césped _ ID de producto  =  p . Identificación de producto
		y  césped . IDPedidoVentas  = @p_IDPedidoVentas
	)
		actualizar  AdventureWorks2019 . Ventas .SalesOrderDetail set OrderQty = @p_OrderQty where SalesOrderID = @p_SalesOrderID
MÁS 
	IMPRIMIR  ' No se pudo actualizar'
FINAL
	

/*
	 * Actualizar el método de envío de una orden que se recibe como argumento en la instrucción de actualización.
	 * */	
	
CREAR PROCEDIMIENTO sp_shipMethodUpdate @p_SalesOrderID int ,
@p_ShipMethodID int
COMO
EMPEZAR 
	SI  EXISTE (
	SELECCIONE
		sm _ Nombre  como Método_Envio,
		sm _ ShipMethodID  como ID_Metodo,
		entonces _ ShipMethodID  como ID_Metodo_Seleccionado,
		entonces _ Id. de pedido de ventas
	DE
		AdventureWorks2019 . Ventas .SalesOrderHeader soh
	unión interna  AdventureWorks2019 . Compra de .ShipMethod sm
	en
		entonces _ ShipMethodID  =  sm . ShipMethodID
	dónde
		entonces _ IDPedidoVentas  = @p_IDPedidoVentas
	)
	ACTUALIZAR  AdventureWorks2019 . Ventas .SalesOrderHeader set ShipMethodID = @p_ShipMethodID WHERE SalesOrderID = @p_SalesOrderID
	MÁS 
		IMPRIMIR  ' No se pudo actualizar'
FINAL

/*
	 * Actualizar el correo electrónico de un cliente que se recibe como argumento en la instrucción de actualización.
	 * */

ALTERAR PROCEDIMIENTO sp_emailAddressUpdate @p_EmailAddressOld nvarchar ( 50 ),@p_EmailAddressNew nvarchar ( 50 )
COMO 
EMPEZAR 
	SI  EXISTE (
		SELECCIONE  pág . FirstName  como Nombre, ea . Dirección de correo electrónico  como correo electrónico
	DESDE  AdventureWorks2019 . Persona .Persona p
	unión interna  AdventureWorks2019 . Persona .EmailAddress ea
	en la  pág . BusinessEntityID  =  ea . ID de entidad empresarial 
	donde  ea . Dirección de correo electrónico = @p_EmailAddressOld 
	)
	ACTUALIZAR  AdventureWorks2019 . Persona .EmailAddress set EmailAddress = @p_EmailAddressNew WHERE EmailAddressID = @p_EmailAddressOld
	MÁS 
		IMPRIMIR  ' No se pudo actualizar'
	
FINAL