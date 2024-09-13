USE LIBRERIA

--CONSIGNAS

/*1. Confeccionar un listado de los clientes y los vendedores indicando a qué grupo
pertenece cada uno. */

SELECT C.ape_cliente+', '+C.nom_cliente 'NOMBRE COMPLETO',
'CLIENTE' TIPO
FROM clientes C
UNION
SELECT V.ape_vendedor+', '+V.nom_vendedor,
'VENDEDOR'
FROM vendedores V

/*2. Se quiere saber qué vendedores y clientes hay en la empresa; para los casos en
que su teléfono y dirección de e-mail sean conocidos. Se deberá visualizar el
código, nombre y si se trata de un cliente o de un vendedor. Ordene por la columna
tercera y segunda.*/

SELECT C.cod_cliente 'CODIGO', C.ape_cliente+', '+C.nom_cliente 'NOMBRE COMPLETO',
'CLIENTE' TIPO
FROM clientes C
WHERE C.nro_tel IS NOT NULL
AND C.[e-mail] IS NOT NULL
UNION
SELECT V.cod_vendedor, V.ape_vendedor+', '+V.nom_vendedor,
'VENDEDOR'
FROM vendedores V
WHERE V.nro_tel IS NOT NULL
AND V.[e-mail] IS NOT NULL
ORDER BY 3,2

/*3. Emitir un listado donde se muestren qué artículos, clientes y vendedores hay en
la empresa. Determine los campos a mostrar y su ordenamiento.*/

SELECT A.cod_articulo 'CODIGO', A.descripcion 'NOMBRE',
'ARTICULO' TIPO
FROM articulos A
UNION
SELECT C.cod_cliente, C.ape_cliente+', '+C.nom_cliente,
'CLIENTE'
FROM clientes C
UNION
SELECT V.cod_vendedor, V.ape_vendedor+', '+V.nom_vendedor,
'VENDEDOR'
FROM vendedores V
ORDER BY 3 DESC

/*4. Se quiere saber las direcciones (incluido el barrio) tanto de clientes como de
vendedores. Para el caso de los vendedores, códigos entre 3 y 12. En ambos casos
las direcciones deberán ser conocidas. Rotule como NOMBRE, DIRECCION,
BARRIO, INTEGRANTE (en donde indicará si es cliente o vendedor). Ordenado por
la primera y la última columna.*/

SELECT C.ape_cliente +', '+C.nom_cliente 'NOMBRE',
C.calle+STR(C.altura) 'DIRECCION', B.barrio 'BARRIO',
'CLIENTE' INTEGRANTE
FROM clientes C
JOIN barrios B ON C.cod_barrio = B.cod_barrio
WHERE C.calle IS NOT NULL
AND C.altura IS NOT NULL
UNION
SELECT V.ape_vendedor +', '+V.nom_vendedor,
V.calle+STR(V.altura),B.barrio, 'VENDEDOR'
FROM vendedores V
JOIN barrios B ON V.cod_barrio = B.cod_barrio
WHERE V.cod_vendedor BETWEEN 3 AND 12
AND V.calle IS NOT NULL
AND V.altura IS NOT NULL
ORDER BY 1, 4

/*5. Ídem al ejercicio anterior, sólo que además del código, identifique de donde
obtiene la información (de qué tabla se obtienen los datos).*/

SELECT C.cod_cliente'CODIGO',C.ape_cliente +', '+C.nom_cliente 'NOMBRE',
C.calle+STR(C.altura) 'DIRECCION', B.barrio 'BARRIO',
'CLIENTE' INTEGRANTE, 'CLIENTES' TABLA
FROM clientes C
JOIN barrios B ON C.cod_barrio = B.cod_barrio
WHERE C.calle IS NOT NULL
AND C.altura IS NOT NULL
UNION
SELECT V.cod_vendedor,V.ape_vendedor +', '+V.nom_vendedor,
V.calle+STR(V.altura),B.barrio, 'VENDEDOR', 'VENDEDORES'
FROM vendedores V
JOIN barrios B ON V.cod_barrio = B.cod_barrio
WHERE V.cod_vendedor BETWEEN 3 AND 12
AND V.calle IS NOT NULL
AND V.altura IS NOT NULL
ORDER BY 1, 6

/*6. Listar todos los artículos que están a la venta cuyo precio unitario oscile entre 10
y 50; también se quieren listar los artículos que fueron comprados por los clientes
cuyos apellidos comiencen con “M” o con “P”.*/

SELECT A.cod_articulo 'CODIGO', A.descripcion 'ARTICULO'
FROM articulos A
WHERE A.pre_unitario BETWEEN 10 AND 50
UNION
SELECT A.cod_articulo, A.descripcion
FROM articulos A
JOIN detalle_facturas DF ON DF.cod_articulo = A.cod_articulo
JOIN facturas F ON F.nro_factura = DF.nro_factura
JOIN clientes C ON C.cod_cliente = F.cod_cliente
WHERE C.ape_cliente LIKE '[M,P]%'

/*7. El encargado del negocio quiere saber cuánto fue la facturación del año pasado.
Por otro lado, cuánto es la facturación del mes pasado, la de este mes y la de hoy
(Cada pedido en una consulta distinta, y puede unirla en una sola tabla de
resultado)*/

SELECT SUM(DF.pre_unitario*DF.cantidad) 'FACTURACION',
'AÑO PASADO' CUANDO
FROM detalle_facturas DF
JOIN facturas F ON DF.nro_factura = F.nro_factura
WHERE DATEDIFF(YEAR,F.fecha,GETDATE())= 1
UNION
SELECT SUM(DF.pre_unitario*DF.cantidad),
'MES PASADO'
FROM detalle_facturas DF
JOIN facturas F ON DF.nro_factura = F.nro_factura
WHERE DATEDIFF(MONTH,F.fecha,GETDATE()) = 1
UNION 
SELECT SUM(DF.pre_unitario*DF.cantidad),
'ESTE MES'
FROM detalle_facturas DF
JOIN facturas F ON DF.nro_factura = F.nro_factura
WHERE DATEDIFF(MONTH,F.fecha,GETDATE()) = 0
UNION
SELECT SUM(DF.pre_unitario*DF.cantidad) 'FACTURACION',
'HOY' CUANDO
FROM detalle_facturas DF
JOIN facturas F ON DF.nro_factura = F.nro_factura
WHERE DATEDIFF(DAY,F.fecha,GETDATE()) = 0