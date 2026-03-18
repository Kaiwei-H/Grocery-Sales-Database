-- -----------------------------------------------------
-- Monthly sales overview
-- Tracks revenue and sales volume over time
-- -----------------------------------------------------
select
    sales_month,
    count(*) as transaction_count,
    sum(quantity) as units_sold,
    round(sum(gross_amount)::numeric, 2) as gross_revenue,
    round(sum(net_amount_estimated)::numeric, 2) as net_revenue,
    round(avg(net_amount_estimated)::numeric, 2) as avg_transaction_value
from {{ ref('int_fact_sales') }}
group by sales_month