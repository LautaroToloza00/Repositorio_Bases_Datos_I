USE LIBRERIA

--CONSIGNAS

/*1. Se solicita un listado de artículos cuyo precio es inferior al promedio de
precios de todos los artículos. (está resuelto en el material teórico)*/

SELECT *
FROM articulos
WHERE pre_unitario < (SELECT AVG(pre_unitario)
						FROM articulos)

/*2. Emitir un listado de los artículos que no fueron vendidos este año. En
ese listado solo incluir aquellos cuyo precio unitario del artículo oscile
entre 50 y 100.*/

SELECT *
FROM ARTICULOS 
WHERE cod_articulo NOT IN (SELECT DF.cod_articulo
							FROM facturas F
							JOIN detalle_facturas DF ON F.nro_factura = DF.nro_factura
							WHERE DATEDIFF(YEAR,F.fecha,GETDATE())= 0)
AND pre_unitario BETWEEN 50 AND 100

--OTRA FORMA

SELECT A.*
FROM ARTICULOS A
WHERE NOT EXISTS (SELECT DF.cod_articulo
					FROM facturas F
					JOIN detalle_facturas DF ON F.nro_factura = DF.nro_factura
					WHERE DF.cod_articulo = A.cod_articulo
					AND YEAR(F.fecha) = YEAR(GETDATE()))
AND A.pre_unitario BETWEEN 50 AND 100


/*3. Genere un reporte con los clientes que vinieron más de 2 veces el año
pasado.*/

SELECT *
FROM clientes C
WHERE 2 < (SELECT COUNT(*)
			FROM facturas F
			WHERE C.cod_cliente = F.cod_cliente
			AND DATEDIFF(YEAR,F.fecha,GETDATE()) = 1)

--OTRA FORMA

SELECT *
FROM clientes C
WHERE EXISTS (SELECT COUNT(*)
				FROM facturas F
				WHERE F.cod_cliente = C.cod_cliente
				AND DATEDIFF(YEAR,F.fecha,GETDATE()) = 1
				HAVING COUNT(*) > 2)

--OTRA FORMA
SELECT *
FROM clientes C
WHERE EXISTS (SELECT F.cod_cliente
				FROM facturas F
				WHERE F.cod_cliente = C.cod_cliente
				AND YEAR(F.fecha) = YEAR(GETDATE())-1
				GROUP BY F.cod_cliente
				HAVING COUNT(*) > 2)


/*4. Se quiere saber qué clientes no vinieron entre el 12/12/2015 y el 13/7/2020*/

SELECT *
FROM CLIENTES
WHERE cod_cliente NOT IN (SELECT F.cod_cliente
							FROM facturas F
							WHERE F.fecha BETWEEN '12/12/2015' AND '13/07/2020')

--OTRA FORMA
SELECT *
FROM CLIENTES C
WHERE NOT EXISTS (SELECT F.cod_cliente
					FROM facturas F
					WHERE F.cod_cliente = C.cod_cliente
					AND F.fecha BETWEEN '12/12/2015' AND '13/07/2020')



/*5. Listar los datos de las facturas de los clientes que solo vienen a comprar
en febrero es decir que todas las veces que vienen a comprar haya sido
en el mes de febrero (y no otro mes).*/

SELECT F.nro_factura 'NUMERO FATURA',F.fecha 'FECHA',
C.ape_cliente+', '+C.nom_cliente 'CLIENTE',
V.ape_vendedor+', '+V.nom_vendedor 'VENDEDOR'
FROM facturas F
JOIN clientes C ON C.cod_cliente = F.cod_cliente
JOIN vendedores V ON V.cod_vendedor = F.cod_vendedor
WHERE 2 = ALL (SELECT MONTH(F.fecha)
				FROM clientes C
				WHERE C.cod_cliente = F.cod_cliente)
ORDER BY 'CLIENTE'

/*6. Mostrar los datos de las facturas para los casos en que por año se hayan
hecho menos de 9 facturas. */

SELECT F.nro_factura 'NUMERO FATURA',F.fecha 'FECHA',
C.ape_cliente+', '+C.nom_cliente 'CLIENTE',
V.ape_vendedor+', '+V.nom_vendedor 'VENDEDOR'
FROM facturas F
JOIN clientes C ON C.cod_cliente = F.cod_cliente
JOIN vendedores V ON V.cod_vendedor = F.cod_vendedor
WHERE YEAR(F.fecha) IN (SELECT YEAR(F2.fecha)
						FROM facturas F2
						GROUP BY YEAR(F2.fecha)
						HAVING COUNT(*) < 9)


