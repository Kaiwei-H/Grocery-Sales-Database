select
    s.sales_id,
    s.transaction_number,
    s.sales_date,
    date(s.sales_date) as sales_day,
    date_trunc('month', s.sales_date) as sales_month,

    s.salesperson_id,
    e.full_name as salesperson_name,
    e.gender as salesperson_gender,
    e.city_name as salesperson_city,
    e.country_name as salesperson_country,

    s.customer_id,
    c.full_name as customer_name,
    c.city_name as customer_city,
    c.country_name as customer_country,

    s.product_id,
    p.product_name,
    p.category_id,
    p.category_name,
    p.class as product_class,
    p.resistant,
    p.is_allergic,
    p.vitality_days,

    s.quantity,
    s.discount,
    s.total_price,
    p.price as unit_price,

    (s.quantity * p.price) as gross_amount,
    (s.quantity * p.price) * (1 - s.discount) as net_amount_estimated
from "grocery_sale"."public_staging"."stg_sales" s
left join "grocery_sale"."public_staging"."stg_employee_enriched" e
    on s.salesperson_id = e.employee_id
left join "grocery_sale"."public_staging"."stg_customer_enriched" c
    on s.customer_id = c.customer_id
left join "grocery_sale"."public_staging"."stg_product_enriched" p
    on s.product_id = p.product_id