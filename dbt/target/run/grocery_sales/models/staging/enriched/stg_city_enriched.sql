
  create view "grocery_sale"."public_staging"."stg_city_enriched__dbt_tmp"
    
    
  as (
    select
    ci.city_id,
    ci.city_name,
    ci.zipcode,
    ci.country_id,
    co.country_name,
    co.country_code
from "grocery_sale"."public_staging"."stg_cities" ci
left join "grocery_sale"."public_staging"."stg_countries" co
    on ci.country_id = co.country_id
  );