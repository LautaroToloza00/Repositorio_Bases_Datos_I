USE LIBRERIA

--CONSIGNAS

/*1. Facturación total del negocio.*/

SELECT SUM(DF.cantidad*DF.pre_unitario)'FACTURACION TOTAL'
FROM detalle_facturas DF

/*2. También se quiere saber el total de la factura Nro. 236, la cantidad de
artículos vendidos, cantidad de ventas, el precio máximo y mínimo vendido.*/

SELECT SUM(DF.cantidad*DF.pre_unitario)'TOTAL',
SUM(DF.cantidad) 'CANTIDAD ARTICULOS VENDIDOS',
COUNT(DF.nro_factura) 'CANTIDAD DE VENTAS',
MAX(DF.pre_unitario)'PRECIO MAXIMO',
MIN(DF.pre_unitario)'PRECIO MINIMO'
FROM detalle_facturas DF
WHERE DF.nro_factura = 236

/*3. Se nos solicita además lo siguiente: ¿Cuánto se facturó el año pasado?*/

SELECT SUM(DF.pre_unitario*DF.cantidad) 'TOTAL FACTURADO AÑO PASADO'
FROM detalle_facturas DF
JOIN facturas F ON F.nro_factura = DF.nro_factura
WHERE DATEDIFF(YEAR,F.fecha,GETDATE()) = 1 --AÑO PASADO

/*4. ¿Cantidad de clientes con dirección de e-mail sea conocido (no nulo)?*/

SELECT COUNT(C.cod_cliente) 'CANTIDAD CLIENTES CON E-MAIL'
FROM clientes C
WHERE C.[e-mail] IS NOT NULL

-- OTRA VARIANTE

SELECT COUNT(C.[e-mail]) 'CANTIDAD CLIENTES CON E-MAIL'
FROM clientes C

/*5. ¿Cuánto fue el monto total de la facturación de este negocio? ¿Cuántas
facturas se emitieron?*/

SELECT SUM(DF.pre_unitario*DF.cantidad) 'TOTAL FACTURADO',
COUNT(DISTINCT F.nro_factura) 'CANTIDAD FACTURAS',
COUNT(*) 'CANTIDAD DE REGISTROS' --ESTA COLUMNA NO FUE PEDIDA
FROM detalle_facturas DF
JOIN facturas F ON F.nro_factura = DF.nro_factura

-- VERIFICACION DE LA CANTIDAD DE FACTURAS QUE HAY

SELECT COUNT(*) 'CANTIDAD FACTURAS'
FROM facturas

/*6. Se necesita conocer el promedio del monto facturado por factura el año
pasado.*/

--SOLUCION CORRECTA

SELECT SUM(DF.cantidad*DF.pre_unitario)/COUNT(DISTINCT F.nro_factura) 'PROMEDIO TOTAL FACTURADO EL AO PASADO'
FROM detalle_facturas DF
JOIN facturas F ON F.nro_factura = DF.nro_factura
WHERE YEAR(F.fecha) = YEAR(GETDATE())- 1

-- AVG(COLUMNA) --> SUMA PRIMERO TODO LO DE LA COLUMNA Y DIVIDE POR LA CANTIDAD DE REGISTROS.
-- EQUIVALENTE A SUM(COLUMNA)/COUNT(*)

-- ESTA RESOLUCION ESTA INCORRECTA

SELECT AVG(DF.cantidad*DF.cantidad)'PROMEDIO DEL MONTO FACTURADO EL AÑO PASADO, POR DETALLE FACTURA'
FROM detalle_facturas DF
JOIN facturas F ON F.nro_factura = DF.nro_factura
WHERE DATEDIFF(YEAR,F.fecha,GETDATE()) = 1

/*7. Se quiere saber la cantidad de ventas que hizo el vendedor de código 3.*/
--EN DUDAS

SELECT count(*) 'CANTIDAD DE VENTAS'
FROM detalle_facturas DF
JOIN facturas F ON F.nro_factura = DF.nro_factura
WHERE F.cod_vendedor = 3

/*8. ¿Cuál fue la fecha de la primera y última venta que se realizó en este
negocio?*/

SELECT MIN(F.fecha)'PRIMERA VENTA',
MAX(F.fecha)'ULTIMA VENTA'
FROM facturas F

/*9. Mostrar la siguiente información respecto a la factura nro.: 450: cantidad
total de unidades vendidas, la cantidad de artículos diferentes vendidos y
el importe total.*/

SELECT SUM(DF.cantidad) 'CANTIDAD DE UNIDADES VENDIDAS',
COUNT(DISTINCT DF.cod_articulo) 'CANTIDAD DE ARTICULOS DIFERENTES VENDIDOS',
SUM(DF.pre_unitario*DF.cantidad) 'IMPORTE TOTAL'
FROM detalle_facturas DF
WHERE DF.nro_factura = 450

