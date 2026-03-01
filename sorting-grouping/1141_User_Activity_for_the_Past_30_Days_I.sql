-- =========================================================
-- Problem: 1141. User Activity for the Past 30 Days I
-- Category: Aggregation / Date Filtering
-- =========================================================
--
-- Core Query Logic:
-- For each day in the past 30 days (ending 2019-07-27),
-- count distinct active users.
--
-- Active user = user_id appearing in Activity table.
--
-- Steps:
--   1. Filter rows within date range
--   2. GROUP BY activity_date
--   3. COUNT(DISTINCT user_id)
--   4. Order by activity_date
--
-- Schema & Relationship Understanding:
-- Table: Activity
--   user_id       (INT)
--   session_id    (INT)
--   activity_date (DATE)
--   activity_type (VARCHAR)
--
-- Each row represents one activity session.
--
-- Join Strategy Explanation:
-- Not applicable (single table).
--
-- Time Complexity Consideration:
-- O(n) scan.
-- Performance depends heavily on date filtering efficiency.
--
-- Indexing & Performance Thoughts:
-- Recommended index:
--
-- CREATE INDEX idx_activity_date_user
-- ON Activity(activity_date, user_id);
--
-- Important:
-- Avoid applying functions on activity_date in WHERE,
-- otherwise index usage may be blocked.
--
-- Edge Case Handling:
-- - Date range inclusive.
-- - COUNT(DISTINCT) prevents duplicate sessions inflating count.
-- - Days with no activity are not required in output.
--
-- Execution Order Reminder:
-- FROM → WHERE → GROUP BY → SELECT → ORDER BY
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT activity_date AS day,
       COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE activity_date BETWEEN DATE_SUB('2019-07-27', INTERVAL 29 DAY)
                        AND '2019-07-27'
GROUP BY activity_date
ORDER BY activity_date;