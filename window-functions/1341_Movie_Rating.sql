-- =========================================================
-- Problem: 1341. Movie Rating
-- Category: Window Functions / Aggregation / Ranking
-- =========================================================
--
-- Core Query Logic:
-- The result must return two values:
--
--   1. The user who has rated the greatest number of movies
--   2. The movie with the highest average rating in February 2020
--
-- If there is a tie, return the lexicographically smallest name.
--
-- Steps:
-- Part 1 (Most Active User)
--   1. Join Users and MovieRating tables
--   2. Count ratings per user
--   3. Rank users by rating count (descending)
--   4. Break ties using user name (ascending)
--   5. Return the top-ranked user
--
-- Part 2 (Best Movie in Feb 2020)
--   1. Filter ratings from February 2020
--   2. Compute average rating per movie
--   3. Rank movies by average rating (descending)
--   4. Break ties using movie title (ascending)
--   5. Return the top-ranked movie
--
-- Schema Understanding:
-- Table: Users
--   user_id   (INT, Primary Key)
--   name      (VARCHAR)
--
-- Table: Movies
--   movie_id  (INT, Primary Key)
--   title     (VARCHAR)
--
-- Table: MovieRating
--   movie_id   (INT)
--   user_id    (INT)
--   rating     (INT)
--   created_at (DATE)
--
-- Relationships:
--   Users → MovieRating (one-to-many)
--   Movies → MovieRating (one-to-many)
--
-- Window Function Strategy:
-- RANK() OVER (ORDER BY metric DESC, name ASC)
--
-- Explanation:
-- - ORDER BY rating count DESC finds the most active user
-- - ORDER BY name ASC resolves ties lexicographically
-- - Similar logic applied to movie ratings
--
-- Execution Order Reminder:
-- FROM → JOIN → GROUP BY → WINDOW FUNCTION → FILTER → SELECT
--
-- Clean, Production-Ready SQL:
-- =========================================================
(
SELECT name AS results
FROM (
    SELECT u.name,
           COUNT(*) AS rating_count,
           RANK() OVER (ORDER BY COUNT(*) DESC, u.name ASC) AS r
    FROM MovieRating mr
    JOIN Users u
      ON mr.user_id = u.user_id
    GROUP BY u.name
) t
WHERE r = 1
)

UNION ALL

(
SELECT title
FROM (
    SELECT m.title,
           AVG(mr.rating) AS avg_rating,
           RANK() OVER (ORDER BY AVG(mr.rating) DESC, m.title ASC) AS r
    FROM MovieRating mr
    JOIN Movies m
      ON mr.movie_id = m.movie_id
    WHERE mr.created_at BETWEEN '2020-02-01' AND '2020-02-29'
    GROUP BY m.title
) t
WHERE r = 1
);