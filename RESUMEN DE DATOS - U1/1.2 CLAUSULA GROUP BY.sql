USE LIBRERIA

--CONSIGNAS

/*1. Los importes totales de ventas por cada artículo que se tiene en el negocio.*/

SELECT A.descripcion 'ARTICULO', SUM(DF.pre_unitario*DF.cantidad)'IMPORTE TOTAL X ARTICULO'
FROM detalle_facturas DF
JOIN articulos A ON DF.cod_articulo = A.cod_articulo
GROUP BY A.descripcion

/*Si se quisiera que fuera solo lo del año pasado ordenado por código de
artículo. (TENIENDO EN CUENTA LA ANTERIOR CONSIGNA)*/

SELECT DF.cod_articulo 'CODIGO ARTICULO', SUM(DF.cantidad*DF.pre_unitario) 'IMPORTE TOTAL X ARTICULO'
FROM detalle_facturas DF
JOIN facturas F ON DF.nro_factura = F.nro_factura
WHERE DATEDIFF(YEAR,F.fecha,GETDATE()) = 1
GROUP BY DF.cod_articulo
ORDER BY 1

/*Calcular el total facturado por cada vendedor y a cada
cliente el año pasado ordenado por vendedor primero y luego por cliente*/

SELECT V.ape_vendedor +', '+V.nom_vendedor 'VENDEDOR',
C.ape_cliente +', '+C.nom_cliente 'CLIENTE',
SUM(DF.pre_unitario*DF.cantidad) 'TOTAL FACTURADO'
FROM detalle_facturas DF
JOIN facturas F ON DF.nro_factura = F.nro_factura
JOIN clientes C ON C.cod_cliente = F.cod_cliente
JOIN vendedores V ON V.cod_vendedor = F.cod_vendedor
WHERE DATEDIFF(YEAR,F.fecha,GETDATE()) = 1
GROUP BY V.ape_vendedor+', '+V.nom_vendedor,
C.ape_cliente+', '+C.nom_cliente
ORDER BY 1,2

/*2. Por cada factura emitida mostrar la cantidad total de artículos vendidos
(suma de las cantidades vendidas), la cantidad ítems que tiene cada factura
en el detalle (cantidad de registros de detalles) y el Importe total de la
facturación de este año.*/

SELECT F.nro_factura 'NUMERO FACTURA',sum(df.cantidad) 'cantidad total de articulos vendidos',
count(df.nro_factura) 'cantidad items en el detalle',
sum(df.cantidad*df.pre_unitario)'importe total'
FROM detalle_facturas DF
JOIN articulos A ON A.cod_articulo = DF.cod_articulo
JOIN facturas F ON F.nro_factura = DF.nro_factura
where year(F.fecha) = YEAR(GETDATE())
GROUP BY F.nro_factura
ORDER BY 1

/*3. Se quiere saber en este negocio, cuánto se factura:
a. Diariamente
b. Mensualmente
c. Anualmente*/

--A
SELECT DAY(F.fecha) 'DIA', SUM(DF.pre_unitario*DF.cantidad) 'IMPORTE FACTURADO'
FROM facturas F
JOIN detalle_facturas DF ON DF.nro_factura = F.nro_factura
GROUP BY DAY(F.fecha)
ORDER BY 1

--B
SELECT MONTH(F.fecha) 'MES', SUM(DF.pre_unitario*DF.cantidad) 'IMPORTE FACTURADO'
FROM facturas F
JOIN detalle_facturas DF ON DF.nro_factura = F.nro_factura
GROUP BY MONTH(F.fecha)
ORDER BY 1

--C
SELECT YEAR(F.fecha) 'AÑO', SUM(DF.pre_unitario*DF.cantidad) 'IMPORTE FACTURADO'
FROM facturas F
JOIN detalle_facturas DF ON DF.nro_factura = F.nro_factura
GROUP BY YEAR(F.fecha)
ORDER BY 1

/*4. Emitir un listado de la cantidad de facturas confeccionadas diariamente,
correspondiente a los meses que no sean enero, julio ni diciembre. Ordene
por la cantidad de facturas en forma descendente y fecha.*/

SELECT DAY(F.fecha) 'DIA', COUNT(F.nro_factura) 'CANTIDAD DE FACTURAS'
FROM FACTURAS F
WHERE MONTH(F.fecha) NOT IN (1,7,12)
GROUP BY DAY(F.fecha)
ORDER BY 2 DESC, 1

/*5. Se quiere saber la cantidad y el importe promedio vendido por fecha y
cliente, para códigos de vendedor superiores a 2. Ordene por fecha y
cliente.*/

SELECT SUM(DF.cantidad) 'CANTIDAD', AVG(DF.cantidad*DF.pre_unitario) 'IMPORTE PROMEDIO',  --PROMEDIO??
F.fecha 'FECHA', C.ape_cliente +', '+C.nom_cliente 'CLIENTE'
FROM detalle_facturas DF
JOIN facturas F ON F.nro_factura = DF.nro_factura
JOIN clientes C ON C.cod_cliente = F.cod_cliente
WHERE F.cod_vendedor > 2
GROUP BY F.fecha, C.ape_cliente+', '+C.nom_cliente
ORDER BY 'FECHA', 'CLIENTE'

