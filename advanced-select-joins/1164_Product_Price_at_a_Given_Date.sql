-- =========================================================
-- Problem: 1164. Product Price at a Given Date
-- Category: Subqueries / Aggregation / Join-Back Pattern
-- =========================================================
--
-- Core Query Logic:
-- For each product, find the price on a given date (2019-08-16).
--
-- Rules:
--   - If a product has price changes before or on given date,
--     return the most recent price.
--   - If no price change before that date,
--     default price = 10.
--
-- Steps:
--   1. Filter price records where change_date <= '2019-08-16'
--   2. For each product, find MAX(change_date)
--   3. Join back to get corresponding price
--   4. LEFT JOIN with all products to handle default case
--
-- Schema & Relationship Understanding:
-- Table: Products
--   product_id  (INT)
--   new_price   (INT)
--   change_date (DATE)
--
-- Multiple rows per product represent price changes over time.
--
-- Join Strategy Explanation:
-- Use subquery to get latest valid change per product.
-- LEFT JOIN ensures products with no prior changes
-- still appear with default price.
--
-- Time Complexity Consideration:
-- O(n) scan with grouping.
-- Performance depends on indexing.
--
-- Indexing & Performance Thoughts:
-- Recommended composite index:
--
-- CREATE INDEX idx_products_product_date
-- ON Products(product_id, change_date);
--
-- Helps with:
--   - Filtering by date
--   - MAX(change_date) per product
--   - Join back on product_id + change_date
--
-- Edge Case Handling:
-- - If no price before given date → price = 10.
-- - Ensure date comparison is index-friendly.
-- - Avoid applying functions to change_date.
--
-- Execution Order Reminder:
-- FROM → WHERE → GROUP BY → JOIN → SELECT
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT p.product_id,
       COALESCE(pr.new_price, 10) AS price
FROM (
    SELECT DISTINCT product_id
    FROM Products
) p
LEFT JOIN (
    SELECT product_id,
           new_price
    FROM Products pr1
    WHERE change_date = (
        SELECT MAX(change_date)
        FROM Products pr2
        WHERE pr2.product_id = pr1.product_id
          AND pr2.change_date <= '2019-08-16'
    )
) pr
ON p.product_id = pr.product_id;

-- =========================================================
-- GROUP BY Strategy Explanation
-- =========================================================
--
-- We first compute the latest price change before the target date:
--
--   SELECT product_id,
--          MAX(change_date)
--   FROM Products
--   WHERE change_date <= '2019-08-16'
--   GROUP BY product_id
--
-- This identifies the correct price version per product.
--
-- We then join back to the Products table to obtain new_price.
--
-- This pattern is known as the:
--
--   "Aggregation + Join Back"
--
-- pattern, commonly used to retrieve the latest record per group.

-- =========================================================
-- SQL Logical Execution Order
-- =========================================================
--
-- FROM (Products)
-- → WHERE (filter valid dates)
-- → GROUP BY (compute latest change_date)
-- → JOIN back to Products
-- → LEFT JOIN with product list
-- → SELECT price with COALESCE
--
--
-- =========================================================
-- Clean, Production-Ready SQL
-- =========================================================

SELECT p.product_id,
       COALESCE(pr.new_price, 10) AS price
FROM (SELECT DISTINCT product_id FROM Products) p
LEFT JOIN (
        SELECT product_id,
               MAX(change_date) AS latest_date
        FROM Products
        WHERE change_date <= '2019-08-16'
        GROUP BY product_id
) latest
ON p.product_id = latest.product_id
LEFT JOIN Products pr
ON pr.product_id = latest.product_id
AND pr.change_date = latest.latest_date;