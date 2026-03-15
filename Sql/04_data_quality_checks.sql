SELECT COUNT(*) 
FROM raw.sales;

SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN total_price = 0 THEN 1 ELSE 0 END) AS zero_price_rows
FROM raw.sales;/*zeros price rows = 0*/

SELECT DISTINCT s.product_id
FROM raw.sales s
LEFT JOIN raw.products p
ON s.product_id = p.product_id
WHERE p.product_id IS NULL;

SELECT
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS null_customer,
    COUNT(*) FILTER (WHERE product_id IS NULL) AS null_product
FROM raw.sales;

