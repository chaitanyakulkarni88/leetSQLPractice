-- =========================================================
-- Problem: 584. Find Customer Referee
-- Category: Select
-- =========================================================
--
-- Core Query Logic:
-- Retrieve customer names where the referee_id is NOT equal to 2.
-- Customers with NULL referee_id must also be included.
--
-- Schema & Relationship Understanding:
-- Table: Customer
-- Columns:
--   id          (Primary Key)
--   name        (VARCHAR)
--   referee_id  (INT, nullable, self-reference to id)
--
-- Single-table query.
-- referee_id represents a self-referencing relationship.
--
-- Join Strategy Explanation:
-- No explicit JOIN required.
-- Although referee_id references Customer.id,
-- the problem only requires filtering, not relationship traversal.
--
-- Time Complexity Consideration:
-- O(n) table scan without indexing.
--
-- Indexing & Performance Thoughts:
-- If this table is large, an index on referee_id
-- could improve filtering performance.
--
-- Example:
-- CREATE INDEX idx_customer_referee
-- ON Customer(referee_id);
--
-- Edge Case Handling:
-- - Must explicitly include NULL referee_id values.
-- - Using "referee_id <> 2" alone would exclude NULL rows
--   because NULL comparisons evaluate to UNKNOWN.
--
-- Execution Order Reminder:
-- FROM → WHERE → SELECT
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT name
FROM Customer
WHERE referee_id <> 2
   OR referee_id IS NULL;