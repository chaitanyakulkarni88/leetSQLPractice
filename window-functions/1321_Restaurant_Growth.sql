-- =========================================================
-- Problem: 1321. Restaurant Growth
-- Category: Window Functions / Rolling Window
-- =========================================================
--
-- Core Query Logic:
-- Compute a 7-day rolling total revenue and the 7-day
-- average daily revenue for the restaurant.
--
-- Only rows where a full 7-day window exists should
-- appear in the result.
--
-- Steps:
--   1. Aggregate total spending per day
--   2. Apply rolling window calculations
--   3. Assign row numbers by date order
--   4. Filter rows where row_number >= 7
--
-- Schema Understanding:
-- Table: Customer
--   customer_id  (INT)
--   name         (VARCHAR)
--   visited_on   (DATE)
--   amount       (INT)
--
-- Relationship:
-- Multiple customers can visit on the same day.
-- Therefore daily revenue must be aggregated first.
--
-- Window Function Strategy:
-- SUM(amount) OVER (
--     ORDER BY visited_on
--     ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
-- )
--
-- Explanation:
-- - ORDER BY visited_on processes rows chronologically
-- - ROWS BETWEEN 6 PRECEDING AND CURRENT ROW creates
--   a 7-day rolling window
-- - SUM() computes total revenue for the 7-day period
-- - AVG() computes average revenue across the window
--
-- Row Filtering Strategy:
-- ROW_NUMBER() is used to identify the first row where
-- a complete 7-day window exists.
--
-- Example:
--
-- row_number   visited_on
-- ------------------------
-- 1            Day1
-- 2            Day2
-- 3            Day3
-- 4            Day4
-- 5            Day5
-- 6            Day6
-- 7            Day7   ← first valid window
--
-- Therefore:
--   WHERE rn >= 7
--
-- removes incomplete windows.
--
-- Time Complexity Consideration:
-- O(n log n) due to ordering by date.
--
-- Indexing & Performance Thoughts:
-- Recommended index:
--
-- CREATE INDEX idx_customer_visited_on
-- ON Customer(visited_on);
--
-- Helps optimize ordering and window operations.
--
-- Execution Order Reminder:
-- FROM → GROUP BY → WINDOW FUNCTIONS → FILTER → SELECT
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT
    visited_on,
    amount,
    ROUND(average_amount, 2) AS average_amount
FROM (
    SELECT
        visited_on,
        SUM(amount) OVER (
            ORDER BY visited_on
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) AS amount,
        AVG(amount) OVER (
            ORDER BY visited_on
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) AS average_amount,
        ROW_NUMBER() OVER (ORDER BY visited_on) AS rn
    FROM (
        SELECT
            visited_on,
            SUM(amount) AS amount
        FROM Customer
        GROUP BY visited_on
    ) daily
) t
WHERE rn >= 7
ORDER BY visited_on;