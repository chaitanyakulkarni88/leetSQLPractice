-- =========================================================
-- Problem: 1341. Movie Rating
-- Category: Aggregation / Ranking
-- =========================================================
--
-- Core Query Logic:
-- Return two results:
--
-- 1. User who rated the most movies
--    - If tie → lexicographically smallest name
--
-- 2. Movie with highest average rating in February 2020
--    - If tie → lexicographically smallest title
--
-- Schema & Relationship Understanding:
-- Table: Users
--   user_id (INT, Primary Key)
--   name    (VARCHAR)
--
-- Table: Movies
--   movie_id (INT, Primary Key)
--   title    (VARCHAR)
--
-- Table: MovieRating
--   movie_id   (INT, FK → Movies.movie_id)
--   user_id    (INT, FK → Users.user_id)
--   rating     (INT)
--   created_at (DATE)
--
-- Relationships:
--   Users ↔ MovieRating ↔ Movies
--
-- Join Strategy Explanation:
-- Two separate aggregations:
--   - One grouped by user
--   - One grouped by movie (filtered by month)
--
-- UNION ALL combines final results.
--
-- Time Complexity Consideration:
-- O(n) scans with grouping.
-- Indexing improves filtering and joins.
--
-- Indexing & Performance Thoughts:
-- Recommended indexes:
--
-- CREATE INDEX idx_movierating_user
-- ON MovieRating(user_id);
--
-- CREATE INDEX idx_movierating_movie_date
-- ON MovieRating(movie_id, created_at);
--
-- Critical for large datasets.
--
-- Edge Case Handling:
-- - Tie-breaking requires ORDER BY name/title ASC.
-- - Month filtering must be index-friendly.
-- - Use explicit date range instead of MONTH() function.
--
-- Execution Order Reminder:
-- FROM → JOIN → WHERE → GROUP BY → ORDER BY → LIMIT
--
-- Clean, Production-Ready SQL:
-- =========================================================

(
    -- 1. User who rated the most movies
    SELECT u.name AS results
    FROM MovieRating mr
    JOIN Users u
      ON mr.user_id = u.user_id
    GROUP BY mr.user_id, u.name
    ORDER BY COUNT(*) DESC, u.name ASC
    LIMIT 1
)

UNION ALL

(
    -- 2. Movie with highest average rating in Feb 2020
    SELECT m.title AS results
    FROM MovieRating mr
    JOIN Movies m
      ON mr.movie_id = m.movie_id
    WHERE mr.created_at >= '2020-02-01'
      AND mr.created_at < '2020-03-01'
    GROUP BY mr.movie_id, m.title
    ORDER BY AVG(mr.rating) DESC, m.title ASC
    LIMIT 1
);