-- =========================================================
-- Problem: 178. Rank Scores
-- Category: Window Functions / Ranking
-- =========================================================
--
-- Core Query Logic:
-- Rank scores in descending order so that the highest
-- score receives rank 1.
--
-- If multiple rows have the same score, they should share
-- the same rank.
--
-- The ranking must not skip numbers when ties occur.
--
-- Steps:
--   1. Order scores in descending order
--   2. Apply DENSE_RANK() to assign ranking
--   3. Return score and its computed rank
--
-- Schema Understanding:
-- Table: Scores
--   id     (INT, Primary Key)
--   score  (DECIMAL)
--
-- Relationship:
-- Each row represents a score entry.
-- Multiple rows may contain identical scores.
--
-- Window Function Strategy:
-- DENSE_RANK() OVER (ORDER BY score DESC)
--
-- Explanation:
-- - ORDER BY score DESC ranks the highest score first
-- - DENSE_RANK() assigns equal rank for equal scores
-- - Rank numbers remain consecutive (no gaps)
--
-- Example Ranking:
--
-- score   dense_rank
-- -------------------
-- 4.00        1
-- 4.00        1
-- 3.85        2
-- 3.65        3
-- 3.65        3
-- 3.50        4
--
-- Why DENSE_RANK():
-- - ROW_NUMBER() would give each row a unique rank
-- - RANK() would skip numbers when ties occur
-- - DENSE_RANK() maintains consistent ranking
--
-- Time Complexity Consideration:
-- O(n log n) due to sorting by score.
--
-- Indexing & Performance Thoughts:
-- Recommended index:
--
-- CREATE INDEX idx_scores_score
-- ON Scores(score DESC);
--
-- Helps optimize ordering operations.
--
-- Edge Case Handling:
-- - Identical scores must share the same rank.
-- - Ranking values must remain consecutive.
--
-- Execution Order Reminder:
-- FROM → WINDOW FUNCTION → SELECT → ORDER BY
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT
    score,
    DENSE_RANK() OVER (
        ORDER BY score DESC
    ) AS `rank`
FROM Scores
ORDER BY score DESC;