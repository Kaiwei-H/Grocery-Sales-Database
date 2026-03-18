
  create view "grocery_sale"."public_staging"."stg_countries__dbt_tmp"
    
    
  as (
    SELECT
    country_id,
    country_name,
    country_code
FROM raw.countries
  );