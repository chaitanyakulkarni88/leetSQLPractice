-- =========================================================
-- Problem: 176. Second Highest Salary
-- Category: Window Functions / Ranking
-- =========================================================
--
-- Core Query Logic:
-- Retrieve the second highest salary from the Employee table.
--
-- If a second highest salary does not exist, return NULL.
--
-- Window functions allow us to rank salaries while preserving
-- row-level detail, making it easy to extract the desired rank.
--
-- Steps:
--   1. Rank salaries in descending order
--   2. Use DENSE_RANK() to handle duplicate salary values
--   3. Select the salary where rank = 2
--
-- Schema Understanding:
-- Table: Employee
--   id      (INT, Primary Key)
--   salary  (INT)
--
-- Relationship:
-- Each row represents an employee salary record.
-- Multiple employees may share the same salary value.
--
-- Window Function Strategy:
-- DENSE_RANK() OVER (ORDER BY salary DESC)
--
-- Explanation:
-- - ORDER BY salary DESC ranks highest salary first
-- - DENSE_RANK() ensures duplicate salaries share the same rank
-- - Unlike RANK(), DENSE_RANK() does not skip rank numbers
--
-- Example Ranking:
--
-- salary    dense_rank
-- ---------------------
-- 100          1
-- 100          1
-- 90           2
-- 80           3
--
-- The second highest salary corresponds to dense_rank = 2.
--
-- NULL Handling:
-- If no salary has rank = 2, the query should return NULL.
--
-- Time Complexity Consideration:
-- O(n log n) due to sorting for ranking.
--
-- Indexing & Performance Thoughts:
-- Recommended index:
--
-- CREATE INDEX idx_employee_salary
-- ON Employee(salary DESC);
--
-- Helps optimize ranking operations.
--
-- Edge Case Handling:
-- - Duplicate highest salaries should not affect ranking.
-- - If only one unique salary exists, result should be NULL.
--
-- Execution Order Reminder:
-- FROM → WINDOW FUNCTION → FILTER → SELECT
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT
    MAX(salary) AS SecondHighestSalary
FROM (
    SELECT salary,
           DENSE_RANK() OVER (
               ORDER BY salary DESC
           ) AS salary_rank
    FROM Employee
) ranked
WHERE salary_rank = 2;