-- =========================================================
-- Problem: 1068. Product Sales Analysis I
-- Category: Basic Joins
-- =========================================================
--
-- Core Query Logic:
-- Retrieve product_name, year, and price for each sale.
--
-- Sales table contains transactional data.
-- Product table contains product metadata.
--
-- We join Sales to Product using product_id.
--
-- Schema & Relationship Understanding:
-- Table: Sales
--   sale_id     (Primary Key)
--   product_id  (Foreign Key → Product.product_id)
--   year        (INT)
--   quantity    (INT)
--   price       (INT)
--
-- Table: Product
--   product_id  (Primary Key)
--   product_name (VARCHAR)
--
-- Relationship:
-- Many-to-one:
--   Many sales can reference one product.
--
-- Join Strategy Explanation:
-- INNER JOIN is appropriate because:
-- - Every sale must have a valid product_id.
-- - We only care about rows that exist in Sales.
--
-- Sales should drive the query.
--
-- Time Complexity Consideration:
-- O(n) relative to Sales table size.
-- Join cost depends on indexing.
--
-- Indexing & Performance Thoughts:
-- For efficient join performance:
--   - Product.product_id should be PRIMARY KEY.
--   - Sales.product_id should be indexed.
--
-- Example:
-- CREATE INDEX idx_sales_product
-- ON Sales(product_id);
--
-- This allows efficient lookup of product metadata.
--
-- Edge Case Handling:
-- - If orphaned product_id exists (bad data),
--   INNER JOIN will exclude those rows.
-- - Assumes referential integrity is maintained.
--
-- Execution Order Reminder:
-- FROM → JOIN → SELECT
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT p.product_name,
       s.year,
       s.price
FROM Sales s
INNER JOIN Product p
        ON s.product_id = p.product_id;