-- -----------------------------------------------------
-- Customer performance analysis
-- Tracks customer purchasing behavior and lifetime value
-- -----------------------------------------------------
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
from "grocery_sale"."public_analytics"."int_fact_sales"
GROUP BY
    customer_id,
    customer_name,
    customer_city,
    customer_country