/*6. Se quiere saber el importe promedio vendido y la cantidad total vendida por
fecha y artículo, para códigos de cliente inferior a 3. Ordene por fecha y
artículo.*/

SELECT AVG(DF.cantidad*DF.pre_unitario) 'IMPORTE PROMEDIO',	--PROMEDIO IPORTE
SUM(DF.cantidad) 'CANTIDAD TOTAL VENDIDA',
F.fecha 'FECHA', A.descripcion 'ARTICULO'
FROM facturas F
JOIN detalle_facturas DF ON F.nro_factura = DF.nro_factura
JOIN articulos A ON A.cod_articulo = DF.cod_articulo
JOIN clientes C ON C.cod_cliente = F.cod_cliente
WHERE C.cod_cliente < 3
GROUP BY F.fecha, A.descripcion
ORDER BY 'FECHA', 'ARTICULO'

/*7. Listar la cantidad total vendida, el importe total vendido y el importe
promedio total vendido por número de factura, siempre que la fecha no
oscile entre el 13/2/2007 y el 13/7/2010.*/

SELECT F.fecha 'FECHA',SUM(DF.cantidad) 'CANTIDAD TOTAL VENDIDA',
SUM(DF.cantidad*DF.pre_unitario) 'IPORTE TOTAL VENDIDO',
SUM(DF.cantidad*DF.pre_unitario)/COUNT(DISTINCT F.nro_factura) 'PROMEDIO TOTAL VENDIDO X FACTURA'
FROM detalle_facturas DF
JOIN facturas F ON DF.nro_factura = F.nro_factura
WHERE F.fecha NOT BETWEEN '13/2/2007' AND '13/7/2010'
GROUP BY F.fecha

/*8. Emitir un reporte que muestre la fecha de la primer y última venta y el
importe comprado por cliente. Rotule como CLIENTE, PRIMER VENTA,
ÚLTIMA VENTA, IMPORTE.*/

SELECT C.ape_cliente+', '+C.nom_cliente 'CLIENTE', 
MIN(F.fecha) 'PRIMER VENTA',
MAX(F.fecha) 'ULTIMA VENTA',
SUM(DF.pre_unitario*DF.cantidad) 'IMPORTE'
FROM facturas F
JOIN CLIENTES C ON C.cod_cliente = F.cod_cliente
JOIN detalle_facturas DF ON DF.nro_factura = F.nro_factura
GROUP BY C.ape_cliente+', '+C.nom_cliente

/*9. Se quiere saber el importe total vendido, la cantidad total vendida y el precio
unitario promedio por cliente y artículo, siempre que el nombre del cliente
comience con letras que van de la “a” a la “m”. Ordene por cliente, precio
unitario promedio en forma descendente y artículo. Rotule como IMPORTE
TOTAL, CANTIDAD TOTAL, PRECIO PROMEDIO.*/

SELECT SUM(DF.pre_unitario*DF.cantidad)'IMPORTE TOTAL',
SUM(DF.cantidad)'CANTIDAD TOTAL',
AVG(DF.pre_unitario)'PRECIO PROMEDIO',
C.ape_cliente+', '+C.nom_cliente 'CLIENTE',
A.descripcion 'ARTICULO'
FROM detalle_facturas DF
JOIN articulos A ON A.cod_articulo = DF.cod_articulo
JOIN facturas F ON F.nro_factura = DF.nro_factura
JOIN clientes C ON C.cod_cliente = F.cod_cliente
WHERE C.nom_cliente LIKE '[A-M]%'
GROUP BY C.ape_cliente+', '+C.nom_cliente,
A.descripcion
ORDER BY 'CLIENTE', 'PRECIO PROMEDIO' DESC,
'ARTICULO'

/*10.Se quiere saber la cantidad de facturas y la fecha la primer y última factura
por vendedor y cliente, para números de factura que oscilan entre 5 y 30.
Ordene por vendedor, cantidad de ventas en forma descendente y cliente.*/

SELECT COUNT(F.nro_factura)'CANTIDAD FACTURAS',
MIN(F.fecha) 'PRIMER FECHA',
MAX(F.fecha)'ULTIMA FECHA',
V.ape_vendedor+', '+V.nom_vendedor 'VENDEDOR',
C.ape_cliente+', '+C.nom_cliente 'CLIENTE'
FROM facturas F
JOIN vendedores V ON V.cod_vendedor = F.cod_vendedor
JOIN clientes C ON C.cod_cliente = F.cod_cliente
WHERE F.nro_factura BETWEEN 5 AND 30
GROUP BY V.ape_vendedor+', '+V.nom_vendedor,
C.ape_cliente+', '+C.nom_cliente
ORDER BY 'VENDEDOR', 'CANTIDAD FACTURAS' DESC, 'CLIENTE'