/*10.¿Cuál fue la cantidad total de unidades vendidas, importe total y el importe
promedio para vendedores cuyos nombres comienzan con letras que van
de la “d” a la “l”?*/

SELECT SUM(DF.cantidad) 'TOTAL UNIDADES VENDIDAS',
SUM(DF.cantidad*DF.pre_unitario) 'IMPORTE TOTAL',
AVG(DF.cantidad*DF.pre_unitario) 'IMPORTE PROMEDIO' --SUM(DF.CANTIDAD*DF.PRE_UNITARIO)/ COUNT(DISTINCT F.NRO_FACTURA)??
FROM detalle_facturas DF
JOIN facturas F ON F.nro_factura = DF.nro_factura
JOIN clientes C ON C.cod_cliente = F.cod_cliente
WHERE C.nom_cliente LIKE '[D-L]%'

/*11.Se quiere saber el importe total vendido, el promedio del importe vendido y
la cantidad total de artículos vendidos para el cliente Roque Paez.*/

SELECT SUM(DF.cantidad*DF.pre_unitario) 'IMPORTE TOTAL VENDIDO',
AVG(DF.cantidad*DF.pre_unitario) 'PROMEDIO IMPORTE VENDIDO',
SUM(DF.cantidad) 'CANTIDAD ARTICULOS VENDIDOS'
FROM facturas F
JOIN detalle_facturas DF ON DF.nro_factura = F.nro_factura
JOIN clientes C ON C.cod_cliente = F.cod_cliente
WHERE C.nom_cliente = 'Roque'
AND C.ape_cliente = 'Paez'

/*12.Mostrar la fecha de la primera venta, la cantidad total vendida y el importe
total vendido para los artículos que empiecen con “C”.*/

SELECT MIN(F.fecha) 'FECHA PRIMERA VENTA',
SUM(DF.cantidad) 'CANTIDAD TOTAL VENDIDA',
SUM(DF.cantidad*DF.pre_unitario) 'IMPORTE TOTAL VENDIDO'
FROM facturas F
JOIN detalle_facturas DF ON F.nro_factura = DF.nro_factura
JOIN articulos A ON A.cod_articulo = DF.cod_articulo
WHERE A.descripcion LIKE '[C]%'

/*13.Se quiere saber la cantidad total de artículos vendidos y el importe total
vendido para el periodo del 15/06/2011 al 15/06/2017.*/

SELECT SUM(DF.cantidad) 'CANTIDAD ARTICULOS VENDIDOS',
SUM(DF.cantidad*DF.pre_unitario) 'IMPORTE TOTAL'
FROM detalle_facturas DF
JOIN articulos A ON A.cod_articulo = DF.cod_articulo
JOIN facturas F ON F.nro_factura = DF.nro_factura
WHERE F.fecha BETWEEN '15/06/2011' AND '15/06/2017'

/*14.Se quiere saber la cantidad de veces y la última vez que vino el cliente de
apellido Abarca y cuánto gastó en total.*/

SELECT COUNT(DISTINCT F.nro_factura) 'CANTIDAD DE VECES QUE VINO',
MAX(F.fecha) 'FECHA ULTIMA VEZ',
SUM(DF.cantidad*DF.pre_unitario) 'TOTAL GASTADO'
FROM detalle_facturas DF
JOIN facturas F ON F.nro_factura = DF.nro_factura
JOIN clientes C ON C.cod_cliente = F.cod_cliente
WHERE C.ape_cliente = 'Abarca'

/*15.Mostrar el importe total y el promedio del importe para los clientes cuya
dirección de mail es conocida.*/

SELECT SUM(DF.cantidad*DF.pre_unitario) 'IMPORTE TOTAL',
AVG(DF.cantidad*DF.pre_unitario) 'PROMEDIO IMPORTE' -- OTRA DUDA
FROM detalle_facturas DF
JOIN facturas F ON F.nro_factura = DF.nro_factura
JOIN clientes C ON C.cod_cliente = F.cod_cliente
WHERE C.[e-mail] IS NOT NULL

/*16.Obtener la siguiente información: el importe total vendido y el importe
promedio vendido para números de factura que no sean los siguientes: 13,
5, 17, 33, 24.*/

SELECT SUM(DF.cantidad*DF.pre_unitario) 'IMPORTE TOTAL',
AVG(DF.cantidad*DF.pre_unitario) 'PROMEDIO IMPORTE' -- DUDA CON LOS PROMEDIOS
FROM facturas F
JOIN detalle_facturas DF ON DF.nro_factura = F.nro_factura
WHERE F.nro_factura NOT IN (13,5,17,33,24)

