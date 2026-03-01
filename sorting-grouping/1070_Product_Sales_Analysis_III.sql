-- =========================================================
-- Problem: 1070. Product Sales Analysis III
-- Category: Subqueries / Aggregation
-- =========================================================
--
-- Core Query Logic:
-- For each product, retrieve:
--   - product_id
--   - first year the product was sold
--   - quantity sold in that first year
--   - price in that first year
--
-- Steps:
--   1. Identify first year per product (MIN(year))
--   2. Join back to Sales table
--   3. Retrieve quantity and price for that year
--
-- Schema & Relationship Understanding:
-- Table: Sales
--   sale_id    (Primary Key)
--   product_id (INT)
--   year       (INT)
--   quantity   (INT)
--   price      (INT)
--
-- Relationship:
-- Multiple sales rows may exist per product across years.
--
-- Join Strategy Explanation:
-- Use subquery to compute:
--   MIN(year) per product_id
--
-- Then INNER JOIN back to Sales
-- to fetch full row details.
--
-- Time Complexity Consideration:
-- O(n) scan with GROUP BY.
-- Join cost depends on indexing.
--
-- Indexing & Performance Thoughts:
-- Recommended index:
--
-- CREATE INDEX idx_sales_product_year
-- ON Sales(product_id, year);
--
-- This helps:
--   - MIN(year) grouping
--   - Join on (product_id, year)
--
-- Edge Case Handling:
-- - Assumes at least one sale per product.
-- - If multiple rows exist in same first year,
--   all will be returned (correct per problem statement).
-- - No aggregation of quantity required.
--
-- Execution Order Reminder:
-- FROM → GROUP BY (subquery) → JOIN → SELECT
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT s.product_id,
       s.year AS first_year,
       s.quantity,
       s.price
FROM Sales s
INNER JOIN (
    SELECT product_id,
           MIN(year) AS first_year
    FROM Sales
    GROUP BY product_id
) first_sales
  ON s.product_id = first_sales.product_id
 AND s.year = first_sales.first_year;