-- =========================================================
-- Problem: 185. Department Top Three Salaries
-- Category: Window Functions / Ranking
-- =========================================================
--
-- Core Query Logic:
-- For each department, retrieve employees whose salary
-- ranks within the top 3 salaries in that department.
--
-- Important:
-- - If multiple employees share same salary,
--   they should share same rank.
-- - Use DENSE_RANK(), not ROW_NUMBER().
--
-- Steps:
--   1. Join Employee and Department tables
--   2. Apply DENSE_RANK() partitioned by department
--   3. Filter rank <= 3
--
-- Schema & Relationship Understanding:
-- Table: Employee
--   id            (INT, Primary Key)
--   name          (VARCHAR)
--   salary        (INT)
--   departmentId  (INT, FK → Department.id)
--
-- Table: Department
--   id    (INT, Primary Key)
--   name  (VARCHAR)
--
-- Relationship:
-- Many employees → one department
--
-- Join Strategy Explanation:
-- INNER JOIN is appropriate:
--   - Every employee belongs to a department.
--
-- Window function avoids correlated subqueries.
--
-- Time Complexity Consideration:
-- O(n log n) due to partitioned sorting.
--
-- Indexing & Performance Thoughts:
-- Recommended index:
--
-- CREATE INDEX idx_employee_department_salary
-- ON Employee(departmentId, salary DESC);
--
-- Helps with partition ordering.
--
-- Edge Case Handling:
-- - Ties must be handled correctly.
-- - Departments with fewer than 3 employees should
--   return all employees.
--
-- Execution Order Reminder:
-- FROM → JOIN → WINDOW → WHERE → SELECT
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT Department,
       Employee,
       Salary
FROM (
    SELECT d.name AS Department,
           e.name AS Employee,
           e.salary AS Salary,
           DENSE_RANK() OVER (
               PARTITION BY e.departmentId
               ORDER BY e.salary DESC
           ) AS salary_rank
    FROM Employee e
    JOIN Department d
      ON e.departmentId = d.id
) ranked
WHERE salary_rank <= 3;