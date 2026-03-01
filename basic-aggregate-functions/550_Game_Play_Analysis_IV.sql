-- =========================================================
-- Problem: 550. Game Play Analysis IV
-- Category: Subqueries / Aggregation
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
LEFT JOIN Activity a
       ON a.player_id = first_logins.player_id
      AND a.event_date = DATE_ADD(first_logins.first_login, INTERVAL 1 DAY);