-- -----------------------------------------------------
-- Salesperson performance analysis
-- Evaluates sales contribution by employee
-- -----------------------------------------------------
select
    salesperson_id,
    salesperson_name,
    salesperson_city,
    salesperson_country,
    count(*) as transaction_count,
    sum(quantity) as units_sold,
    round(sum(net_amount_estimated)::numeric, 2) as net_revenue,
    min(sales_date) as first_sale_date,
    max(sales_date) as last_sale_date
from {{ ref('int_fact_sales') }}
group by
    salesperson_id,
    salesperson_name,
    salesperson_city,
    salesperson_country