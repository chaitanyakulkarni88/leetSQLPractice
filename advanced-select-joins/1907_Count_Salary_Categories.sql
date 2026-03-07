-- =========================================================
-- Problem: 1907. Count Salary Categories
-- Category: Aggregation / Conditional Aggregation / CASE + GROUP BY
-- =========================================================
--
-- Core Query Logic:
-- Categorize accounts into three salary bands:
--
--   Low Salary     → income < 20000
--   Average Salary → 20000 <= income <= 50000
--   High Salary    → income > 50000
--
-- Then count how many accounts fall into each category.
--
-- Important:
-- Even if a category has zero accounts,
-- it must still appear in output.
--
-- Schema & Relationship Understanding:
-- Table: Accounts
--   account_id (INT)
--   income     (INT)
--
-- Each row represents one account.
--
-- Join Strategy Explanation:
-- Not applicable (single table).
--
-- Strategy:
-- Use UNION ALL to guarantee presence of all 3 categories.
-- Use conditional COUNT for each.
--
-- Time Complexity Consideration:
-- O(n) table scan.
--
-- Indexing & Performance Thoughts:
-- Index on income can help if filtering frequently:
--
-- CREATE INDEX idx_accounts_income
-- ON Accounts(income);
--
-- However, full scan is typically required for aggregation.
--
-- Edge Case Handling:
-- - Boundaries inclusive at 20000 and 50000.
-- - Categories must appear even if count = 0.
-- - NULL income values automatically excluded.
--
-- Execution Order Reminder:
-- FROM → SELECT (CASE/COUNT)
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT 'Low Salary' AS category,
       COUNT(*) AS accounts_count
FROM Accounts
WHERE income < 20000

UNION ALL

SELECT 'Average Salary' AS category,
       COUNT(*) AS accounts_count
FROM Accounts
WHERE income BETWEEN 20000 AND 50000

UNION ALL

SELECT 'High Salary' AS category,
       COUNT(*) AS accounts_count
FROM Accounts
WHERE income > 50000;

=========================================================
-- CASE Categorization Strategy
-- =========================================================
--
-- The CASE expression converts numeric income values into
-- descriptive category labels.
--
-- Example transformation:
--
--   income = 15000  → 'Low Salary'
--   income = 30000  → 'Average Salary'
--   income = 70000  → 'High Salary'
--
-- This creates a derived column "category".
--
--
-- =========================================================
-- Aggregation Strategy
-- =========================================================
--
-- After categorization, we group rows by category
-- and count the number of accounts per category.
--
-- Example grouped result:
--
--   category        accounts_count
--   -------------------------------
--   Low Salary      3
--   Average Salary  5
--   High Salary     2
--
--
-- =========================================================
-- Time Complexity Consideration
-- =========================================================
--
-- The query performs a single scan of the Accounts table.
--
-- Complexity:
--
--   O(n)
--
-- GROUP BY operations may involve hashing or sorting
-- depending on the database engine.
--
--
-- =========================================================
-- Indexing & Performance Thoughts
-- =========================================================
--
-- Index on income may help if filtering frequently:
--
--   CREATE INDEX idx_accounts_income
--   ON Accounts(income);
--
-- However, for full-table aggregation,
-- the optimizer usually performs a full scan.
--
--
-- =========================================================
-- Edge Case Handling
-- =========================================================
--
-- IMPORTANT LIMITATION:
--
-- If a salary category has zero accounts,
-- that category will NOT appear in the result.
--
-- Example output might be:
--
--   Low Salary   → 3
--   High Salary  → 1
--
-- Missing category:
--
--   Average Salary
--
-- Therefore this solution does NOT fully satisfy
-- the original problem requirement unless combined
-- with a category table or UNION approach.
--
--
-- =========================================================
-- SQL Logical Execution Order
-- =========================================================
--
-- FROM Accounts
-- → SELECT CASE (categorize rows)
-- → GROUP BY category
-- → COUNT rows

SELECT category,
       COUNT(*) AS accounts_count
FROM (
    SELECT CASE
           WHEN income < 20000 THEN 'Low Salary'
           WHEN income <= 50000 THEN 'Average Salary'
           ELSE 'High Salary'
           END AS category
    FROM Accounts
) t
GROUP BY category;