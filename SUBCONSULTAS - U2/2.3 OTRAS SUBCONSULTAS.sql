USE LIBRERIA

--CONSIGNAS

/*1. Se quiere listar el precio de los artículos y la diferencia de éste con el
precio del artículo más caro.*/

SELECT A.descripcion 'ARTICULO', A.pre_unitario 'PRECIO',
(SELECT MAX(pre_unitario)
FROM articulos) - pre_unitario 'DIFERENCIA'
FROM articulos A

/*2. Listar el precio actual de los artículos y el precio histórico vendido más
barato.*/

SELECT A.descripcion 'ARTICULO', A.pre_unitario 'PRECIO ACTUAL',
(SELECT MIN(DF.pre_unitario)
	FROM detalle_facturas DF
	WHERE DF.cod_articulo = A.cod_articulo) 'PRECIO HISTORICO'
FROM articulos A

/*3. Se quiere emitir un listado de las facturas del año en curso detallando
número de factura, cliente, fecha y total de la misma.*/

SELECT F.nro_factura 'NUMERO FACTURA',
C.ape_cliente +', '+C.nom_cliente 'CLIENTE',
F.fecha 'FECHA', (SELECT SUM(DF.pre_unitario*DF.cantidad)
					FROM detalle_facturas DF
					WHERE DF.nro_factura = F.nro_factura) 'TOTAL'
FROM facturas F
JOIN clientes C ON C.cod_cliente = F.cod_cliente
WHERE DATEDIFF(YEAR,F.fecha,GETDATE()) = 0

/*4. Emitir un listado con la código y descripción de los artículos su precio
actual, el precio promedio al cuál se vendió el año pasado (ver diferencia
entre el promedio ponderado y el promedio simple)*/

SELECT A.cod_articulo 'CODIGO', A.descripcion 'ARTICULO',
A.pre_unitario 'PRECIO ACTUAL', (SELECT AVG(DF.pre_unitario)
									FROM detalle_facturas DF
									JOIN facturas F ON F.nro_factura = DF.nro_factura
									WHERE DF.cod_articulo = A.cod_articulo
									AND DATEDIFF(YEAR,F.fecha,GETDATE()) = 1) 'PRECIO PROMEDIO AÑO PASADO'
FROM articulos A

/*5. Generar un reporte un listado con la código y descripción de los artículos
su precio actual, el precio más barato y el más caro al que se vendió hace
5 años.*/

SELECT A.cod_articulo 'CODIGO',
A.descripcion 'ARTICULO',A.pre_unitario 'PRECIO ACTUAL',
	(SELECT MIN(DF.pre_unitario)
		FROM detalle_facturas DF
		WHERE DF.cod_articulo = A.cod_articulo) 'PRECIO MAS BARATO',
	(SELECT MAX(DF2.pre_unitario)
		FROM detalle_facturas DF2
		JOIN facturas F ON F.nro_factura = DF2.nro_factura
		WHERE DF2.cod_articulo = A.cod_articulo
		AND YEAR(F.fecha) = YEAR(GETDATE())- 5) 'PRECIO MAS CARO'
FROM articulos A

/*6. Descontar un 3,5% los precios de los artículos que se vendieron menos
de 5 unidades los últimos 3 meses.*/

UPDATE articulos
SET pre_unitario = pre_unitario - (pre_unitario * 0.035)
WHERE cod_articulo IN (SELECT DF.cod_articulo
							FROM detalle_facturas DF
							JOIN facturas F ON F.nro_factura = DF.nro_factura
							WHERE DATEDIFF(MONTH,F.fecha,GETDATE()) BETWEEN 0 AND 4
							GROUP BY DF.cod_articulo
							HAVING SUM(DF.cantidad) < 5)

/*7. Se quiere eliminar los clientes que no vinieron nunca.*/

DELETE CLIENTES
WHERE cod_cliente NOT IN (SELECT DISTINCT F.cod_cliente
							FROM facturas F) --QUIERO CODIGOS DE CLIENTES NO REPETIDOS POR ESO EL DISTINCT

/*8. Eliminar los clientes que hace más de 10 años que no vienen.*/

DELETE CLIENTES
WHERE cod_cliente NOT IN (SELECT DISTINCT F.cod_cliente
							FROM facturas F
							WHERE YEAR(F.fecha) BETWEEN YEAR(GETDATE())-10 AND YEAR(GETDATE()))

--OTRA FORMA
DELETE CLIENTES
WHERE cod_cliente NOT IN (SELECT DISTINCT F.cod_cliente
							FROM facturas F
							WHERE DATEDIFF(YEAR,F.fecha,GETDATE()) BETWEEN 0 AND 9)