-- =========================================================
-- Problem: 1193. Monthly Transactions I
-- Category: Aggregation / Conditional Aggregation
-- =========================================================
--
-- Core Query Logic:
-- For each month and country, compute:
--
--   trans_count     → total transactions
--   approved_count  → transactions where state = 'approved'
--   trans_total_amount
--   approved_total_amount
--
-- Month must be formatted as YYYY-MM.
--
-- Steps:
--   1. Extract month from transaction date
--   2. GROUP BY month and country
--   3. Use conditional aggregation for approved metrics
--
-- Schema & Relationship Understanding:
-- Table: Transactions
--   id        (INT)
--   country   (VARCHAR)
--   state     (ENUM: 'approved', 'declined')
--   amount    (INT)
--   trans_date (DATE)
--
-- Single-table aggregation.
--
-- Join Strategy Explanation:
-- Not applicable (single table).
--
-- Time Complexity Consideration:
-- O(n) table scan.
-- GROUP BY on derived month and country.
--
-- Indexing & Performance Thoughts:
-- Recommended indexes:
--
-- CREATE INDEX idx_transactions_date_country
-- ON Transactions(trans_date, country);
--
-- If filtering by state frequently:
-- CREATE INDEX idx_transactions_state
-- ON Transactions(state);
--
-- Note:
-- Applying DATE_FORMAT() in SELECT does not prevent
-- index usage in WHERE (if used properly).
--
-- Edge Case Handling:
-- - Months with only declined transactions still appear.
-- - SUM ignores NULL automatically.
-- - Ensure floating vs integer is not required here.
--
-- Execution Order Reminder:
-- FROM → GROUP BY → SELECT → ORDER BY
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT DATE_FORMAT(trans_date, '%Y-%m') AS month,
       country,
       COUNT(*) AS trans_count,
       SUM(state = 'approved') AS approved_count,
       SUM(amount) AS trans_total_amount,
       SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END)
           AS approved_total_amount
FROM Transactions
GROUP BY month, country
ORDER BY month, country;