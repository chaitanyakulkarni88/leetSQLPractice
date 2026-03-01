-- =========================================================
-- Problem: 180. Consecutive Numbers
-- Category: Advanced Select and Joins / Window Functions
-- =========================================================
--
-- Core Query Logic:
-- Find numbers that appear at least three times consecutively
-- based on increasing id order.
--
-- Steps:
--   1. Self-join table three times
--   2. Match consecutive ids:
--        l1.id = l2.id - 1
--        l2.id = l3.id - 1
--   3. Ensure numbers are equal
--   4. Return DISTINCT numbers
--
-- Schema & Relationship Understanding:
-- Table: Logs
--   id  (INT, Primary Key, increasing order)
--   num (INT)
--
-- Each row represents one number in sequence.
--
-- Join Strategy Explanation:
-- Self-join used to compare row with next two rows.
-- Ensures strict consecutiveness by id offset.
--
-- Time Complexity Consideration:
-- O(n) with proper indexing on id.
-- Without index → potential performance degradation.
--
-- Indexing & Performance Thoughts:
-- id should be PRIMARY KEY (clustered index ideally).
--
-- Self-join is efficient when id is indexed.
--
-- Edge Case Handling:
-- - DISTINCT prevents duplicate output if sequence overlaps.
-- - Requires strict id consecutiveness.
-- - Assumes id values are sequential integers.
--
-- Execution Order Reminder:
-- FROM → JOIN → WHERE → SELECT DISTINCT
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT DISTINCT l1.num AS ConsecutiveNums
FROM Logs l1
JOIN Logs l2
  ON l1.id = l2.id - 1
JOIN Logs l3
  ON l2.id = l3.id - 1
WHERE l1.num = l2.num
  AND l2.num = l3.num;