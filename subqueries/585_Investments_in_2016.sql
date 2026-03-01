-- =========================================================
-- Problem: 585. Investments in 2016
-- Category: Aggregation / Conditional Filtering
-- =========================================================
--
-- Core Query Logic:
-- Compute SUM(tiv_2016) for policyholders who:
--
--   1. Have duplicate tiv_2015 values (appear more than once)
--   2. Have unique (lat, lon) pair (location appears exactly once)
--
-- Steps:
--   1. Identify tiv_2015 values with COUNT(*) > 1
--   2. Identify (lat, lon) pairs with COUNT(*) = 1
--   3. Filter policies satisfying both conditions
--   4. SUM tiv_2016
--   5. ROUND to 2 decimal places
--
-- Schema & Relationship Understanding:
-- Table: Insurance
--   pid       (INT, Primary Key)
--   tiv_2015  (FLOAT)
--   tiv_2016  (FLOAT)
--   lat       (FLOAT)
--   lon       (FLOAT)
--
-- Each row represents one insurance policy.
--
-- Join Strategy Explanation:
-- No explicit joins required.
-- Use subqueries for filtering sets.
--
-- Time Complexity Consideration:
-- O(n) scan with grouping.
-- Two GROUP BY subqueries.
--
-- Indexing & Performance Thoughts:
-- Recommended indexes:
--
-- CREATE INDEX idx_insurance_tiv2015
-- ON Insurance(tiv_2015);
--
-- CREATE INDEX idx_insurance_location
-- ON Insurance(lat, lon);
--
-- Improves grouping performance.
--
-- Edge Case Handling:
-- - Floating point comparisons safe here (exact values given).
-- - Ensure grouping by BOTH lat and lon together.
-- - SUM must be rounded to 2 decimal places.
--
-- Execution Order Reminder:
-- FROM → WHERE (subqueries) → SELECT SUM
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT ROUND(SUM(tiv_2016), 2) AS tiv_2016
FROM Insurance
WHERE tiv_2015 IN (
          SELECT tiv_2015
          FROM Insurance
          GROUP BY tiv_2015
          HAVING COUNT(*) > 1
      )
  AND (lat, lon) IN (
          SELECT lat, lon
          FROM Insurance
          GROUP BY lat, lon
          HAVING COUNT(*) = 1
      );