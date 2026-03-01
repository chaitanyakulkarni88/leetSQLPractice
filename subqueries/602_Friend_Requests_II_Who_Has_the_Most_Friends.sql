-- =========================================================
-- Problem: 602. Friend Requests II: Who Has the Most Friends
-- Category: Aggregation / Graph Relationships
-- =========================================================
--
-- Core Query Logic:
-- Each accepted friend request creates a bidirectional friendship.
--
-- We must:
--   1. Count total friends per user
--   2. Return the user with the highest friend count
--
-- Important:
-- Requester and accepter are both friends.
-- So we must count both sides.
--
-- Schema & Relationship Understanding:
-- Table: RequestAccepted
--   requester_id (INT)
--   accepter_id  (INT)
--   accept_date  (DATE)
--
-- Each row represents an accepted friend request.
--
-- Relationship:
-- Undirected graph.
-- Each row creates 2 edges:
--   requester → accepter
--   accepter → requester
--
-- Join Strategy Explanation:
-- Use UNION ALL to flatten both directions.
-- Then GROUP BY user_id to count connections.
--
-- Time Complexity Consideration:
-- O(n) scan with grouping.
--
-- Indexing & Performance Thoughts:
-- Recommended indexes:
--
-- CREATE INDEX idx_request_requester
-- ON RequestAccepted(requester_id);
--
-- CREATE INDEX idx_request_accepter
-- ON RequestAccepted(accepter_id);
--
-- For very large social graphs,
-- consider maintaining precomputed friend counts.
--
-- Edge Case Handling:
-- - Duplicate accepted requests should not exist.
-- - If tie exists, problem guarantees unique answer.
--
-- Execution Order Reminder:
-- FROM → UNION ALL → GROUP BY → ORDER BY → LIMIT
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT id,
       COUNT(*) AS num
FROM (
    SELECT requester_id AS id
    FROM RequestAccepted
    UNION ALL
    SELECT accepter_id AS id
    FROM RequestAccepted
) friends
GROUP BY id
ORDER BY num DESC
LIMIT 1;