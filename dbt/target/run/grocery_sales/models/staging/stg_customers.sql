
  create view "grocery_sale"."public_staging"."stg_customers__dbt_tmp"
    
    
  as (
    select
    customer_id,
    first_name,
    middle_initial,
    last_name,
    concat(first_name, ' ', last_name) as full_name,
    city_id,
    address
from raw.customers
  );