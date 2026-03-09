-- =========================================================
-- Problem: 185. Department Top Three Salaries
-- Category: Window Functions / Ranking
-- =========================================================
--
-- Core Query Logic:
-- For each department, retrieve employees whose salary
-- ranks within the top 3 salaries in that department.
--
-- If multiple employees share the same salary,
-- they should share the same rank and all be included.
--
-- Steps:
--   1. Join Employee and Department tables
--   2. Partition rows by department
--   3. Rank salaries within each department
--   4. Filter rows where rank <= 3
--
-- Schema Understanding:
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
-- Many employees belong to one department.
--
-- Window Function Strategy:
-- DENSE_RANK() OVER (
--     PARTITION BY departmentId
--     ORDER BY salary DESC
-- )
--
-- Explanation:
-- - PARTITION BY departmentId creates separate ranking
--   windows for each department.
-- - ORDER BY salary DESC ranks salaries from highest to lowest.
-- - DENSE_RANK() ensures employees with equal salaries share
--   the same rank without skipping numbers.
--
-- Example Ranking (per department):
--
-- department   employee   salary   rank
-- --------------------------------------
-- IT           Carol      90000     1
-- IT           Dave       85000     2
-- IT           John       85000     2
-- IT           Sam        80000     3
-- IT           Mike       75000     4
--
-- Employees with rank <= 3 should be returned.
--
-- Time Complexity Consideration:
-- O(n log n) due to sorting within partitions.
--
-- Indexing & Performance Thoughts:
-- Recommended index:
--
-- CREATE INDEX idx_employee_department_salary
-- ON Employee(departmentId, salary DESC);
--
-- Helps optimize partition sorting operations.
--
-- Edge Case Handling:
-- - Multiple employees with identical salaries
--   should share the same rank.
-- - Departments with fewer than 3 employees
--   should return all employees.
--
-- Execution Order Reminder:
-- FROM → JOIN → WINDOW FUNCTION → FILTER → SELECT
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT
    Department,
    Employee,
    Salary
FROM (
    SELECT
        d.name AS Department,
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