SELECT
    COUNT(*) AS total_transactions,
    SUM(quantity) AS total_units,
    SUM(net_amount_estimated) AS revenue
FROM analytics.fact_sales;

SELECT
    sales_month,
    SUM(net_amount_estimated) AS revenue,
    SUM(quantity) AS units_sold
FROM analytics.fact_sales
GROUP BY sales_month
ORDER BY sales_month;

SELECT
    product_name,
    SUM(quantity) AS units_sold,
    SUM(net_amount_estimated) AS revenue
FROM analytics.fact_sales
GROUP BY product_name
ORDER BY revenue DESC
LIMIT 10;

SELECT
    customer_name,
    COUNT(*) AS orders,
    SUM(net_amount_estimated) AS revenue
FROM analytics.fact_sales
GROUP BY customer_name
ORDER BY revenue DESC
LIMIT 10;

SELECT
    salesperson_name,
    COUNT(*) AS orders,
    SUM(net_amount_estimated) AS revenue
FROM analytics.fact_sales
GROUP BY salesperson_name
ORDER BY revenue DESC;