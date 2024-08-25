USE LIBRERIA

-- RESOLUCIÓN

/*1. Se necesita saber a qué cliente se les vendió y qué vendedor realizó la venta
en qué fecha y cuál fue el número de factura de los años 2010, 2017, 2018 y
2022.*/

SELECT C.ape_cliente +', '+C.nom_cliente 'Cliente',
V.ape_vendedor +', '+V.nom_vendedor 'Vendedor',
F.fecha 'Fecha',
F.nro_factura 'Número de factura'
FROM clientes C
JOIN facturas F ON F.cod_cliente = C.cod_cliente
JOIN vendedores V ON F.cod_vendedor = V.cod_vendedor
WHERE YEAR(F.fecha) IN (2010,2017,2018,2022)
ORDER BY 'Cliente'

/*2. Emitir un reporte con los datos de todos los vendedores Si el vendedor ha
tenido ventas en lo que va del año, muestre, además, el número de factura y
la fecha de esas ventas.*/

SELECT V.ape_vendedor +', '+V.nom_vendedor 'VENDEDOR',
F.nro_factura 'NÚMERO DE FACTURA',
F.fecha 'FECHA VENTA'
FROM vendedores V
LEFT JOIN facturas F ON F.cod_vendedor = V.cod_vendedor
WHERE DATEDIFF(YEAR,F.fecha,GETDATE()) = 0
OR F.fecha IS NULL
ORDER BY 1

/*3. Generar un listado con los datos de las facturas incluidos los del vendedor y
cliente) y de las ventas de esas facturas, incluido el importe; para las ventas
de febrero y marzo de los años 2016 y 2020 y siempre que el artículo empiece
con letras que van de la “a” a la “m”. Mostrar la fecha de la factura en orden
día, mes y año, sin la hora.*/

SELECT F.nro_factura 'NÚMERO FACTURA',
V.ape_vendedor +', '+V.nom_vendedor 'VENDEDOR',
C.ape_cliente +', '+C.nom_cliente 'CLIENTE',
(DF.pre_unitario * DF.cantidad) 'IMPORTE',
A.descripcion 'ARTICULO',
STR(day(F.fecha))+'/'+STR(month(F.fecha))+'/'+STR(year(F.fecha)) 'FECHA' --eL STR() TIENE ESPACIOS AL USARLA
FROM facturas F
JOIN vendedores V ON V.cod_vendedor = F.cod_vendedor
JOIN clientes C ON C.cod_cliente = F.cod_cliente
JOIN detalle_facturas DF ON DF.nro_factura = F.nro_factura
JOIN articulos A ON A.cod_articulo = DF.cod_articulo
WHERE MONTH(F.fecha) IN (2,3)
AND YEAR(F.fecha) IN (2016, 2020)
AND A.descripcion LIKE '[A-M]%'
ORDER BY 'FECHA' --Me falta sacarle la hora a la fecha.

/*4. Se necesita mostrar el código, nombre, apellido y dirección completa en una
sola columna de los clientes cuyo nombre comience con “C” y cuyo apellido
termine con “Z” que fueron atendidos por vendedores que viven en barrios
cuyos nombres no contienen letras que van de la “N” a la “P” o bien clientes
cuyo de telefono o e-mail sean conocidos atendidos por vendedores de más
de 50 años de edad que viven en calles con nombres que tienen más de 5
letras.*/

SELECT STR(C.cod_cliente)+', '+C.nom_cliente+', '+ C.ape_cliente +', '+ 
C.calle+' '+STR(C.altura)+', '+B.barrio 'DATOS CLIENTE'
FROM facturas F
JOIN clientes C ON C.cod_cliente = F.cod_cliente
JOIN vendedores V ON V.cod_vendedor = F.cod_vendedor
JOIN barrios B ON B.cod_barrio = V.cod_barrio
WHERE C.nom_cliente LIKE '[C]%'
AND C.ape_cliente LIKE '%[Z]'
AND B.barrio NOT LIKE '[N-P]' -- CONTROLAR ESTE PUNTO
AND (C.[e-mail] IS NULL OR C.nro_tel IS NULL)
AND DATEDIFF(YEAR,V.fec_nac,GETDATE()) > 50
AND LEN(V.calle) > 5


/*5. Muestre los datos de los vendedores, cuyo cumpleaños sea el mes que viene
(mes siguiente al actual), haya nacido en la década del 90 y que haya realizado
ventas el mes pasado.*/

SELECT  V.ape_vendedor +', '+V.nom_vendedor 'VENDEDOR',
V.fec_nac 'FECHA DE CUMPLEAÑOS', F.fecha 'FECHAS DE VENTA'
FROM vendedores V
JOIN facturas F ON F.cod_vendedor = V.cod_vendedor
WHERE MONTH(V.fec_nac) = MONTH(GETDATE())+2
AND YEAR(V.fec_nac) BETWEEN 1990 AND 1999
AND MONTH(F.FECHA) = MONTH(GETDATE())-1
AND YEAR(F.fecha) = YEAR(GETDATE())

/*6. Listar los datos de los artículos vendidos del 1 al 10 de cada mes dentro del
año en curso cuyo precio al que fue vendido sea menor al precio actual, que
tenga observaciones conocidas, y que estén en el momento de reposición
(stock mínimo menor o igual al stock actual.*/

SELECT A.descripcion 'ARTICULO',F.fecha 'FECHA',
A.stock_minimo 'STOCK MINIMO', A.stock 'STOCK ACTUAL'
FROM articulos A
JOIN detalle_facturas DF ON DF.cod_articulo = A.cod_articulo
JOIN facturas F ON F.nro_factura = DF.nro_factura
WHERE DAY(F.fecha) BETWEEN 1 AND 10
AND DATEDIFF(YEAR,F.fecha,GETDATE()) = 0
AND DF.pre_unitario < A.pre_unitario
AND A.observaciones IS NOT NULL
AND A.stock_minimo >= A.stock

/*7. Listar todos los datos de los artículos cuyo stock mínimo sea superior a 10 o
cuyo precio sea inferior a 20. En ambos casos su descripción no debe
comenzar con las letras “p”, “r” ni “v”, ni contener “h”, “j” ni “m”.*/

/*8. Se quiere saber qué artículos se vendieron, siempre que el precio unitario sin
iva al que fue vendido no esté entre $100 y $500 y que las ventas hayan sido
realizadas por vendedores nacidos en febrero, abril, mayo o septiembre.*/

/*9. Emitir un reporte para informar qué artículos se vendieron, en las facturas
cuyos números no estén entre 17 y 136. Liste la descripción, cantidad e
importe (Importe=cantidad*pre_unitario). Ordenar por descripción y cantidad.
No muestre las filas con valores duplicados. */

/*10. Emitir un reporte de artículos vendidos en el 2021 a menos de $ 300 por
vendedores hayan sido menor de 35 años, a qué precios se vendieron y qué
precio tienen hoy. Mostrar el porcentaje de incremento.*/