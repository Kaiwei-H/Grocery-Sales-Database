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
from {{ ref('stg_customers') }} cu
left join {{ ref('stg_city_enriched') }} ci
    on cu.city_id = ci.city_id