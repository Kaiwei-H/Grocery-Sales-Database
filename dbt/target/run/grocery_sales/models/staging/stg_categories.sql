
  create view "grocery_sale"."public_staging"."stg_categories__dbt_tmp"
    
    
  as (
    select
    category_id,
    category_name
from raw.categories
  );