-- =========================================================
-- Problem: 1731. The Number of Employees Which Report to Each Employee
-- Category: Advanced Select and Joins / Aggregation
-- =========================================================
--
-- Core Query Logic:
-- For each manager, compute:
--   - reports_count → number of direct reports
--   - average_age   → average age of direct reports (rounded)
--
-- Steps:
--   1. Self-join Employees table
--   2. Match manager.employee_id = employee.reports_to
--   3. GROUP BY manager
--   4. COUNT direct reports
--   5. AVG age of reports
--
-- Schema & Relationship Understanding:
-- Table: Employees
--   employee_id (INT, Primary Key)
--   name        (VARCHAR)
--   reports_to  (INT, nullable, FK → employee_id)
--   age         (INT)
--
-- Relationship:
-- Self-referencing hierarchy:
--   employees.reports_to → employees.employee_id
--
-- Join Strategy Explanation:
-- INNER JOIN is appropriate because:
--   - We only return employees who have at least one direct report.
--   - Employees without reports are excluded per problem.
--
-- Time Complexity Consideration:
-- O(n) scan with grouping.
-- Performance depends on indexing of reports_to.
--
-- Indexing & Performance Thoughts:
-- Critical index:
--
-- CREATE INDEX idx_employees_reports_to
-- ON Employees(reports_to);
--
-- This improves join efficiency significantly.
--
-- Edge Case Handling:
-- - Only direct reports counted (not indirect hierarchy).
-- - ROUND average age to nearest integer.
-- - AVG ignores NULL ages automatically.
-- - Employees without reports are excluded.
--
-- Execution Order Reminder:
-- FROM → JOIN → GROUP BY → SELECT → ORDER BY
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT m.employee_id,
       m.name,
       COUNT(e.employee_id) AS reports_count,
       ROUND(AVG(e.age)) AS average_age
FROM Employees m
INNER JOIN Employees e
        ON m.employee_id = e.reports_to
GROUP BY m.employee_id, m.name
ORDER BY m.employee_id;