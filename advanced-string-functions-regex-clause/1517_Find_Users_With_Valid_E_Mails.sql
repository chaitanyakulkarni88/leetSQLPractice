-- =========================================================
-- Problem: 1517. Find Users With Valid E-Mails
-- Category: Advanced String Functions / Regex
-- =========================================================
--
-- Core Query Logic:
-- Retrieve users whose email:
--   1. Starts with a letter
--   2. May contain letters, digits, underscores, dots
--   3. Ends with "@leetcode.com"
--
-- Valid pattern:
--   ^[A-Za-z][A-Za-z0-9._]*@leetcode\.com$
--
-- Breakdown:
--   ^                → start of string
--   [A-Za-z]         → first character must be letter
--   [A-Za-z0-9._]*    → allowed characters afterward
--   @leetcode\.com   → fixed domain
--   $                → end of string
--
-- Schema & Relationship Understanding:
-- Table: Users
--   user_id (INT)
--   name    (VARCHAR)
--   mail    (VARCHAR)
--
-- Join Strategy Explanation:
-- Not applicable (single-table filtering).
--
-- Time Complexity Consideration:
-- O(n) full table scan due to REGEXP.
--
-- Indexing & Performance Thoughts:
-- REGEXP prevents index usage.
-- In production:
--   - Validate emails at application layer.
--   - Or use computed column for domain.
--
-- Edge Case Handling:
-- - Dot must be escaped in regex.
-- - Ensure strict match (no partial match).
-- - Case sensitivity depends on collation.
--
-- Execution Order Reminder:
-- FROM → WHERE → SELECT
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT user_id,
       name,
       mail
FROM Users
WHERE mail REGEXP '^[A-Za-z][A-Za-z0-9._]*@leetcode\\.com$';