-- =====================================================
-- MART LAYER
-- Aggregated tables built from analytics.fact_sales
-- These tables support business analysis and reporting
-- =====================================================

CREATE SCHEMA IF NOT EXISTS mart;


-- -----------------------------------------------------
-- Monthly sales overview
-- Tracks revenue and sales volume over time
-- -----------------------------------------------------
CREATE TABLE mart.sales_overview_monthly AS
SELECT
    sales_month,
    COUNT(*) AS transaction_count,
    SUM(quantity) AS units_sold,
    ROUND(SUM(gross_amount)::numeric, 2) AS gross_revenue,
    ROUND(SUM(net_amount_estimated)::numeric, 2) AS net_revenue,
    ROUND(AVG(net_amount_estimated)::numeric, 2) AS avg_transaction_value
FROM analytics.fact_sales
GROUP BY sales_month
ORDER BY sales_month;


-- -----------------------------------------------------
-- Product performance metrics
-- Evaluates product-level sales and discount behavior
-- -----------------------------------------------------
CREATE TABLE mart.product_performance AS
SELECT
    product_id,
    product_name,
    category_name,
    product_class,
    COUNT(*) AS transaction_count,
    SUM(quantity) AS units_sold,
    ROUND(SUM(gross_amount)::numeric, 2) AS gross_revenue,
    ROUND(SUM(net_amount_estimated)::numeric, 2) AS net_revenue,
    ROUND(AVG(discount)::numeric, 4) AS avg_discount
FROM analytics.fact_sales
GROUP BY
    product_id,
    product_name,
    category_name,
    product_class;


-- -----------------------------------------------------
-- Category performance summary
-- Measures revenue contribution by product category
-- -----------------------------------------------------
CREATE TABLE mart.category_performance AS
SELECT
    category_id,
    category_name,
    COUNT(*) AS transaction_count,
    SUM(quantity) AS units_sold,
    ROUND(SUM(gross_amount)::numeric, 2) AS gross_revenue,
    ROUND(SUM(net_amount_estimated)::numeric, 2) AS net_revenue,
    ROUND(AVG(discount)::numeric, 4) AS avg_discount
FROM analytics.fact_sales
GROUP BY
    category_id,
    category_name;


-- -----------------------------------------------------
-- Customer performance analysis
-- Tracks customer purchasing behavior and lifetime value
-- -----------------------------------------------------
CREATE TABLE mart.customer_performance AS
SELECT
    customer_id,
    customer_name,
    customer_city,
    customer_country,
    COUNT(*) AS transaction_count,
    SUM(quantity) AS units_sold,
    ROUND(SUM(net_amount_estimated)::numeric, 2) AS net_revenue,
    MIN(sales_date) AS first_purchase_date,
    MAX(sales_date) AS last_purchase_date
FROM analytics.fact_sales
GROUP BY
    customer_id,
    customer_name,
    customer_city,
    customer_country;


-- -----------------------------------------------------
-- Salesperson performance analysis
-- Evaluates sales contribution by employee
-- -----------------------------------------------------
CREATE TABLE mart.salesperson_performance AS
SELECT
    salesperson_id,
    salesperson_name,
    salesperson_city,
    salesperson_country,
    COUNT(*) AS transaction_count,
    SUM(quantity) AS units_sold,
    ROUND(SUM(net_amount_estimated)::numeric, 2) AS net_revenue,
    MIN(sales_date) AS first_sale_date,
    MAX(sales_date) AS last_sale_date
FROM analytics.fact_sales
GROUP BY
    salesperson_id,
    salesperson_name,
    salesperson_city,
    salesperson_country;
