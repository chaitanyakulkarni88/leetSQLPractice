-- =========================================================
-- Problem: 1581. Customer Who Visited but Did Not Make Any Transactions
-- Category: Basic Joins / Aggregation
-- =========================================================
--
-- Core Query Logic:
-- Find customers who visited but did NOT make any transactions.
-- Count the number of such visits per customer.
--
-- This requires:
--   1. LEFT JOIN from Visits → Transactions
--   2. Filter rows where transaction_id IS NULL
--   3. GROUP BY customer_id
--
-- Schema & Relationship Understanding:
-- Table: Visits
--   visit_id     (Primary Key)
--   customer_id  (INT)
--
-- Table: Transactions
--   transaction_id (Primary Key)
--   visit_id       (Foreign Key → Visits.visit_id)
--   amount         (INT)
--
-- Relationship:
-- One visit may have zero or more transactions.
--
-- Join Strategy Explanation:
-- LEFT JOIN is required because:
-- - We must retain visits even if no transaction exists.
-- - Filtering on t.transaction_id IS NULL gives us
--   visits without transactions.
--
-- This is effectively an anti-join pattern.
--
-- Time Complexity Consideration:
-- O(n) relative to Visits table.
-- Join performance depends on indexing.
--
-- Indexing & Performance Thoughts:
-- For production-scale systems:
--   - Visits.visit_id should be PRIMARY KEY.
--   - Transactions.visit_id should be indexed.
--
-- Example:
-- CREATE INDEX idx_transactions_visit
-- ON Transactions(visit_id);
--
-- Without index, join could degrade significantly.
--
-- Edge Case Handling:
-- - Customers with multiple visits but zero transactions
--   should count all such visits.
-- - Visits with multiple transactions must NOT be counted.
-- - NULL handling is critical: we filter specifically
--   where transaction_id IS NULL.
--
-- Execution Order Reminder:
-- FROM → JOIN → WHERE → GROUP BY → SELECT
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT v.customer_id,
       COUNT(v.visit_id) AS count_no_trans
FROM Visits v
LEFT JOIN Transactions t
       ON v.visit_id = t.visit_id
WHERE t.transaction_id IS NULL
GROUP BY v.customer_id;