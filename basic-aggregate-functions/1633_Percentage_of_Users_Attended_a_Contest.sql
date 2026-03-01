-- =========================================================
-- Problem: 1633. Percentage of Users Attended a Contest
-- Category: Aggregation / Subquery
-- =========================================================
--
-- Core Query Logic:
-- For each contest, compute:
--
--   percentage =
--     (# of users registered for contest)
--     --------------------------------------
--     (total number of users)
--
-- Multiply by 100 and round to 2 decimal places.
--
-- Steps:
--   1. Count distinct users per contest
--   2. Divide by total distinct users in Users table
--   3. Multiply by 100
--   4. Round to 2 decimal places
--   5. Order by percentage DESC, contest_id ASC
--
-- Schema & Relationship Understanding:
-- Table: Users
--   user_id (Primary Key)
--
-- Table: Register
--   contest_id (INT)
--   user_id    (Foreign Key → Users.user_id)
--
-- Relationship:
-- Many-to-many:
--   One user can register for many contests.
--
-- Join Strategy Explanation:
-- No join required for main query.
-- Total user count computed via subquery.
--
-- Time Complexity Consideration:
-- O(n) for grouping Register table.
-- Total user count computed once.
--
-- Indexing & Performance Thoughts:
-- Recommended indexes:
--
-- CREATE INDEX idx_register_contest_user
-- ON Register(contest_id, user_id);
--
-- Users.user_id should be PRIMARY KEY.
--
-- COUNT(DISTINCT user_id) benefits from proper indexing.
--
-- Edge Case Handling:
-- - Users table assumed non-empty.
-- - COUNT(DISTINCT) prevents duplicate registrations.
-- - ROUND required to 2 decimal places.
--
-- Execution Order Reminder:
-- FROM → GROUP BY → SELECT → ORDER BY
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT r.contest_id,
       ROUND(
           COUNT(DISTINCT r.user_id) * 100.0
           / (SELECT COUNT(*) FROM Users),
           2
       ) AS percentage
FROM Register r
GROUP BY r.contest_id
ORDER BY percentage DESC, r.contest_id ASC;