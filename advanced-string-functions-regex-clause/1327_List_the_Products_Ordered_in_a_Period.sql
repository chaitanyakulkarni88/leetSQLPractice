-- =========================================================
-- Problem: 1327. List the Products Ordered in a Period
-- Category: Basic Joins / Aggregation / Date Filtering
-- =========================================================
--
-- Core Query Logic:
-- Retrieve products that:
--   - Were ordered in February 2020
--   - Total ordered quantity >= 100
--
-- Steps:
--   1. Join Orders and Products
--   2. Filter by date range (Feb 2020)
--   3. GROUP BY product
--   4. SUM(unit)
--   5. HAVING SUM(unit) >= 100
--
-- Schema & Relationship Understanding:
-- Table: Products
--   product_id   (INT, Primary Key)
--   product_name (VARCHAR)
--
-- Table: Orders
--   product_id (INT, FK → Products.product_id)
--   order_date (DATE)
--   unit       (INT)
--
-- Relationship:
--   One product → many orders
--
-- Join Strategy Explanation:
-- INNER JOIN is correct:
--   - Only products with orders in the period are relevant.
--
-- Time Complexity Consideration:
-- O(n) scan on Orders with grouping.
--
-- Indexing & Performance Thoughts:
-- Recommended indexes:
--
-- CREATE INDEX idx_orders_date_product
-- ON Orders(order_date, product_id);
--
-- CREATE INDEX idx_orders_product
-- ON Orders(product_id);
--
-- Date filtering must avoid functions to preserve index usage.
--
-- Edge Case Handling:
-- - Use date range instead of MONTH() to ensure index use.
-- - SUM handles multiple orders per product.
-- - Only products meeting threshold returned.
--
-- Execution Order Reminder:
-- FROM → JOIN → WHERE → GROUP BY → HAVING → SELECT
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT p.product_name,
       SUM(o.unit) AS unit
FROM Orders o
JOIN Products p
  ON o.product_id = p.product_id
WHERE o.order_date >= '2020-02-01'
  AND o.order_date <  '2020-03-01'
GROUP BY p.product_id, p.product_name
HAVING SUM(o.unit) >= 100;