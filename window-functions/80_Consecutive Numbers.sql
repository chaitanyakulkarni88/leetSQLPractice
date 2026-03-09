-- =========================================================
-- Problem: 180. Consecutive Numbers
-- Category: Window Functions / Row Comparison
-- =========================================================
--
-- Core Query Logic:
-- Identify numbers that appear at least three times
-- consecutively in the Logs table.
--
-- The result should contain each qualifying number once.
--
-- Steps:
--   1. Order rows by id (the sequence column)
--   2. Compare the current row with the previous two rows
--   3. Identify cases where all three numbers match
--   4. Return distinct values
--
-- Schema Understanding:
-- Table: Logs
--   id   (INT, Primary Key)
--   num  (INT)
--
-- Relationship:
-- Rows represent sequential log entries.
-- Consecutive occurrences must respect the id ordering.
--
-- Window Function Strategy:
-- LAG(num, 1) OVER (ORDER BY id)
-- LAG(num, 2) OVER (ORDER BY id)
--
-- Explanation:
-- - LAG(num,1) retrieves the previous row's number
-- - LAG(num,2) retrieves the number two rows before
-- - If current num equals both previous numbers,
--   then three consecutive rows contain the same value
--
-- Example:
--
-- id   num   prev1   prev2
-- -------------------------
-- 1    1     NULL    NULL
-- 2    1     1       NULL
-- 3    1     1       1     ← match
-- 4    2     1       1
-- 5    1     2       1
-- 6    2     1       2
-- 7    2     2       1
-- 8    2     2       2     ← match
--
-- Numbers appearing consecutively:
-- 1 and 2
--
-- Time Complexity Consideration:
-- O(n) scan with ordered window processing.
--
-- Indexing & Performance Thoughts:
-- Recommended index:
--
-- CREATE INDEX idx_logs_id
-- ON Logs(id);
--
-- Helps ensure efficient ordering.
--
-- Edge Case Handling:
-- - Fewer than 3 rows → no result
-- - Multiple consecutive sequences of the same number
--   should return that number once
--
-- Execution Order Reminder:
-- FROM → WINDOW FUNCTION → FILTER → SELECT DISTINCT
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT DISTINCT num AS ConsecutiveNums
FROM (
    SELECT num,
           LAG(num, 1) OVER (ORDER BY id) AS prev1,
           LAG(num, 2) OVER (ORDER BY id) AS prev2
    FROM Logs
) t
WHERE num = prev1
  AND num = prev2;