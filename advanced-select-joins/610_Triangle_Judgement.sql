-- =========================================================
-- Problem: 610. Triangle Judgement
-- Category: Select / Conditional Logic
-- =========================================================
--
-- Core Query Logic:
-- Determine whether three sides can form a triangle.
--
-- Triangle inequality rule:
--   a + b > c
--   a + c > b
--   b + c > a
--
-- If all three conditions are satisfied → 'Yes'
-- Otherwise → 'No'
--
-- Schema & Relationship Understanding:
-- Table: Triangle
--   x (INT)
--   y (INT)
--   z (INT)
--
-- Each row represents three side lengths.
--
-- Join Strategy Explanation:
-- Not applicable (single-table validation).
--
-- Time Complexity Consideration:
-- O(n) simple scan.
-- Pure row-wise evaluation.
--
-- Indexing & Performance Thoughts:
-- Indexing unnecessary unless filtering by columns.
-- This is compute-bound, not lookup-bound.
--
-- Edge Case Handling:
-- - Assumes side lengths are positive integers.
-- - If zero or negative values exist,
--   triangle inequality automatically fails.
-- - No need for ABS unless input allows negatives.
--
-- Execution Order Reminder:
-- FROM → SELECT (CASE evaluation)
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT x,
       y,
       z,
       CASE
           WHEN x + y > z
            AND x + z > y
            AND y + z > x
           THEN 'Yes'
           ELSE 'No'
       END AS triangle
FROM Triangle;