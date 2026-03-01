-- =========================================================
-- Problem: 570. Managers with at Least 5 Direct Reports
-- Category: Advanced Select and Joins / Aggregation
-- =========================================================
--
-- Core Query Logic:
-- Identify employees who manage at least 5 direct reports.
--
-- Steps:
--   1. Self-join Employee table
--   2. Match manager.id = employee.managerId
--   3. GROUP BY manager
--   4. Filter using HAVING COUNT >= 5
--
-- Schema & Relationship Understanding:
-- Table: Employee
--   id         (Primary Key)
--   name       (VARCHAR)
--   department (VARCHAR)
--   managerId  (INT, nullable, self-reference to id)
--
-- Relationship:
-- Self-referencing hierarchy:
--   Employee.managerId → Employee.id
--
-- Join Strategy Explanation:
-- Self-join is required because:
--   - We need to match employees to their managers.
--
-- INNER JOIN is appropriate because:
--   - Only employees who have direct reports are relevant.
--
-- Time Complexity Consideration:
-- O(n) scan with grouping.
-- Performance depends on indexing of managerId.
--
-- Indexing & Performance Thoughts:
-- Critical index:
--   CREATE INDEX idx_employee_manager
--   ON Employee(managerId);
--
-- This allows efficient grouping and join lookup.
--
-- Edge Case Handling:
-- - Employees with NULL managerId are excluded automatically.
-- - Only direct reports are counted (not indirect).
-- - Assumes each employee has at most one manager.
--
-- Execution Order Reminder:
-- FROM → JOIN → GROUP BY → HAVING → SELECT
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT m.name
FROM Employee m
INNER JOIN Employee e
        ON m.id = e.managerId
GROUP BY m.id, m.name
HAVING COUNT(e.id) >= 5;