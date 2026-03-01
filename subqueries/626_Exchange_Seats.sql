-- =========================================================
-- Problem: 626. Exchange Seats
-- Category: Select / Conditional Logic
-- =========================================================
--
-- Core Query Logic:
-- Swap every two adjacent students' seat ids.
--
-- Rules:
--   - If id is odd → swap with next id (id + 1)
--   - If id is even → swap with previous id (id - 1)
--   - If last row has no pair → remain unchanged
--
-- Steps:
--   1. Use CASE expression
--   2. Check parity of id
--   3. Ensure last row (if odd count) is not modified
--
-- Schema & Relationship Understanding:
-- Table: Seat
--   id      (INT, Primary Key, sequential)
--   student (VARCHAR)
--
-- Each row represents a seat assignment.
--
-- Join Strategy Explanation:
-- Not required.
-- Pure row transformation based on id ordering.
--
-- Time Complexity Consideration:
-- O(n) simple scan.
--
-- Indexing & Performance Thoughts:
-- id should be PRIMARY KEY.
-- No additional indexing required.
--
-- Edge Case Handling:
-- - If total rows is odd,
--   last student remains in same position.
-- - Must preserve full dataset.
-- - Final result must be ordered by id.
--
-- Execution Order Reminder:
-- FROM → SELECT (CASE transformation) → ORDER BY
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT
    CASE
        WHEN id % 2 = 1 AND id <> (SELECT MAX(id) FROM Seat)
            THEN id + 1
        WHEN id % 2 = 0
            THEN id - 1
        ELSE id
    END AS id,
    student
FROM Seat
ORDER BY id;