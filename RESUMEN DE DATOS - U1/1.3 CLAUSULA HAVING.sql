USE LIBRERIA

--CONSIGNAS

/*1. Se necesita saber el importe total de cada factura, pero solo aquellas donde
ese importe total sea superior a 2500.*/

SELECT F.nro_factura, SUM(DF.pre_unitario*DF.cantidad) 'IMPORTE'
FROM facturas F
JOIN detalle_facturas DF ON DF.nro_factura = F.nro_factura
GROUP BY F.nro_factura
HAVING SUM(DF.pre_unitario*DF.cantidad) > 2500

/*2. Se desea un listado de vendedores y sus importes de ventas del año 2017
pero solo aquellos que vendieron menos de $ 17.000.- en dicho año.*/

SELECT V.ape_vendedor+', '+V.nom_vendedor 'VENDEDOR',
SUM(DF.pre_unitario*DF.cantidad)'IMPORTE'
FROM vendedores V
JOIN facturas F ON V.cod_vendedor = F.cod_vendedor
JOIN detalle_facturas DF ON DF.nro_factura = F.nro_factura
WHERE YEAR(F.fecha) = 2017
GROUP BY V.ape_vendedor+', '+V.nom_vendedor
HAVING SUM(DF.pre_unitario*DF.cantidad) < 17000

/*3. Se quiere saber la fecha de la primera venta, la cantidad total vendida y el
importe total vendido por vendedor para los casos en que el promedio de
la cantidad vendida sea inferior o igual a 56.*/

SELECT MIN(F.fecha) 'PRIMERA VENTA', SUM(DF.cantidad) 'CANTIDAD TOTAL',
SUM(DF.cantidad*DF.pre_unitario) 'IMPORTE TOTAL',
V.ape_vendedor +', '+V.nom_vendedor 'VENDEDOR'
FROM facturas F
JOIN detalle_facturas DF ON F.nro_factura = DF.nro_factura
JOIN vendedores V ON V.cod_vendedor = F.cod_vendedor
GROUP BY V.ape_vendedor +', '+V.nom_vendedor
HAVING AVG(DF.cantidad) <= 56 --Equivale sum(df.cantidad)/count(*)

/*4. Se necesita un listado que informe sobre el monto máximo, mínimo y total
que gastó en esta librería cada cliente el año pasado, pero solo donde el
importe total gastado por esos clientes esté entre 300 y 800.*/

SELECT MAX(DF.pre_unitario*DF.cantidad) 'MONTO MÁXIMO',
MIN(DF.pre_unitario*DF.cantidad)'MONTO MÍNIMO',
SUM(DF.pre_unitario*DF.cantidad)'TOTAL',
C.ape_cliente+', '+C.nom_cliente 'CLIENTE'
FROM detalle_facturas DF
JOIN facturas F ON DF.nro_factura = F.nro_factura
JOIN clientes C ON C.cod_cliente = F.cod_cliente
WHERE DATEDIFF(YEAR,F.fecha,GETDATE()) = 1
GROUP BY C.ape_cliente+', '+C.nom_cliente
HAVING SUM(DF.pre_unitario*DF.cantidad) BETWEEN 300 AND 800

/*5. Muestre la cantidad facturas diarias por vendedor; para los casos en que
esa cantidad sea 2 o más.*/

SELECT V.ape_vendedor+', '+V.nom_vendedor 'VENDEDOR',
COUNT(DAY(F.fecha)) 'CANTIDAD FACTURAS DIARIAS'
FROM vendedores V
JOIN facturas F ON F.cod_vendedor = V.cod_vendedor
GROUP BY V.ape_vendedor+', '+V.nom_vendedor
HAVING COUNT(DAY(F.FECHA)) >= 2

/*6. Desde la administración se solicita un reporte que muestre el precio
promedio, el importe total y el promedio del importe vendido por artículo
que no comiencen con “c”, que su cantidad total vendida sea 100 o más o
que ese importe total vendido sea superior a 700.*/

SELECT AVG(A.pre_unitario)'PRECIO PROMEDIO',
SUM(DF.pre_unitario*DF.cantidad) 'IMPORTE TOTAL',
AVG(DF.pre_unitario*DF.cantidad) 'PROMEDIO IMPORTE',
A.descripcion 'ARTICULO'
FROM detalle_facturas DF
JOIN articulos A ON DF.cod_articulo = A.cod_articulo
WHERE A.descripcion NOT LIKE '[C]%'
GROUP BY A.descripcion
HAVING SUM(DF.cantidad) >= 100
OR SUM(DF.pre_unitario*DF.cantidad) > 700

