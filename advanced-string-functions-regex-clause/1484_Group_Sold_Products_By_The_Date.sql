-- =========================================================
-- Problem: 1484. Group Sold Products By The Date
-- Category: Aggregation / String Aggregation
-- =========================================================
--
-- Core Query Logic:
-- For each sell_date:
--   1. Count number of DISTINCT products sold
--   2. Return products as a comma-separated list
--      sorted lexicographically
--
-- Steps:
--   1. GROUP BY sell_date
--   2. COUNT(DISTINCT product)
--   3. GROUP_CONCAT(DISTINCT product ORDER BY product)
--
-- Schema & Relationship Understanding:
-- Table: Activities
--   sell_date (DATE)
--   product   (VARCHAR)
--
-- Multiple rows may exist for same product on same day.
--
-- Join Strategy Explanation:
-- Not applicable (single-table aggregation).
--
-- Time Complexity Consideration:
-- O(n log n) due to grouping and ordering inside GROUP_CONCAT.
--
-- Indexing & Performance Thoughts:
-- Recommended index:
--
-- CREATE INDEX idx_activities_date_product
-- ON Activities(sell_date, product);
--
-- Improves grouping and distinct handling.
--
-- Edge Case Handling:
-- - Duplicate product entries on same date must not inflate count.
-- - Products must be sorted lexicographically.
-- - GROUP_CONCAT has size limit (MySQL default 1024).
--
-- Execution Order Reminder:
-- FROM → GROUP BY → SELECT → ORDER BY
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT sell_date,
       COUNT(DISTINCT product) AS num_sold,
       GROUP_CONCAT(
           DISTINCT product
           ORDER BY product
           SEPARATOR ','
       ) AS products
FROM Activities
GROUP BY sell_date
ORDER BY sell_date;