-- =========================================================
-- Problem: 1204. Last Person to Fit in the Bus
-- Category: Advanced Select / Window Functions / Correlated Subquery
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

-- =========================================================
-- Correlated Subquery Strategy Explanation
-- =========================================================
--
-- A correlated subquery is executed once per row of the
-- outer query and references columns from that outer row.
--
-- In this query:
--
--   SELECT SUM(weight)
--   FROM Queue q2
--   WHERE q2.turn <= q1.turn
--
-- computes the cumulative weight of all passengers who
-- boarded up to the current person's turn.
--
-- This effectively simulates a running total without
-- using window functions.
--
--
-- =========================================================
-- Time Complexity Consideration
-- =========================================================
--
-- For each row in Queue, the correlated subquery scans
-- earlier rows to compute the cumulative sum.
--
-- Worst-case complexity:
--
--   O(n²)
--
-- because each row may scan many previous rows.
--
-- This approach is therefore less efficient than
-- window functions for large datasets.
--
-- =========================================================
-- Indexing & Performance Thoughts
-- =========================================================
--
-- Recommended index:
--
--   CREATE INDEX idx_queue_turn
--   ON Queue(turn);
--
-- This allows the correlated subquery to efficiently
-- locate rows where:
--
--   q2.turn <= q1.turn
--
-- =========================================================
-- SQL Logical Execution Order
-- =========================================================
--
-- FROM Queue (outer query row)
-- → correlated subquery computes running sum
-- → WHERE filters rows exceeding weight limit
-- → ORDER BY descending turn
-- → LIMIT 1 selects the last valid passenger
--
-- =========================================================
-- Clean, Production-Ready SQL
-- =========================================================

SELECT person_name
FROM Queue q1
WHERE (
    SELECT SUM(weight)
    FROM Queue q2
    WHERE q2.turn <= q1.turn
) <= 1000
ORDER BY turn DESC
LIMIT 1;