-- =========================================================
-- Problem: 620. Not Boring Movies
-- Category: Select / Filtering
-- =========================================================
--
-- Core Query Logic:
-- Retrieve all movies where:
--   1. id is odd
--   2. description != 'boring'
--
-- Result must be ordered by rating DESC.
--
-- Schema & Relationship Understanding:
-- Table: Cinema
--   id          (Primary Key)
--   movie       (VARCHAR)
--   description (VARCHAR)
--   rating      (FLOAT)
--
-- Single-table query. No joins required.
--
-- Join Strategy Explanation:
-- Not applicable (single table).
--
-- Time Complexity Consideration:
-- O(n) table scan for filtering.
-- Sorting adds O(n log n) depending on dataset size.
--
-- Indexing & Performance Thoughts:
-- If dataset is large:
--   - Index on (description)
--   - Index on (rating)
--
-- However:
--   Using modulus operation (id % 2) prevents index usage
--   on id for that condition.
--
-- In production, filtering on odd IDs is uncommon,
-- but if required frequently, consider storing parity flag.
--
-- Edge Case Handling:
-- - Ensure 'boring' comparison is exact match.
-- - Case sensitivity depends on collation.
-- - id assumed NOT NULL.
--
-- Execution Order Reminder:
-- FROM → WHERE → SELECT → ORDER BY
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT id,
       movie,
       description,
       rating
FROM Cinema
WHERE id % 2 = 1
  AND description <> 'boring'
ORDER BY rating DESC;