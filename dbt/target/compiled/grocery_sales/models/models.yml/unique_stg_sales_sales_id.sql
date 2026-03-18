
    
    

select
    sales_id as unique_field,
    count(*) as n_records

from "grocery_sale"."public_staging"."stg_sales"
where sales_id is not null
group by sales_id
having count(*) > 1


