-- =====================================================
-- Basic Analysis Queries
-- Initial business analysis based on analytics.fact_sales
-- =====================================================


-- -----------------------------------------------------
-- Overall sales summary
-- Measures total transactions, units sold and revenue
-- -----------------------------------------------------
SELECT
    COUNT(*) AS total_transactions,
    SUM(quantity) AS total_units,
    SUM(net_amount_estimated) AS revenue
FROM analytics.fact_sales;


-- -----------------------------------------------------
-- Monthly sales trend
-- Tracks revenue and sales volume over time
-- -----------------------------------------------------
SELECT
    sales_month,
    SUM(net_amount_estimated) AS revenue,
    SUM(quantity) AS units_sold
FROM analytics.fact_sales
GROUP BY sales_month
ORDER BY sales_month;


-- -----------------------------------------------------
-- Top 10 products by revenue
-- Identifies the best-performing products
-- -----------------------------------------------------
SELECT
    product_name,
    SUM(quantity) AS units_sold,
    SUM(net_amount_estimated) AS revenue
FROM analytics.fact_sales
GROUP BY product_name
ORDER BY revenue DESC
LIMIT 10;


-- -----------------------------------------------------
-- Top 10 customers by revenue
-- Highlights the highest-value customers
-- -----------------------------------------------------
SELECT
    customer_name,
    COUNT(*) AS orders,
    SUM(net_amount_estimated) AS revenue
FROM analytics.fact_sales
GROUP BY customer_name
ORDER BY revenue DESC
LIMIT 10;


-- -----------------------------------------------------
-- Salesperson performance
-- Compares revenue contribution by salesperson
-- -----------------------------------------------------
SELECT
    salesperson_name,
    COUNT(*) AS orders,
    SUM(net_amount_estimated) AS revenue
FROM analytics.fact_sales
GROUP BY salesperson_name
ORDER BY revenue DESC;