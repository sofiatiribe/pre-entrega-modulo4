1. En este punto se evalúa el ingreso mínimo para definir la rentabilidad de las categorías.

SELECT 
    c.nombre AS nombre_categoria,
    SUM(v.cantidad) AS unidades_vendidas,
    SUM(v.cantidad * p.precio) AS ingreso_total
FROM ventas v
INNER JOIN productos p ON v.id_producto = p.id_producto
INNER JOIN categorias c ON p.id_categoria = c.id_categoria
GROUP BY c.nombre
HAVING SUM(v.cantidad * p.precio) > 50000;

2. En este punto se identifica los clientes sin compras. 

SELECT 
    c.id_cliente,
    c.nombre AS nombre_cliente,
    COALESCE(COUNT(v.id_venta), 0) AS total_compras
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
GROUP BY c.id_cliente, c.nombre
HAVING COALESCE(COUNT(v.id_venta), 0) = 0;

3. Se detecta a los clientes con màs compras
SELECT 
    c.nombre AS nombre_cliente,
    p.nombre_producto AS producto_comprado,
    SUM(v.cantidad) AS total_unidades,
    MAX(v.fecha) AS ultima_transaccion
FROM ventas v
INNER JOIN clientes c ON v.id_cliente = c.id_cliente
INNER JOIN productos p ON v.id_producto = p.id_producto
GROUP BY c.id_cliente, p.nombre_product, c.nombre, p.id_producto 
ORDER BY total_unidades DESC;