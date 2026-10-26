--1. 

/* En este punto se evalúa el ingreso mínimo para definir la rentabilidad de las categorías.
El umbral se define en 50000 porque representa el nivel mìnimo que se debe facturar 
mennsualmente que se espera por cada categoria para sostener los costos operativos.*/
SELECT 
    c.nombre AS nombre_categoria,
    SUM(v.cantidad) AS unidades_vendidas,
    SUM(v.cantidad * p.precio) AS ingreso_total
FROM ventas v
INNER JOIN productos p ON v.id_producto = p.id_producto
INNER JOIN categorias c ON p.id_categoria = c.id_categoria
GROUP BY c.nombre
HAVING SUM(v.cantidad * p.precio) > 50000;

--2. 

/*En este punto se identifica los clientes sin compras*/

SELECT 
    c.id_cliente,
    c.nombre AS nombre_cliente,
    COALESCE(COUNT(v.id_venta), 0) AS total_compras
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
GROUP BY c.id_cliente, c.nombre
HAVING COALESCE(COUNT(v.id_venta), 0) = 0;

--3. 
/*Se detecta a los productos con màs compra por cliente y fecha de última compra*/
WITH ranking_compras AS (
    SELECT 
        c.id_cliente,
        c.nombre AS nombre_cliente,
        p.nombre_producto AS producto_mas_comprado,
        COUNT(v.id_venta) AS frecuencia_compras,
        MAX(v.fecha) AS ultima_transaccion,
        ROW_NUMBER() OVER (PARTITION BY c.id_cliente ORDER BY COUNT(v.id_venta) DESC) AS ranking
    FROM ventas v
    INNER JOIN clientes c ON v.id_cliente = c.id_cliente
    INNER JOIN productos p ON v.id_producto = p.id_producto
    GROUP BY c.id_cliente, c.nombre, p.id_producto, p.nombre_producto,v.fecha
)
SELECT 
    nombre_cliente,
    producto_mas_comprado,
    frecuencia_compras,
    ultima_transaccion
FROM ranking_compras
WHERE ranking = 1;
