-- =========================================================
-- Problem: 176. Second Highest Salary
-- Category: Select / Ranking
-- =========================================================
--
-- Core Query Logic:
-- Retrieve the second highest DISTINCT salary.
--
-- Requirements:
--   - If no second highest salary exists → return NULL.
--
-- Steps:
--   1. Select DISTINCT salaries
--   2. Order descending
--   3. Skip highest (OFFSET 1)
--   4. Limit 1
--
-- Schema & Relationship Understanding:
-- Table: Employee
--   id     (INT, Primary Key)
--   salary (INT)
--
-- Multiple employees may share same salary.
--
-- Join Strategy Explanation:
-- Not applicable (single-table ranking).
--
-- Time Complexity Consideration:
-- O(n log n) due to sorting.
--
-- Indexing & Performance Thoughts:
-- Recommended index:
--
-- CREATE INDEX idx_employee_salary
-- ON Employee(salary);
--
-- Improves sorting performance.
--
-- Edge Case Handling:
-- - Use DISTINCT to avoid duplicate salary values.
-- - If only one unique salary exists → return NULL.
-- - LIMIT + OFFSET ensures correct ranking.
--
-- Execution Order Reminder:
-- FROM → SELECT DISTINCT → ORDER BY → LIMIT/OFFSET
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT (
    SELECT DISTINCT salary
    FROM Employee
    ORDER BY salary DESC
    LIMIT 1 OFFSET 1
) AS SecondHighestSalary;