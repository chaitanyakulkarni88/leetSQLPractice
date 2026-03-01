-- =========================================================
-- Problem: 619. Biggest Single Number
-- Category: Aggregation
-- =========================================================
--
-- Core Query Logic:
-- Find the largest number that appears exactly once.
--
-- Steps:
--   1. GROUP BY num
--   2. Keep only numbers with COUNT(*) = 1
--   3. Return MAX(num) from that filtered set
--
-- Schema & Relationship Understanding:
-- Table: MyNumbers
--   num (INT)
--
-- Each row represents a number.
-- Duplicate numbers may exist.
--
-- Join Strategy Explanation:
-- Not applicable (single-table aggregation).
--
-- Time Complexity Consideration:
-- O(n) table scan.
-- GROUP BY required.
-- MAX computed on filtered result.
--
-- Indexing & Performance Thoughts:
-- Recommended index:
--
-- CREATE INDEX idx_mynumbers_num
-- ON MyNumbers(num);
--
-- Improves grouping efficiency.
--
-- Edge Case Handling:
-- - If no number appears exactly once,
--   return NULL.
-- - MAX over empty result returns NULL automatically.
-- - COUNT(*) is correct unless duplicates must be deduplicated
--   (problem assumes raw duplicates are meaningful).
--
-- Execution Order Reminder:
-- FROM → GROUP BY → HAVING → SELECT (outer MAX)
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT MAX(num) AS num
FROM (
    SELECT num
    FROM MyNumbers
    GROUP BY num
    HAVING COUNT(*) = 1
) AS single_numbers;