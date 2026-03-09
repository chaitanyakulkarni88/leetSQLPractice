-- =========================================================
-- Problem: 184. Department Highest Salary
-- Category: Window Functions / Ranking
-- =========================================================
--
-- Core Query Logic:
-- For each department, retrieve employees who have the
-- highest salary within their department.
--
-- If multiple employees share the same highest salary,
-- they should all be included in the result.
--
-- Steps:
--   1. Join Employee and Department tables
--   2. Partition rows by department
--   3. Rank salaries within each department
--   4. Select rows where rank = 1
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
-- - PARTITION BY departmentId creates a separate ranking
--   window for each department.
-- - ORDER BY salary DESC ranks highest salaries first.
-- - DENSE_RANK() ensures employees with identical salaries
--   share the same rank.
--
-- Example Ranking (per department):
--
-- department   employee   salary   rank
-- --------------------------------------
-- HR           Bob        7000     1
-- HR           Alice      5000     2
-- IT           Carol      8000     1
-- IT           Dave       8000     1
-- IT           John       6000     2
--
-- Rows where rank = 1 represent the highest salary
-- in each department.
--
-- Time Complexity Consideration:
-- O(n log n) due to partition sorting.
--
-- Indexing & Performance Thoughts:
-- Recommended index:
--
-- CREATE INDEX idx_employee_department_salary
-- ON Employee(departmentId, salary DESC);
--
-- Helps optimize partition ordering.
--
-- Edge Case Handling:
-- - Multiple employees sharing the highest salary
--   should all be returned.
-- - Departments with a single employee should still
--   return that employee.
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
WHERE salary_rank = 1;