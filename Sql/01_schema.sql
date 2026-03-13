CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS analytics;

CREATE TABLE IF NOT EXISTS raw.countries (
    country_id   INT PRIMARY KEY,
    country_name VARCHAR(100),
    country_code VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS raw.cities (
    city_id      INT PRIMARY KEY,
    city_name    VARCHAR(100),
    zipcode      VARCHAR(20),
    country_id   INT
);

CREATE TABLE IF NOT EXISTS raw.customers (
    customer_id     INT PRIMARY KEY,
    first_name      VARCHAR(100),
    middle_initial  VARCHAR(10),
    last_name       VARCHAR(100),
    city_id         INT,
    address         VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS raw.employees (
    employee_id     INT PRIMARY KEY,
    first_name      VARCHAR(100),
    middle_initial  VARCHAR(10),
    last_name       VARCHAR(100),
    birth_date      TIMESTAMP,
    gender          VARCHAR(10),
    city_id         INT,
    hire_date       TIMESTAMP
);

CREATE TABLE IF NOT EXISTS raw.categories (
    category_id    INT PRIMARY KEY,
    category_name  VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS raw.products (
    product_id      INT PRIMARY KEY,
    product_name    VARCHAR(255),
    price           NUMERIC(12,4),
    category_id     INT,
    class           VARCHAR(50),
    modify_date     TIMESTAMP,
    resistant       VARCHAR(50),
    is_allergic     VARCHAR(50),
    vitality_days   NUMERIC(10,2)
);

CREATE TABLE IF NOT EXISTS raw.sales (
    sales_id             INT PRIMARY KEY,
    salesperson_id       INT,
    customer_id          INT,
    product_id           INT,
    quantity             INT,
    discount             NUMERIC(10,4),
    total_price          NUMERIC(12,4),
    sales_date           TIMESTAMP,
    transaction_number   VARCHAR(50)
);

ALTER TABLE raw.cities
ADD CONSTRAINT fk_cities_country
FOREIGN KEY (country_id) REFERENCES raw.countries(country_id);

ALTER TABLE raw.customers
ADD CONSTRAINT fk_customers_city
FOREIGN KEY (city_id) REFERENCES raw.cities(city_id);

ALTER TABLE raw.employees
ADD CONSTRAINT fk_employees_city
FOREIGN KEY (city_id) REFERENCES raw.cities(city_id);

ALTER TABLE raw.products
ADD CONSTRAINT fk_products_category
FOREIGN KEY (category_id) REFERENCES raw.categories(category_id);

ALTER TABLE raw.sales
ADD CONSTRAINT fk_sales_employee
FOREIGN KEY (salesperson_id) REFERENCES raw.employees(employee_id);

ALTER TABLE raw.sales
ADD CONSTRAINT fk_sales_customer
FOREIGN KEY (customer_id) REFERENCES raw.customers(customer_id);

ALTER TABLE raw.sales
ADD CONSTRAINT fk_sales_product
FOREIGN KEY (product_id) REFERENCES raw.products(product_id);

CREATE INDEX IF NOT EXISTS idx_cities_country_id
ON raw.cities(country_id);

CREATE INDEX IF NOT EXISTS idx_customers_city_id
ON raw.customers(city_id);

CREATE INDEX IF NOT EXISTS idx_employees_city_id
ON raw.employees(city_id);

CREATE INDEX IF NOT EXISTS idx_products_category_id
ON raw.products(category_id);

CREATE INDEX IF NOT EXISTS idx_sales_salesperson_id
ON raw.sales(salesperson_id);

CREATE INDEX IF NOT EXISTS idx_sales_customer_id
ON raw.sales(customer_id);

CREATE INDEX IF NOT EXISTS idx_sales_product_id
ON raw.sales(product_id);

CREATE INDEX IF NOT EXISTS idx_sales_sales_date
ON raw.sales(sales_date);

SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_schema='raw';
