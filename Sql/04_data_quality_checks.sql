-- =====================================================
-- Data Quality Checks
-- Basic validation of raw.sales before analysis
-- =====================================================


-- -----------------------------------------------------
-- Check total number of sales records
-- -----------------------------------------------------
SELECT COUNT(*)
FROM raw.sales;


-- -----------------------------------------------------
-- Check whether total_price contains zero values
-- Note: this helps determine whether source revenue
-- can be trusted or needs to be recalculated later
-- -----------------------------------------------------
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN total_price = 0 THEN 1 ELSE 0 END) AS zero_price_rows
FROM raw.sales;


-- -----------------------------------------------------
-- Check orphan product references in sales
-- Finds product_id values present in sales but missing
-- from the products table
-- -----------------------------------------------------
SELECT DISTINCT s.product_id
FROM raw.sales s
LEFT JOIN raw.products p
    ON s.product_id = p.product_id
WHERE p.product_id IS NULL;


-- -----------------------------------------------------
-- Check missing key fields in sales
-- Verifies whether customer_id or product_id is null
-- -----------------------------------------------------
SELECT
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS null_customer,
    COUNT(*) FILTER (WHERE product_id IS NULL) AS null_product
FROM raw.sales;