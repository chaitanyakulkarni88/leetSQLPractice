-- =========================================================
-- Problem: 1204. Last Person to Fit in the Bus
-- Category: Advanced Select / Window Functions
-- =========================================================
--
-- Core Query Logic:
-- The bus has a weight limit of 1000.
--
-- People enter in order of turn.
-- We must determine the last person whose cumulative
-- weight does not exceed 1000.
--
-- Steps:
--   1. Order by turn
--   2. Compute running total of weight
--   3. Filter rows where cumulative_weight <= 1000
--   4. Select the last such person
--
-- Schema & Relationship Understanding:
-- Table: Queue
--   person_name (VARCHAR)
--   weight      (INT)
--   turn        (INT, increasing order)
--
-- Each row represents one person boarding.
--
-- Join Strategy Explanation:
-- Not applicable (single table).
--
-- Time Complexity Consideration:
-- O(n) scan with window function.
-- Sorting by turn if not indexed.
--
-- Indexing & Performance Thoughts:
-- Recommended index:
--
-- CREATE INDEX idx_queue_turn
-- ON Queue(turn);
--
-- Ensures efficient ordered processing.
--
-- Edge Case Handling:
-- - If first person exceeds 1000 → no one fits.
-- - Exactly 1000 is allowed.
-- - Running sum must respect boarding order.
--
-- Execution Order Reminder:
-- FROM → WINDOW FUNCTION → WHERE → ORDER BY → LIMIT
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT person_name
FROM (
    SELECT person_name,
           SUM(weight) OVER (ORDER BY turn) AS cumulative_weight
    FROM Queue
) t
WHERE cumulative_weight <= 1000
ORDER BY cumulative_weight DESC
LIMIT 1;