-- =========================================================
-- Problem: 1667. Fix Names in a Table
-- Category: String Functions
-- =========================================================
--
-- Core Query Logic:
-- Standardize names such that:
--   - First letter is uppercase
--   - Remaining letters are lowercase
--
-- Then sort results by user_id.
--
-- Steps:
--   1. Extract first character → UPPER()
--   2. Extract remaining substring → LOWER()
--   3. CONCAT both parts
--
-- Schema & Relationship Understanding:
-- Table: Users
--   user_id (INT)
--   name    (VARCHAR)
--
-- Each row contains improperly formatted names.
--
-- Join Strategy Explanation:
-- Not applicable (single-table transformation).
--
-- Time Complexity Consideration:
-- O(n) simple scan.
--
-- Indexing & Performance Thoughts:
-- Index on user_id improves ORDER BY performance:
--
-- CREATE INDEX idx_users_userid
-- ON Users(user_id);
--
-- String functions operate row-wise.
--
-- Edge Case Handling:
-- - Single-character names handled correctly.
-- - Empty strings unlikely per constraints.
-- - LOWER handles mixed-case names.
--
-- Execution Order Reminder:
-- FROM → SELECT (string transformation) → ORDER BY
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT user_id,
       CONCAT(
           UPPER(LEFT(name, 1)),
           LOWER(SUBSTRING(name, 2))
       ) AS name
FROM Users
ORDER BY user_id;