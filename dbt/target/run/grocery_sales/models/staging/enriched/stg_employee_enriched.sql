
  create view "grocery_sale"."public_staging"."stg_employee_enriched__dbt_tmp"
    
    
  as (
    select
    e.employee_id,
    e.first_name,
    e.middle_initial,
    e.last_name,
    concat(e.first_name, ' ', e.last_name) as full_name,
    e.birth_date,
    e.gender,
    e.city_id,
    ci.city_name,
    ci.country_id,
    ci.country_name,
    e.hire_date
from "grocery_sale"."public_staging"."stg_employees" e
left join "grocery_sale"."public_staging"."stg_city_enriched" ci
    on e.city_id = ci.city_id
  );