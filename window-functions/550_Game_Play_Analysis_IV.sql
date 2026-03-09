-- =========================================================
-- Problem: 550. Game Play Analysis IV
-- Category: Window Functions / User Retention
-- =========================================================
--
-- Core Query Logic:
-- Calculate the fraction of players who logged in again
-- on the day immediately following their first login.
--
-- Steps:
--   1. Determine each player's first login date
--   2. Check if the player logged in again the next day
--   3. Count such players
--   4. Divide by the total number of players
--
-- Schema Understanding:
-- Table: Activity
--   player_id   (INT)
--   device_id   (INT)
--   event_date  (DATE)
--   games_played (INT)
--
-- Relationship:
-- Each row represents a player login event.
-- A player may have multiple rows across different dates.
--
-- Window Function Strategy:
-- MIN(event_date) OVER (PARTITION BY player_id)
--
-- Explanation:
-- - MIN(event_date) finds each player's first login date
-- - We then check if another row exists where:
--     event_date = first_login + 1 day
--
-- Example:
--
-- player_id   event_date
-- ----------------------
-- 1           Jan1
-- 1           Jan2   ← returned next day
-- 2           Jan1
-- 2           Jan4
--
-- Player 1 qualifies, player 2 does not.
--
-- Fraction = qualifying_players / total_players
--
-- Time Complexity Consideration:
-- O(n) scan with partitioned window processing.
--
-- Indexing & Performance Thoughts:
-- Recommended index:
--
-- CREATE INDEX idx_activity_player_date
-- ON Activity(player_id, event_date);
--
-- Helps optimize partition ordering.
--
-- Execution Order Reminder:
-- FROM → WINDOW FUNCTION → FILTER → AGGREGATE → SELECT
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT ROUND(
    COUNT(DISTINCT player_id) /
    (SELECT COUNT(DISTINCT player_id) FROM Activity),
    2
) AS fraction
FROM (
    SELECT player_id,
           event_date,
           MIN(event_date) OVER (PARTITION BY player_id) AS first_login
    FROM Activity
) t
WHERE event_date = DATE_ADD(first_login, INTERVAL 1 DAY);