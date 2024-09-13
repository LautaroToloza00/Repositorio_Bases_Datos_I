USE LIBRERIA

--CONSIGNAS

/*1. El código y nombre completo de los clientes, la dirección (calle y número) y
barrio.*/

CREATE VIEW VIS_INFORMACION_CLIENTES
AS
	SELECT C.cod_cliente 'CODIGO', C.ape_cliente +', '+ C.nom_cliente 'NOMBRE COMPLETO',
	C.calle+STR(C.altura) 'DIRECCION', B.barrio 'BARRIO'
	FROM clientes C
	JOIN barrios B ON B.cod_barrio = C.cod_barrio

--EJECUTO LA VISTA
SELECT *
FROM VIS_INFORMACION_CLIENTES
ORDER BY 2

/*2. Cree una vista que liste la fecha, la factura, el código y nombre del vendedor, el
artículo, la cantidad e importe, para lo que va del año. Rotule como FECHA,
NRO_FACTURA, CODIGO_VENDEDOR, NOMBRE_VENDEDOR, ARTICULO,
CANTIDAD, IMPORTE.*/

CREATE VIEW VIS_PUNTO_DOS
AS
	SELECT F.fecha 'FECHA',F.nro_factura 'NRO_FACTURA',V.cod_vendedor 'CODIGO_VENDEDOR',
	V.ape_vendedor+', '+V.nom_vendedor 'NOMBRE_VENDEDOR',A.descripcion 'ARTICULO',
	DF.cantidad 'CANTIDAD', SUM(DF.pre_unitario*DF.cantidad) 'IMPORTE'
	FROM facturas F
	JOIN vendedores V ON V.cod_vendedor = F.cod_vendedor
	JOIN detalle_facturas DF ON DF.nro_factura = F.nro_factura
	JOIN articulos A ON A.cod_articulo = DF.cod_articulo
	WHERE DATEDIFF(YEAR,F.fecha,GETDATE())= 0
	GROUP BY F.fecha,F.nro_factura,V.cod_vendedor,
	V.ape_vendedor+', '+V.nom_vendedor,
	A.descripcion,DF.cantidad

--EJECUTO LA VISTA
SELECT *
FROM VIS_PUNTO_DOS
ORDER BY 'FECHA'

/*3. Modifique la vista creada en el punto anterior, agréguele la condición de que
solo tome el mes pasado (mes anterior al actual) y que también muestre la
dirección del vendedor.*/

ALTER VIEW VIS_PUNTO_DOS
AS
	SELECT F.fecha 'FECHA',F.nro_factura 'NRO_FACTURA',V.cod_vendedor 'CODIGO_VENDEDOR',
	V.ape_vendedor+', '+V.nom_vendedor 'NOMBRE_VENDEDOR',V.calle+STR(V.altura) 'DIRECCION VENDEDOR',
	A.descripcion 'ARTICULO', DF.cantidad 'CANTIDAD', SUM(DF.pre_unitario*DF.cantidad) 'IMPORTE'
	FROM facturas F
	JOIN vendedores V ON V.cod_vendedor = F.cod_vendedor
	JOIN detalle_facturas DF ON DF.nro_factura = F.nro_factura
	JOIN articulos A ON A.cod_articulo = DF.cod_articulo
	WHERE DATEDIFF(MONTH,F.fecha,GETDATE())= 1
	GROUP BY F.fecha,F.nro_factura,V.cod_vendedor,
	V.ape_vendedor+', '+V.nom_vendedor,V.calle+STR(V.altura),
	A.descripcion,DF.cantidad

--EJECUTO LA VISTA
SELECT *
FROM VIS_PUNTO_DOS
ORDER BY 'NOMBRE_VENDEDOR'

/*4. Consulta las vistas según el siguiente detalle:
a. Llame a la vista creada en el punto anterior pero filtrando por importes
inferiores a $120.
b. Llame a la vista creada en el punto anterior filtrando para el vendedor
Miranda.
c. Llama a la vista creada en el punto 4 filtrando para los importes
menores a 10.000.*/

--PUNTO A.
SELECT *
FROM VIS_PUNTO_DOS
WHERE IMPORTE < 120

--PUNTO B.
SELECT *
FROM VIS_PUNTO_DOS
WHERE NOMBRE_VENDEDOR LIKE 'MIRANDA%'

--PUNTO C.
SELECT *
FROM VIS_PUNTO_DOS
WHERE IMPORTE < 10000

/*5. Elimine las vistas creadas en el punto 3. */

DROP VIEW VIS_PUNTO_DOS