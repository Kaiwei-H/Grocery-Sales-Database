-- =====================================================
-- MART ANALYSIS
-- Business analysis based on aggregated mart tables
-- =====================================================


-- -----------------------------------------------------
-- 1. Monthly sales overview
-- -----------------------------------------------------
SELECT
    sales_month,
    transaction_count,
    units_sold,
    gross_revenue,
    net_revenue,
    avg_transaction_value
FROM mart.sales_overview_monthly
ORDER BY sales_month;


-- -----------------------------------------------------
-- 2. Top 10 products by revenue
-- -----------------------------------------------------
SELECT
    product_id,
    product_name,
    category_name,
    units_sold,
    net_revenue,
    avg_discount
FROM mart.product_performance
ORDER BY net_revenue DESC
LIMIT 10;


-- -----------------------------------------------------
-- 3. Top 10 products by units sold
-- -----------------------------------------------------
SELECT
    product_id,
    product_name,
    category_name,
    units_sold,
    net_revenue
FROM mart.product_performance
ORDER BY units_sold DESC
LIMIT 10;


-- -----------------------------------------------------
-- 4. Category performance
-- -----------------------------------------------------
SELECT
    category_name,
    transaction_count,
    units_sold,
    net_revenue,
    avg_discount
FROM mart.category_performance
ORDER BY net_revenue DESC;


-- -----------------------------------------------------
-- 5. Category revenue contribution
-- Uses a window function to calculate revenue share
-- -----------------------------------------------------
SELECT
    category_name,
    net_revenue,
    ROUND(
        100.0 * net_revenue / SUM(net_revenue) OVER (),
        2
    ) AS revenue_pct
FROM mart.category_performance
ORDER BY net_revenue DESC;


-- -----------------------------------------------------
-- 6. Top 10 customers by revenue
-- -----------------------------------------------------
SELECT
    customer_id,
    customer_name,
    customer_city,
    customer_country,
    transaction_count,
    units_sold,
    net_revenue,
    first_purchase_date,
    last_purchase_date
FROM mart.customer_performance
ORDER BY net_revenue DESC
LIMIT 10;


-- -----------------------------------------------------
-- 7. Top customers by transaction count
-- -----------------------------------------------------
SELECT
    customer_id,
    customer_name,
    transaction_count,
    net_revenue
FROM mart.customer_performance
ORDER BY transaction_count DESC
LIMIT 10;


-- -----------------------------------------------------
-- 8. Salesperson performance by revenue
-- -----------------------------------------------------
SELECT
    salesperson_id,
    salesperson_name,
    salesperson_city,
    salesperson_country,
    transaction_count,
    units_sold,
    net_revenue
FROM mart.salesperson_performance
ORDER BY net_revenue DESC;


-- -----------------------------------------------------
-- 9. Average revenue per transaction by salesperson
-- -----------------------------------------------------
SELECT
    salesperson_id,
    salesperson_name,
    transaction_count,
    net_revenue,
    ROUND(net_revenue / NULLIF(transaction_count, 0), 2) AS avg_revenue_per_txn
FROM mart.salesperson_performance
ORDER BY avg_revenue_per_txn DESC;


-- -----------------------------------------------------
-- 10. Revenue by customer country
-- -----------------------------------------------------
SELECT
    customer_country,
    COUNT(*) AS customer_count,
    SUM(transaction_count) AS total_transactions,
    SUM(net_revenue) AS total_revenue
FROM mart.customer_performance
GROUP BY customer_country
ORDER BY total_revenue DESC;


-- -----------------------------------------------------
-- 11. Top 20 cities by revenue
-- -----------------------------------------------------
SELECT
    customer_city,
    customer_country,
    COUNT(*) AS customer_count,
    SUM(net_revenue) AS total_revenue
FROM mart.customer_performance
GROUP BY customer_city, customer_country
ORDER BY total_revenue DESC
LIMIT 20;


-- -----------------------------------------------------
-- 12. Discount vs no discount analysis
-- Uses fact-level data for detailed discount comparison
-- -----------------------------------------------------
SELECT
    CASE
        WHEN discount = 0 THEN 'no_discount'
        ELSE 'discounted'
    END AS discount_type,
    COUNT(*) AS transaction_count,
    SUM(quantity) AS units_sold,
    ROUND(SUM(net_amount_estimated)::numeric, 2) AS net_revenue,
    ROUND(AVG(net_amount_estimated)::numeric, 2) AS avg_transaction_value
FROM analytics.fact_sales
GROUP BY discount_type;


-- -----------------------------------------------------
-- 13. Revenue by discount band
-- -----------------------------------------------------
SELECT
    CASE
        WHEN discount = 0 THEN '0'
        WHEN discount > 0 AND discount <= 0.05 THEN '0-5%'
        WHEN discount > 0.05 AND discount <= 0.10 THEN '5-10%'
        ELSE '>10%'
    END AS discount_band,
    COUNT(*) AS transaction_count,
    ROUND(SUM(net_amount_estimated)::numeric, 2) AS net_revenue
FROM analytics.fact_sales
GROUP BY discount_band
ORDER BY discount_band;


-- -----------------------------------------------------
-- 14. Monthly revenue growth rate
-- Uses LAG() to compare with previous month
-- -----------------------------------------------------
SELECT
    sales_month,
    net_revenue,
    LAG(net_revenue) OVER (ORDER BY sales_month) AS prev_month_revenue,
    ROUND(
        100.0 * (net_revenue - LAG(net_revenue) OVER (ORDER BY sales_month))
        / NULLIF(LAG(net_revenue) OVER (ORDER BY sales_month), 0),
        2
    ) AS revenue_growth_pct
FROM mart.sales_overview_monthly
ORDER BY sales_month;


-- -----------------------------------------------------
-- 15. Product revenue rank within each category
-- -----------------------------------------------------
SELECT
    category_name,
    product_name,
    net_revenue,
    RANK() OVER (
        PARTITION BY category_name
        ORDER BY net_revenue DESC
    ) AS revenue_rank_in_category
FROM mart.product_performance
ORDER BY category_name, revenue_rank_in_category;


-- -----------------------------------------------------
-- 16. Top 3 products in each category
-- -----------------------------------------------------
WITH ranked_products AS (
    SELECT
        category_name,
        product_name,
        net_revenue,
        RANK() OVER (
            PARTITION BY category_name
            ORDER BY net_revenue DESC
        ) AS revenue_rank_in_category
    FROM mart.product_performance
)
SELECT *
FROM ranked_products
WHERE revenue_rank_in_category <= 3
ORDER BY category_name, revenue_rank_in_category;


-- -----------------------------------------------------
-- 17. Customer segmentation by revenue
-- -----------------------------------------------------
SELECT
    CASE
        WHEN net_revenue >= 5000 THEN 'high_value'
        WHEN net_revenue >= 2000 THEN 'mid_value'
        ELSE 'low_value'
    END AS customer_segment,
    COUNT(*) AS customer_count,
    ROUND(SUM(net_revenue)::numeric, 2) AS total_revenue,
    ROUND(AVG(net_revenue)::numeric, 2) AS avg_revenue_per_customer
FROM mart.customer_performance
GROUP BY customer_segment
ORDER BY total_revenue DESC;


-- -----------------------------------------------------
-- 18. Repeat customer rate
-- -----------------------------------------------------
SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN transaction_count > 1 THEN 1 ELSE 0 END) AS repeat_customers,
    ROUND(
        100.0 * SUM(CASE WHEN transaction_count > 1 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS repeat_customer_pct
FROM mart.customer_performance;