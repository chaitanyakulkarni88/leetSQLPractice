-- =========================================================
-- Problem: 1789. Primary Department for Each Employee
-- Category: Aggregation / Conditional Filtering
-- =========================================================
--
-- Core Query Logic:
-- Each employee may belong to multiple departments.
--
-- Rules:
--   1. If an employee has only ONE department,
--      that department is primary.
--   2. If multiple departments exist,
--      choose the one where primary_flag = 'Y'.
--
-- Goal:
-- Return exactly one department per employee.
--
-- Schema & Relationship Understanding:
-- Table: Employee
--   employee_id  (INT)
--   department_id (INT)
--   primary_flag ('Y' / 'N')
--
-- Relationship:
-- One employee → one or more departments.
--
-- Join Strategy Explanation:
-- Not applicable (single-table logic).
--
-- Strategy:
-- Use GROUP BY to detect employees with one department.
-- OR directly filter:
--   - primary_flag = 'Y'
--   - OR employee has only one row.
--
-- Time Complexity Consideration:
-- O(n) scan with grouping.
--
-- Indexing & Performance Thoughts:
-- Recommended index:
--
-- CREATE INDEX idx_employee_empid
-- ON Employee(employee_id);
--
-- If frequently filtering by primary_flag:
-- CREATE INDEX idx_employee_empid_flag
-- ON Employee(employee_id, primary_flag);
--
-- Edge Case Handling:
-- - Employee with one department and primary_flag = 'N'
--   must still return that department.
-- - Employee with multiple departments must have exactly
--   one primary_flag = 'Y'.
-- - Assumes data integrity guarantees one 'Y' per multi-dept employee.
--
-- Execution Order Reminder:
-- FROM → WHERE → SELECT
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT employee_id,
       department_id
FROM Employee
WHERE primary_flag = 'Y'
   OR employee_id IN (
        SELECT employee_id
        FROM Employee
        GROUP BY employee_id
        HAVING COUNT(*) = 1
   );