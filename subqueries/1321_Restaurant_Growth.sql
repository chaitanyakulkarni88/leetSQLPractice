-- =========================================================
-- Problem: 1321. Restaurant Growth
-- Category: Window Functions / Rolling Aggregation
-- =========================================================
--
-- Core Query Logic:
-- Compute 7-day rolling revenue and average revenue.
--
-- Steps:
--   1. Aggregate daily revenue first
--   2. Use window function to compute:
--        - 7-day rolling sum
--        - 7-day rolling average
--   3. Return rows only when 7 full days exist
--
-- Schema & Relationship Understanding:
-- Table: Customer
--   customer_id (INT)
--   name        (VARCHAR)
--   visited_on  (DATE)
--   amount      (INT)
--
-- Multiple customers per day.
--
-- Join Strategy Explanation:
-- Not applicable (single-table aggregation).
--
-- Strategy:
--   Step 1 → Pre-aggregate daily totals
--   Step 2 → Apply window function
--
-- Time Complexity Consideration:
-- O(n log n) due to ordering.
-- Efficient with proper indexing.
--
-- Indexing & Performance Thoughts:
-- Recommended index:
--
-- CREATE INDEX idx_customer_visited_on
-- ON Customer(visited_on);
--
-- Pre-aggregation significantly reduces data size
-- before window processing.
--
-- Edge Case Handling:
-- - Only include dates where 7 consecutive days exist.
-- - Round average to 2 decimal places.
-- - Ensure correct ordering by date.
--
-- Execution Order Reminder:
-- FROM → GROUP BY → WINDOW → WHERE → SELECT
--
-- Clean, Production-Ready SQL:
-- =========================================================

WITH daily_revenue AS (
    SELECT visited_on,
           SUM(amount) AS daily_total
    FROM Customer
    GROUP BY visited_on
)

SELECT visited_on,
       SUM(daily_total) OVER (
           ORDER BY visited_on
           ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
       ) AS amount,
       ROUND(
           AVG(daily_total) OVER (
               ORDER BY visited_on
               ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
           ),
           2
       ) AS average_amount
FROM daily_revenue
WHERE visited_on >= (
    SELECT MIN(visited_on) + INTERVAL 6 DAY
    FROM daily_revenue
)
ORDER BY visited_on;