/*7. Muestre en un listado la cantidad total de artículos vendidos, el importe
total y la fecha de la primer y última venta por cada cliente, para lo
números de factura que no sean los siguientes: 2, 12, 20, 17, 30 y que el
promedio de la cantidad vendida oscile entre 2 y 6. */

SELECT SUM(DF.cantidad) 'CANTIDAD VENDIDA',
SUM(DF.cantidad*DF.pre_unitario) 'IMPORTE TOTAL',
MIN(F.fecha) 'PRIMERA VENTA',
MAX(F.fecha) 'ULTIMA VENTA',
C.ape_cliente+', '+C.nom_cliente 'CLIENTE'
FROM detalle_facturas DF
JOIN facturas F ON DF.nro_factura = DF.nro_factura
JOIN clientes C ON C.cod_cliente = F.cod_cliente
WHERE F.nro_factura NOT IN (2,12,20,17,30)
GROUP BY C.ape_cliente+', '+C.nom_cliente
HAVING AVG(DF.pre_unitario*DF.cantidad) BETWEEN 2 AND 6

/*8. Emitir un listado que muestre la cantidad total de artículos vendidos, el
importe total vendido y el promedio del importe vendido por vendedor y
por cliente; para los casos en que el importe total vendido esté entre 200
y 600 y para códigos de cliente que oscilen entre 1 y 5.*/

SELECT SUM(DF.cantidad) 'CANTIDAD ARTICULOS VENDIDOS',
SUM(DF.pre_unitario*DF.cantidad) 'IMPORTE TOTAL',
AVG(DF.pre_unitario*DF.cantidad) 'PROMEDIO IMPORTE',
V.ape_vendedor+', '+V.nom_vendedor 'VENDEDOR',
C.ape_cliente+', '+C.nom_cliente 'CLIENTE'
FROM detalle_facturas DF
JOIN facturas F ON F.nro_factura = DF.nro_factura
JOIN clientes C ON C.cod_cliente = F.cod_cliente
JOIN vendedores V ON V.cod_vendedor = F.cod_vendedor
WHERE C.cod_cliente BETWEEN 1 AND 5
GROUP BY V.ape_vendedor+', '+V.nom_vendedor,
C.ape_cliente+', '+C.nom_cliente
HAVING SUM(DF.pre_unitario*DF.cantidad) BETWEEN 200 AND 300

/*9. ¿Cuáles son los vendedores cuyo promedio de facturación el mes pasado
supera los $ 800?*/

SELECT V.ape_vendedor+', '+V.nom_vendedor 'VENDEDOR',
AVG(DF.pre_unitario*DF.cantidad) 'PROMEDIO FATURACION'
FROM vendedores V
JOIN facturas F ON F.cod_vendedor = V.cod_vendedor
JOIN detalle_facturas DF ON DF.nro_factura = F.nro_factura
WHERE DATEDIFF(MONTH,F.fecha,GETDATE()) = 1
GROUP BY V.ape_vendedor+', '+V.nom_vendedor
HAVING AVG(DF.pre_unitario*DF.cantidad) > 800

/*10.¿Cuánto le vendió cada vendedor a cada cliente el año pasado siempre
que la cantidad de facturas emitidas (por cada vendedor a cada cliente)
sea menor a 5?*/

SELECT SUM(DF.cantidad)'CANTIDAD VENDIDA',
V.ape_vendedor+', '+V.nom_vendedor 'VENDEDOR',
C.ape_cliente+', '+C.nom_cliente 'CLIENTE',
COUNT(DISTINCT F.nro_factura) 'CANTIDAD FACTURAS'
FROM detalle_facturas DF
JOIN facturas F ON F.nro_factura = DF.nro_factura
JOIN clientes C ON C.cod_cliente = F.cod_cliente
JOIN vendedores V ON V.cod_vendedor = F.cod_vendedor
WHERE DATEDIFF(YEAR,F.fecha,GETDATE()) = 1
GROUP BY V.ape_vendedor+', '+V.nom_vendedor,
C.ape_cliente+', '+C.nom_cliente
HAVING COUNT(DISTINCT F.nro_factura) < 5