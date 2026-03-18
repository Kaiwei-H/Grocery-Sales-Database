select
    ci.city_id,
    ci.city_name,
    ci.zipcode,
    ci.country_id,
    co.country_name,
    co.country_code
from {{ ref('stg_cities') }} ci
left join {{ ref('stg_countries') }} co
    on ci.country_id = co.country_id