--OTRA FORMA
SELECT F.nro_factura 'NUMERO FATURA',F.fecha 'FECHA',
C.ape_cliente+', '+C.nom_cliente 'CLIENTE',
V.ape_vendedor+', '+V.nom_vendedor 'VENDEDOR'
FROM facturas F
JOIN clientes C ON C.cod_cliente = F.cod_cliente
JOIN vendedores V ON V.cod_vendedor = F.cod_vendedor
WHERE EXISTS (SELECT YEAR(F2.fecha)
				FROM facturas F2
				WHERE YEAR(F2.fecha) = YEAR(F.fecha)
				GROUP BY YEAR(F2.fecha)
				HAVING COUNT(*) < 9)


/*7. Emitir un reporte con las facturas cuyo importe total haya sido superior a
1.500 (incluir en el reporte los datos de los artículos vendidos y los
importes).*/

SELECT F.nro_factura 'NUMERO FACTURA', F.fecha 'FECHA',
A.descripcion 'ARTICULO', DF.pre_unitario*DF.cantidad 'IMPORTE'
FROM facturas F
JOIN detalle_facturas DF ON DF.nro_factura = F.nro_factura
JOIN articulos A ON DF.cod_articulo = A.cod_articulo
WHERE 1500 < (SELECT SUM(DF1.pre_unitario*DF1.cantidad)
			FROM detalle_facturas DF1
			WHERE DF1.nro_factura = F.nro_factura)

--OTRA FORMA

SELECT F.nro_factura 'NUMERO FACTURA', F.fecha 'FECHA',
A.descripcion 'ARTICULO', DF.pre_unitario*DF.cantidad 'IMPORTE'
FROM facturas F
JOIN detalle_facturas DF ON DF.nro_factura = F.nro_factura
JOIN articulos A ON DF.cod_articulo = A.cod_articulo
WHERE EXISTS (SELECT SUM(DF1.pre_unitario*DF1.cantidad)
				FROM detalle_facturas DF1
				WHERE DF1.nro_factura = F.nro_factura
				HAVING SUM(DF1.pre_unitario*DF1.cantidad) > 1500)

--OTRA FORMA (MODIFICANDO TAMBIEN EL FORMATO FECHA)

SELECT F.nro_factura 'NUMERO FACTURA', FORMAT(F.fecha,'dd/MM/yyyy') 'FECHA',
A.descripcion 'ARTICULO', DF.pre_unitario*DF.cantidad 'IMPORTE'
FROM facturas F
JOIN detalle_facturas DF ON DF.nro_factura = F.nro_factura
JOIN articulos A ON DF.cod_articulo = A.cod_articulo
WHERE F.nro_factura IN (SELECT DF1.nro_factura
							FROM detalle_facturas DF1
							WHERE DF1.nro_factura = F.nro_factura
							GROUP BY DF1.nro_factura
							HAVING SUM(DF1.pre_unitario*DF1.cantidad) > 1500)

/*8. Se quiere saber qué vendedores nunca atendieron a estos clientes: 1 y 6.
Muestre solamente el nombre del vendedor.*/

SELECT V.ape_vendedor+', '+V.nom_vendedor 'VENDEDOR'
FROM vendedores V
WHERE V.cod_vendedor NOT IN (SELECT F.cod_vendedor
								FROM facturas F
								WHERE F.cod_cliente IN (1,6))

--OTRA FORMA

SELECT V.ape_vendedor+', '+V.nom_vendedor 'VENDEDOR'
FROM vendedores V
WHERE NOT EXISTS (SELECT F.cod_vendedor
				FROM facturas F
				WHERE F.cod_vendedor = V.cod_vendedor
				AND F.cod_cliente IN (1,6))

/*9. Listar los datos de los artículos que superaron el promedio del Importe
de ventas de $ 1.000.*/

SELECT *
FROM articulos A
WHERE A.cod_articulo IN (SELECT DF.cod_articulo
							FROM detalle_facturas DF
							GROUP BY DF.cod_articulo
							HAVING AVG(DF.pre_unitario*DF.cantidad) > 1000)
ORDER BY 1

--OTRA FORMA

select *
from articulos A
where 1000 <(select avg(cantidad*pre_unitario)
				from detalle_facturas dF
				where A.cod_articulo = dF.cod_articulo)
ORDER BY A.cod_articulo

/*10. ¿Qué artículos nunca se vendieron? Tenga además en cuenta que su
nombre comience con letras que van de la “d” a la “p”. Muestre
solamente la descripción del artículo.*/

