-- =========================================================
-- Problem: 1211. Queries Quality and Percentage
-- Category: Aggregation / Conditional Aggregation
-- =========================================================
--
-- Core Query Logic:
-- For each query_name compute:
--
-- 1. quality =
--      AVG(rating / position)
--
-- 2. poor_query_percentage =
--      (percentage of queries where rating < 3) * 100
--
-- Results must be rounded to 2 decimal places.
--
-- Schema & Relationship Understanding:
-- Table: Queries
--   query_name (VARCHAR)
--   result     (VARCHAR)
--   position   (INT)
--   rating     (INT)
--
-- Each row represents a result entry for a query.
--
-- Join Strategy Explanation:
-- Single-table aggregation. No joins required.
--
-- Time Complexity Consideration:
-- O(n) table scan.
-- GROUP BY query_name.
--
-- Indexing & Performance Thoughts:
-- If table is large:
--
-- CREATE INDEX idx_queries_name
-- ON Queries(query_name);
--
-- Aggregation performance improves with indexed grouping key.
--
-- Edge Case Handling:
-- - rating / position must use floating-point division.
-- - Avoid integer division.
-- - Ensure division by zero cannot occur (position assumed >= 1).
-- - poor_query_percentage must count only rating < 3.
-- - ROUND to 2 decimal places.
--
-- Execution Order Reminder:
-- FROM → GROUP BY → SELECT
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT query_name,
       ROUND(AVG(rating * 1.0 / position), 2) AS quality,
       ROUND(
           SUM(rating < 3) * 100.0 / COUNT(*),
           2
       ) AS poor_query_percentage
FROM Queries
GROUP BY query_name;