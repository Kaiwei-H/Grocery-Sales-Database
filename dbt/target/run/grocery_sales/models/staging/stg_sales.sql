
  create view "grocery_sale"."public_staging"."stg_sales__dbt_tmp"
    
    
  as (
    select
    sales_id,
    salesperson_id,
    customer_id,
    product_id,
    quantity,
    discount,
    total_price,
    sales_date,
    transaction_number
from raw.sales
  );