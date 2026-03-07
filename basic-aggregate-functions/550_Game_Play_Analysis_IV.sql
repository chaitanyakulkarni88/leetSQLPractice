-- =========================================================
-- Problem: 550. Game Play Analysis IV
-- Category: Subqueries / EXISTS / Aggregation
-- =========================================================
--
-- Core Query Logic:
-- Compute the fraction of players who logged in again
-- exactly one day after their first login.
--
-- Steps:
--   1. Identify each player's first login date.
--   2. Check whether a login exists on first_date + 1 day.
--   3. Count such players.
--   4. Divide by total distinct players.
--   5. Round result to 2 decimal places.
--
-- Schema & Relationship Understanding:
-- Table: Activity
--   player_id  (INT)
--   device_id  (INT)
--   event_date (DATE)
--   games_played (INT)
--
-- Each row represents a login activity.
--
-- Join Strategy Explanation:
-- Use subquery to compute first login date per player.
-- Then LEFT JOIN back to Activity to check next-day login.
--
-- Time Complexity Consideration:
-- O(n) scan with grouping.
-- Performance depends on indexing of (player_id, event_date).
--
-- Indexing & Performance Thoughts:
-- Recommended index:
--
-- CREATE INDEX idx_activity_player_date
-- ON Activity(player_id, event_date);
--
-- This improves both MIN(event_date) and next-day lookup.
--
-- Edge Case Handling:
-- - Players with only one login should not be counted.
-- - Division by zero avoided (at least one player exists).
-- - Use floating-point division.
-- - ROUND to 2 decimal places.
--
-- Execution Order Reminder:
-- FROM → JOIN → GROUP BY → SELECT
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT ROUND(
           COUNT(a.player_id) * 1.0
           / (SELECT COUNT(DISTINCT player_id) FROM Activity),
           2
       ) AS fraction
FROM (
    SELECT player_id,
           MIN(event_date) AS first_login
    FROM Activity
    GROUP BY player_id
) first_logins
INNER JOIN Activity a
       ON a.player_id = first_logins.player_id
      AND a.event_date = DATE_ADD(first_logins.first_login, INTERVAL 1 DAY);

-- =========================================================
-- EXISTS Strategy Explanation
-- =========================================================
--
-- EXISTS is used to check whether a matching row exists
-- in a correlated subquery.
--
-- For each player's first login:
--
--   EXISTS (
--       SELECT 1
--       FROM Activity
--       WHERE player_id = current_player
--       AND event_date = first_login + 1 day
--   )
--
-- If a next-day login exists → TRUE (1)
-- If not → FALSE (0)
--
-- Since MySQL treats boolean values as numeric:
--
--   TRUE  = 1
--   FALSE = 0
--
-- We can compute the fraction using:
--
--   AVG(TRUE/FALSE)
--
-- because:
--
--   AVG = SUM(values) / COUNT(values)
--
--
-- =========================================================
-- Why EXISTS is Efficient
-- =========================================================
--
-- EXISTS stops searching once a matching row is found.
--
-- Unlike joins, it does not need to materialize all matches.
--
-- This often reduces unnecessary scans for large datasets.
--
--
-- =========================================================
-- Time Complexity Consideration
-- =========================================================
--
-- Step 1:
--   GROUP BY player_id to compute first login
--   Complexity ≈ O(n log n)
--
-- Step 2:
--   EXISTS lookup per player
--
-- With proper indexing:
--
--   overall complexity ≈ O(n)
--
--
-- =========================================================
-- Indexing & Performance Thoughts
-- =========================================================
--
-- Recommended index:
--
--   CREATE INDEX idx_activity_player_date
--   ON Activity(player_id, event_date);
--
-- This improves:
--
--   - MIN(event_date) grouping
--   - EXISTS next-day lookup
--
--
-- =========================================================
-- Edge Case Handling
-- =========================================================
--
-- - Players with only one login → EXISTS returns FALSE.
-- - AVG(FALSE) correctly contributes 0 to fraction.
-- - At least one player exists, so division by zero cannot occur.
-- - Result rounded to 2 decimal places.

SELECT ROUND(
       AVG(
           EXISTS (
               SELECT 1
               FROM Activity a2
               WHERE a2.player_id = a1.player_id
               AND a2.event_date =
                   DATE_ADD(a1.first_login, INTERVAL 1 DAY)
           )
       ),
       2
) AS fraction
FROM (
      SELECT player_id,
             MIN(event_date) AS first_login
      FROM Activity
      GROUP BY player_id
) a1;