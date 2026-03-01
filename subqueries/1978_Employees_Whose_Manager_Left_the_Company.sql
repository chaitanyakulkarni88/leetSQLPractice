-- =========================================================
-- Problem: 1978. Employees Whose Manager Left the Company
-- Category: Self Join / Filtering
-- =========================================================
--
-- Core Query Logic:
-- Find employees:
--   - whose manager_id is NOT NULL
--   - but that manager_id does NOT exist in Employees table
--   - and salary < 30000
--
-- Steps:
--   1. LEFT JOIN Employees table to itself
--   2. Match e.manager_id = m.employee_id
--   3. Filter rows where:
--        m.employee_id IS NULL
--        AND e.manager_id IS NOT NULL
--        AND e.salary < 30000
--
-- Schema & Relationship Understanding:
-- Table: Employees
--   employee_id (INT, Primary Key)
--   name        (VARCHAR)
--   manager_id  (INT, nullable)
--   salary      (INT)
--
-- Relationship:
-- Self-referencing hierarchy:
--   manager_id → employee_id
--
-- Join Strategy Explanation:
-- LEFT JOIN required because:
--   - We want to detect missing managers.
--   - If manager does not exist,
--     joined row will be NULL.
--
-- INNER JOIN would eliminate those rows,
-- which is incorrect.
--
-- Time Complexity Consideration:
-- O(n) scan with join.
-- Performance depends on indexing of employee_id.
--
-- Indexing & Performance Thoughts:
-- Recommended index:
--
-- CREATE INDEX idx_employees_manager
-- ON Employees(manager_id);
--
-- employee_id should be PRIMARY KEY.
--
-- Edge Case Handling:
-- - Employees with NULL manager_id are excluded.
-- - Only employees with salary < 30000 are considered.
-- - Proper NULL handling is critical.
--
-- Execution Order Reminder:
-- FROM → LEFT JOIN → WHERE → SELECT → ORDER BY
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT e.employee_id
FROM Employees e
LEFT JOIN Employees m
       ON e.manager_id = m.employee_id
WHERE e.manager_id IS NOT NULL
  AND m.employee_id IS NULL
  AND e.salary < 30000
ORDER BY e.employee_id;