-- =========================================================
-- Problem: 1934. Confirmation Rate
-- Category: Advanced Select and Joins / Aggregation
-- =========================================================
--
-- Core Query Logic:
-- For each user, compute confirmation rate:
--
--   confirmation_rate =
--     (# of confirmed messages) / (total confirmation attempts)
--
-- If a user has no confirmation attempts,
-- the confirmation rate should be 0.
--
-- Schema & Relationship Understanding:
-- Table: Signups
--   user_id (Primary Key)
--   time_stamp (DATETIME)
--
-- Table: Confirmations
--   user_id (Foreign Key → Signups.user_id)
--   time_stamp (DATETIME)
--   action ('confirmed', 'timeout')
--
-- Relationship:
-- One-to-many:
--   One user → many confirmation attempts.
--
-- Join Strategy Explanation:
-- LEFT JOIN is required because:
--   - Every signed-up user must appear in result.
--   - Some users may have zero confirmations.
--
-- Conditional aggregation used to:
--   - Count total attempts
--   - Count confirmed attempts
--
-- Time Complexity Consideration:
-- O(n) relative to Signups.
-- Join efficiency depends on indexing.
--
-- Indexing & Performance Thoughts:
-- Recommended index:
--   CREATE INDEX idx_confirmations_user
--   ON Confirmations(user_id);
--
-- If filtering by action frequently:
--   CREATE INDEX idx_confirmations_user_action
--   ON Confirmations(user_id, action);
--
-- Edge Case Handling:
-- - Users with no confirmation rows → rate = 0.
-- - Division by zero must be prevented.
-- - ROUND required to 2 decimal places.
--
-- Execution Order Reminder:
-- FROM → JOIN → GROUP BY → SELECT
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT s.user_id,
       ROUND(
           IFNULL(
               SUM(c.action = 'confirmed') / COUNT(c.action),
               0
           ),
           2
       ) AS confirmation_rate
FROM Signups s
LEFT JOIN Confirmations c
       ON s.user_id = c.user_id
GROUP BY s.user_id;