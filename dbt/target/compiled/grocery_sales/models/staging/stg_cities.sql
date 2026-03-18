select
    ci.city_id,
    ci.city_name,
    ci.zipcode,
    ci.country_id,
    co.country_name,
    co.country_code
from raw.cities ci
left join raw.countries co
    on ci.country_id = co.country_id