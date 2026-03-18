-- -----------------------------------------------------
-- Product performance metrics
-- Evaluates product-level sales and discount behavior
-- -----------------------------------------------------
select
    product_id,
    product_name,
    category_name,
    product_class,
    count(*) as transaction_count,
    sum(quantity) as units_sold,
    round(sum(gross_amount)::numeric, 2) as gross_revenue,
    round(sum(net_amount_estimated)::numeric, 2) as net_revenue,
    round(avg(discount)::numeric, 4) as avg_discount
from {{ ref('int_fact_sales') }}
group by
    product_id,
    product_name,
    category_name,
    product_class