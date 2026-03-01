-- =========================================================
-- Problem: 1757. Recyclable and Low Fat Products
-- Category: Select
-- =========================================================
--
-- Core Query Logic:
-- Retrieve product_id for products that are BOTH low fat
-- and recyclable using a simple WHERE filter.
--
-- Schema & Relationship Understanding:
-- Table: Products
-- Columns:
--   product_id (Primary Key)
--   low_fats    (ENUM: 'Y' / 'N')
--   recyclable  (ENUM: 'Y' / 'N')
--
-- Single-table query. No joins involved.
--
-- Join Strategy Explanation:
-- Not applicable (single table).
--
-- Time Complexity Consideration:
-- O(n) table scan without indexing.
-- Can be optimized with proper indexing.
--
-- Indexing & Performance Thoughts:
-- In production, a composite index on:
--   (low_fats, recyclable)
-- can significantly improve filtering performance.
--
-- Example:
-- CREATE INDEX idx_products_flags
-- ON Products(low_fats, recyclable);
--
-- Edge Case Handling:
-- - Assumes values are constrained to 'Y' or 'N'.
-- - NULL values are implicitly excluded by equality checks.
-- - Query avoids unnecessary conditions to preserve clarity.
--
-- Execution Order Reminder:
-- FROM → WHERE → SELECT
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT product_id
FROM Products
WHERE low_fats = 'Y'
  AND recyclable = 'Y'
  AND low_fats IS NOT NULL
  AND recyclable IS NOT NULL;