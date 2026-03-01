-- =========================================================
-- Problem: 1075. Project Employees I
-- Category: Basic Joins / Aggregation
-- =========================================================
--
-- Core Query Logic:
-- For each project, compute the average years of experience
-- of employees working on that project.
--
-- Steps:
--   1. Join Project and Employee tables
--   2. Group by project_id
--   3. Compute AVG(experience_years)
--   4. Round result to 2 decimal places
--
-- Schema & Relationship Understanding:
-- Table: Project
--   project_id   (INT)
--   employee_id  (INT, Foreign Key → Employee.employee_id)
--
-- Table: Employee
--   employee_id      (Primary Key)
--   name             (VARCHAR)
--   experience_years (INT)
--
-- Relationship:
-- Many-to-one:
--   Many employees can belong to the same project.
--
-- Join Strategy Explanation:
-- INNER JOIN is appropriate because:
--   - Only employees assigned to projects are relevant.
--   - We only care about projects that have employees.
--
-- Time Complexity Consideration:
-- O(n) relative to Project table.
-- Join efficiency depends on indexing.
--
-- Indexing & Performance Thoughts:
-- Recommended indexes:
--
-- CREATE INDEX idx_project_employee
-- ON Project(employee_id);
--
-- Employee.employee_id should be PRIMARY KEY.
--
-- Grouping by project_id benefits from indexing if dataset is large.
--
-- Edge Case Handling:
-- - Assumes each project has at least one employee.
-- - AVG automatically ignores NULL experience values.
-- - ROUND required to 2 decimal places.
--
-- Execution Order Reminder:
-- FROM → JOIN → GROUP BY → SELECT
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT p.project_id,
       ROUND(AVG(e.experience_years), 2) AS average_years
FROM Project p
INNER JOIN Employee e
        ON p.employee_id = e.employee_id
GROUP BY p.project_id;