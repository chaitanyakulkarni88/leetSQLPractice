-- =========================================================
-- Problem: 602. Friend Requests II: Who Has the Most Friends
-- Category: Window Functions / Aggregation / Ranking
-- =========================================================
--
-- Core Query Logic:
-- Determine which user has the highest number of friends.
--
-- Each row in RequestAccepted represents a friendship between
-- requester_id and accepter_id. Friendship is mutual, meaning
-- both users gain one friend.
--
-- Steps:
--   1. Convert friendships into a single column of user IDs
--      representing both sides of the friendship.
--   2. Count the number of friendships per user.
--   3. Rank users by their total friend count.
--   4. Select the user(s) with the highest rank.
--
-- Schema Understanding:
-- Table: RequestAccepted
--   requester_id  (INT)
--   accepter_id   (INT)
--   accept_date   (DATE)
--
-- Relationship:
-- Each row represents a friendship between two users.
-- The friendship contributes one friend to both users.
--
-- Window Function Strategy:
-- COUNT(*) OVER (PARTITION BY id)
-- RANK() OVER (ORDER BY friend_count DESC)
--
-- Explanation:
-- - UNION ALL converts requester and accepter columns
--   into a single list of user IDs.
-- - Each occurrence represents a friendship connection.
-- - COUNT(*) OVER(PARTITION BY id) calculates total friends
--   for each user.
-- - RANK() identifies the user(s) with the highest friend count.
--
-- Example Transformation:
--
-- requester_id   accepter_id
-- --------------------------
-- 1              2
-- 1              3
-- 2              3
--
-- After UNION ALL:
--
-- id
-- ---
-- 1
-- 1
-- 2
-- 2
-- 3
-- 3
--
-- Friend counts:
--
-- id   friend_count
-- ------------------
-- 1         2
-- 2         2
-- 3         2
--
-- Time Complexity Consideration:
-- O(n log n) due to ranking and partition processing.
--
-- Indexing & Performance Thoughts:
-- Recommended index:
--
-- CREATE INDEX idx_requestaccepted_users
-- ON RequestAccepted(requester_id, accepter_id);
--
-- Helps optimize scanning operations.
--
-- Edge Case Handling:
-- - Multiple users may share the same highest friend count.
-- - All such users should be returned.
--
-- Execution Order Reminder:
-- FROM → UNION → WINDOW FUNCTION → FILTER → SELECT
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT id, friend_count AS num
FROM (
    SELECT DISTINCT id,
    -- Follow-Up: Return all users with the maximum number of friends
    -- SELECT id,
           friend_count,
           RANK() OVER (ORDER BY friend_count DESC) AS r
    FROM (
        SELECT id,
               COUNT(*) OVER (PARTITION BY id) AS friend_count
        FROM (
            SELECT requester_id AS id FROM RequestAccepted
            UNION ALL
            SELECT accepter_id AS id FROM RequestAccepted
        ) friends
    ) counts
) ranked
WHERE r = 1;