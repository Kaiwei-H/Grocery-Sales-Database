-- =====================================================
-- Analytics Layer
-- Transform raw tables into analysis-ready dimensions
-- and fact tables using views.
-- =====================================================


-- -----------------------------------------------------
-- Country dimension
-- -----------------------------------------------------
CREATE OR REPLACE VIEW analytics.dim_country AS
SELECT
    country_id,
    country_name,
    country_code
FROM raw.countries;


-- -----------------------------------------------------
-- City dimension (includes country information)
-- -----------------------------------------------------
CREATE OR REPLACE VIEW analytics.dim_city AS
SELECT
    ci.city_id,
    ci.city_name,
    ci.zipcode,
    ci.country_id,
    co.country_name,
    co.country_code
FROM raw.cities ci
LEFT JOIN raw.countries co
    ON ci.country_id = co.country_id;


-- -----------------------------------------------------
-- Customer dimension
-- Adds full name and geographic information
-- -----------------------------------------------------
CREATE OR REPLACE VIEW analytics.dim_customer AS
SELECT
    cu.customer_id,
    cu.first_name,
    cu.middle_initial,
    cu.last_name,
    CONCAT(cu.first_name, ' ', cu.last_name) AS full_name,
    cu.address,
    cu.city_id,
    ci.city_name,
    ci.country_id,
    ci.country_name
FROM raw.customers cu
LEFT JOIN analytics.dim_city ci
    ON cu.city_id = ci.city_id;


-- -----------------------------------------------------
-- Employee / salesperson dimension
-- -----------------------------------------------------
CREATE OR REPLACE VIEW analytics.dim_employee AS
SELECT
    e.employee_id,
    e.first_name,
    e.middle_initial,
    e.last_name,
    CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    e.birth_date,
    e.gender,
    e.city_id,
    ci.city_name,
    ci.country_id,
    ci.country_name,
    e.hire_date
FROM raw.employees e
LEFT JOIN analytics.dim_city ci
    ON e.city_id = ci.city_id;


-- -----------------------------------------------------
-- Category dimension
-- -----------------------------------------------------
CREATE OR REPLACE VIEW analytics.dim_category AS
SELECT
    category_id,
    category_name
FROM raw.categories;


-- -----------------------------------------------------
-- Product dimension
-- Adds category information
-- -----------------------------------------------------
CREATE OR REPLACE VIEW analytics.dim_product AS
SELECT
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
FROM raw.products p
LEFT JOIN raw.categories c
    ON p.category_id = c.category_id;


-- -----------------------------------------------------
-- Sales fact table
-- Recalculates revenue because total_price is unreliable
-- -----------------------------------------------------
CREATE OR REPLACE VIEW analytics.fact_sales AS
SELECT
    s.sales_id,
    s.transaction_number,
    s.sales_date,
    DATE(s.sales_date) AS sales_day,
    DATE_TRUNC('month', s.sales_date) AS sales_month,
    s.salesperson_id,
    e.full_name AS salesperson_name,
    e.gender AS salesperson_gender,
    e.city_name AS salesperson_city,
    e.country_name AS salesperson_country,
    s.customer_id,
    cu.full_name AS customer_name,
    cu.city_name AS customer_city,
    cu.country_name AS customer_country,
    s.product_id,
    p.product_name,
    p.category_id,
    p.category_name,
    p.class AS product_class,
    p.resistant,
    p.is_allergic,
    p.vitality_days,
    s.quantity,
    s.discount,
    s.total_price,
    p.price AS unit_price,
    -- recalculated revenue
    (s.quantity * p.price) AS gross_amount,
    (s.quantity * p.price) * (1 - s.discount) AS net_amount_estimated
FROM raw.sales s
LEFT JOIN analytics.dim_employee e
    ON s.salesperson_id = e.employee_id
LEFT JOIN analytics.dim_customer cu
    ON s.customer_id = cu.customer_id
LEFT JOIN analytics.dim_product p
    ON s.product_id = p.product_id;
