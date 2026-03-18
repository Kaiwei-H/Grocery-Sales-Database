select
    p.product_id,
    p.product_name,
    p.price,
    p.category_id,
    c.category_name,
    p.class,
    p.modify_date,
    p.resistant,
    p.is_allergic,
    p.vitality_days
from {{ ref('stg_products') }} p
left join {{ ref('stg_categories') }} c
    on p.category_id = c.category_id