SELECT A.descripcion 'DESCRIPCION'
FROM articulos A
WHERE A.cod_articulo NOT IN (SELECT DISTINCT DF.cod_articulo --UTILIZO EL DISTINCT PARA QUE HAYA MENOS CODIGOS REPETIDOS
								FROM detalle_facturas DF)
AND A.descripcion NOT LIKE '[D-P]%'

--OTRA FORMA

SELECT A.descripcion 'DESCRIPCION'
FROM articulos A
WHERE NOT EXISTS (SELECT DISTINCT DF.cod_articulo --UTILIZO EL DISTINCT PARA QUE HAYA MENOS CODIGOS REPETIDOS
					FROM detalle_facturas DF
					WHERE DF.cod_articulo = A.cod_articulo)
AND A.descripcion NOT LIKE '[D-P]%'


/*11. Listar número de factura, fecha y cliente para los casos en que ese
cliente haya sido atendido alguna vez por el vendedor de código 3.*/

SELECT F.nro_factura 'NUMERO FACTURA', FORMAT(F.fecha,'dd/MM/yyyy') 'FECHA',
C.ape_cliente +', '+C.nom_cliente 'CLIENTE'
FROM facturas F
JOIN clientes C ON C.cod_cliente = F.cod_cliente
WHERE 3 = ANY (SELECT F2.cod_vendedor
				FROM facturas F2
				WHERE F2.nro_factura = F.nro_factura)

/*12. Listar número de factura, fecha, artículo, cantidad e importe para los
casos en que todas las cantidades (de unidades vendidas de cada
artículo) de esa factura sean superiores a 40.*/

SELECT F.nro_factura 'NUMERO FACTURA', FORMAT(F.fecha,'dd/MM/yyyy') 'FECHA',
A.descripcion 'ARTICULO',DF.cantidad 'CANTIDAD',DF.pre_unitario * DF.cantidad 'IMPORTE'
FROM facturas F
JOIN detalle_facturas DF ON DF.nro_factura = F.nro_factura
JOIN articulos A ON A.cod_articulo = DF.cod_articulo
WHERE NOT EXISTS (SELECT DF2.nro_factura
				FROM detalle_facturas DF2
				WHERE DF2.nro_factura = F.nro_factura
				AND DF2.cantidad <= 40)

/*13. Emitir un listado que muestre número de factura, fecha, artículo,
cantidad e importe; para los casos en que la cantidad total de unidades
vendidas sean superior a 80.*/

SELECT F.nro_factura 'NUMERO FACTURA', F.fecha 'FECHA',
A.descripcion 'ARTICULO',DF.cantidad 'CANTIDAD', DF.cantidad * DF.pre_unitario 'IMPORTE'
FROM facturas F
JOIN detalle_facturas DF ON DF.nro_factura = F.nro_factura
JOIN articulos A ON A.cod_articulo = DF.cod_articulo
WHERE 80 < (SELECT SUM(DF2.cantidad)
				FROM detalle_facturas DF2
				WHERE DF2.nro_factura = F.nro_factura )

--OTRA FORMA
SELECT F.nro_factura 'NUMERO FACTURA', F.fecha 'FECHA',
A.descripcion 'ARTICULO',DF.cantidad 'CANTIDAD', DF.cantidad * DF.pre_unitario 'IMPORTE'
FROM facturas F
JOIN detalle_facturas DF ON DF.nro_factura = F.nro_factura
JOIN articulos A ON A.cod_articulo = DF.cod_articulo
WHERE EXISTS (SELECT DF2.nro_factura
				FROM detalle_facturas DF2
				WHERE DF2.nro_factura = F.nro_factura
				GROUP BY DF2.nro_factura
				HAVING SUM(DF2.cantidad)>80)

/*14. Realizar un listado de número de factura, fecha, cliente, artículo e
importe para los casos en que al menos uno de los importes de esa
factura sea menor a 3.000.*/

SELECT F.nro_factura 'NUMERO FACTURA',FORMAT(F.fecha,'dd/MM/yyyy') 'FECHA',
C.ape_cliente+', '+C.nom_cliente 'CLIENTE', A.descripcion 'ARTICULO',
DF.pre_unitario * DF.cantidad 'IMPORTE'
FROM facturas F
JOIN clientes C ON C.cod_cliente = F.cod_cliente
JOIN detalle_facturas DF ON DF.nro_factura = F.nro_factura
JOIN articulos A ON DF.cod_articulo = A.cod_articulo
WHERE 3000 > ANY (SELECT DF2.pre_unitario * DF2.cantidad
					FROM detalle_facturas DF2
					WHERE DF2.nro_factura = F.nro_factura)
