INSERT INTO raw.countries
SELECT * FROM public.countries;

INSERT INTO raw.cities
SELECT * FROM public.cities;

INSERT INTO raw.categories
SELECT * FROM public.categories;

INSERT INTO raw.customers
SELECT * FROM public.customers;

SELECT column_name
FROM information_schema.columns
WHERE table_schema = 'public'
AND table_name = 'products';


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
