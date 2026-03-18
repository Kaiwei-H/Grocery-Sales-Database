
  create view "grocery_sale"."public_staging"."stg_customer_enriched__dbt_tmp"
    
    
  as (
    select
    cu.customer_id,
    cu.first_name,
    cu.middle_initial,
    cu.last_name,
    cu.full_name,
    cu.address,
    cu.city_id,
    ci.city_name,
    ci.country_id,
    ci.country_name
from "grocery_sale"."public_staging"."stg_customers" cu
left join "grocery_sale"."public_staging"."stg_city_enriched" ci
    on cu.city_id = ci.city_id
  );