use AdventureWorks2019

/*
A) Determinarel total de las ventas delos productos con la categoría que se provea de argumento de entrada en la consulta, para cada uno de 
los territorios registrados en la base de datos.
*/
go
create procedure consultaA as

	select soh.TerritoryID, sum(t.LineTotal) as Total_Ventas
	from Sales.SalesOrderHeader soh
	inner join
	(select salesorderid, productid, orderqty, linetotal
	from Sales.SalesOrderDetail sod
	where ProductID in (
		select ProductID
		from Production.Product
		where ProductSubcategoryID in (
			select ProductSubcategoryID
			from Production.ProductSubcategory
			where ProductCategoryID in(
				select ProductCategoryID
				from Production.ProductCategory	
				where ProductCategoryID = 1
			)
		)
	)) as T
	on soh.SalesOrderID = t.SalesOrderID
	group by soh.TerritoryID
	order by soh.TerritoryID


/*
B) Determinar el producto más solicitado para la región (atributo group de salesterritory) “Noth America” y en que 
territorio de la región tiene mayor demanda.
*/


/*
D) Determinar si hay clientes que realizan ordenes en territorios diferentes al que se encuentran. 
*/




/*
G) Actualizar el correo electrónico de una cliente que se reciba como argumento en la instrucción de actualización.
*/




go
alter procedure actualizar_correo 
	@correo_actual nvarchar(50),
	@correo_nuevo nvarchar(50)
as 
if exists (select EmailAddressID as a from Person.EmailAddress where EmailAddress = @correo_actual)
begin 
	update Person.EmailAddress set EmailAddress = @correo_nuevo where EmailAddressID = a
end

else
begin
	print 'No existe un correo registrado'
end

exec actualizar_correo 'ken0@adventureworks.com', 'ken1@adventureworks.com'

select * from Person.EmailAddress