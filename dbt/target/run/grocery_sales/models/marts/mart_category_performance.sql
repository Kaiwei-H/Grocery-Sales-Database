
  
    

  create  table "grocery_sale"."public_mart"."mart_category_performance__dbt_tmp"
  
  
    as
  
  (
    -- -----------------------------------------------------
-- Category performance summary
-- Measures revenue contribution by product category
-- -----------------------------------------------------
select
    category_id,
    category_name,
    count(*) as transaction_count,
    sum(quantity) as units_sold,
    round(sum(gross_amount)::numeric, 2) as gross_revenue,
    round(sum(net_amount_estimated)::numeric, 2) as net_revenue,
    round(avg(discount)::numeric, 4) as avg_discount
from "grocery_sale"."public_analytics"."int_fact_sales"
group by
    category_id,
    category_name
  );
  