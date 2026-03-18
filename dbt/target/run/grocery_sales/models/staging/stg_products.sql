
  create view "grocery_sale"."public_staging"."stg_products__dbt_tmp"
    
    
  as (
    select
    product_id,
    product_name,
    price,
    category_id,
    class,
    modify_date,
    resistant,
    is_allergic,
    vitality_days
from raw.products
  );