-- =========================================================
-- Problem: 1907. Count Salary Categories
-- Category: Aggregation / Conditional Aggregation
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