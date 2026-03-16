-- =====================================================
-- Data Ingestion: public → raw
-- Transfer imported source tables into the raw schema.
-- Some fields require type conversion and basic cleaning.
-- =====================================================


-- -----------------------------------------------------
-- Direct table transfers (structure already compatible)
-- -----------------------------------------------------

INSERT INTO raw.countries
SELECT * FROM public.countries;

INSERT INTO raw.cities
SELECT * FROM public.cities;

INSERT INTO raw.categories
SELECT * FROM public.categories;

INSERT INTO raw.customers
SELECT * FROM public.customers;


-- -----------------------------------------------------
-- Inspect column structure of the products table
-- (used to verify original column naming)
-- -----------------------------------------------------

SELECT column_name
FROM information_schema.columns
WHERE table_schema = 'public'
AND table_name = 'products';


-- -----------------------------------------------------
-- Employees data transfer
-- Convert text-based date fields to TIMESTAMP
-- -----------------------------------------------------

INSERT INTO raw.employees (
    employee_id,
    first_name,
    middle_initial,
    last_name,
    birth_date,
    gender,
    city_id,
    hire_date
)
SELECT
    "EmployeeID",
    "FirstName",
    "MiddleInitial",
    "LastName",
    "BirthDate"::timestamp,
    "Gender",
    "CityID",
    "HireDate"::timestamp
FROM public.employees;


-- -----------------------------------------------------
-- Products data transfer
-- Clean numeric and timestamp fields using NULLIF
-- to handle empty strings
-- -----------------------------------------------------

INSERT INTO raw.products (
    product_id,
    product_name,
    price,
    category_id,
    class,
    modify_date,
    resistant,
    is_allergic,
    vitality_days
)
SELECT
    "ProductID",
    "ProductName",
    NULLIF(TRIM("Price"::text), '')::numeric,
    "CategoryID",
    "Class",
    NULLIF(TRIM("ModifyDate"::text), '')::timestamp,
    "Resistant",
    "IsAllergic",
    NULLIF(TRIM("VitalityDays"::text), '')::numeric
FROM public.products;


-- -----------------------------------------------------
-- Sales data transfer
-- Handle empty values and convert types
-- -----------------------------------------------------

INSERT INTO raw.sales (
    sales_id,
    salesperson_id,
    customer_id,
    product_id,
    quantity,
    discount,
    total_price,
    sales_date,
    transaction_number
)
SELECT
    "SalesID",
    "SalesPersonID",
    "CustomerID",
    "ProductID",
    NULLIF("Quantity"::text, '')::int,
    NULLIF("Discount"::text, '')::numeric,
    NULLIF("TotalPrice"::text, '')::numeric,
    NULLIF("SalesDate"::text, '')::timestamp,
    "TransactionNumber"
FROM public.sales;
