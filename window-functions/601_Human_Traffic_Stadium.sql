-- =========================================================
-- Problem: 601. Human Traffic of Stadium
-- Category: Window Functions / Consecutive Rows / Gap Trick
-- =========================================================
--
-- Core Query Logic:
-- Identify rows where the stadium had at least 100 people
-- for three or more consecutive days.
--
-- Steps:
--   1. Filter rows where people >= 100
--   2. Order rows by id
--   3. Use ROW_NUMBER() to generate a sequential index
--   4. Use the gap trick: id - ROW_NUMBER() to group
--      consecutive rows
--   5. Keep groups with at least 3 rows
--
-- Schema Understanding:
-- Table: Stadium
--   id           (INT, Primary Key)
--   visit_date   (DATE)
--   people       (INT)
--
-- Relationship:
-- Each row represents a stadium attendance record for a day.
--
-- Window Function Strategy:
-- ROW_NUMBER() OVER (ORDER BY id)
--
-- Explanation:
-- - ROW_NUMBER() creates a continuous sequence
-- - Subtracting ROW_NUMBER() from id produces a constant
--   value for consecutive rows
-- - This allows grouping "islands" of consecutive records
--
-- Example:
--
-- id   people
-- ----------
-- 1    120
-- 2    150
-- 3    180
-- 5    200
-- 6    210
--
-- After row numbering:
--
-- id   rn   id-rn
-- ----------------
-- 1    1      0
-- 2    2      0
-- 3    3      0   ← group 1
-- 5    4      1
-- 6    5      1   ← group 2
--
-- Groups with >= 3 rows represent valid results.
--
-- Time Complexity Consideration:
-- O(n log n) due to ordering.
--
-- Indexing & Performance Thoughts:
-- Recommended index:
--
-- CREATE INDEX idx_stadium_id
-- ON Stadium(id);
--
-- Improves ordering performance.
--
-- Execution Order Reminder:
-- FROM → FILTER → WINDOW FUNCTION → GROUP → SELECT
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT id, visit_date, people
FROM (
    SELECT *,
           id - ROW_NUMBER() OVER (ORDER BY id) AS grp
    FROM Stadium
    WHERE people >= 100
) t
WHERE grp IN (
    SELECT grp
    FROM (
        SELECT id - ROW_NUMBER() OVER (ORDER BY id) AS grp
        FROM Stadium
        WHERE people >= 100
    ) x
    GROUP BY grp
    HAVING COUNT(*) >= 3
)
ORDER BY visit_date;