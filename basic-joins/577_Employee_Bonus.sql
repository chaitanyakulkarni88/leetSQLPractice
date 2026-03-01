-- =========================================================
-- Problem: 577. Employee Bonus
-- Category: Basic Joins
-- =========================================================
--
-- Core Query Logic:
-- Retrieve employee names and bonus where:
--   - bonus < 1000
--   OR
--   - employee does not have a bonus record (NULL)
--
-- Requires:
--   1. LEFT JOIN from Employee → Bonus
--   2. Careful WHERE filtering to preserve NULL rows
--
-- Schema & Relationship Understanding:
-- Table: Employee
--   empId  (Primary Key)
--   name   (VARCHAR)
--   supervisor (INT)
--   salary (INT)
--
-- Table: Bonus
--   empId  (Foreign Key → Employee.empId)
--   bonus  (INT)
--
-- Relationship:
-- One employee may or may not have a bonus record.
--
-- Join Strategy Explanation:
-- LEFT JOIN is required because:
-- - We must return employees even if they have no bonus.
--
-- Important:
-- Filtering must include "bonus IS NULL" explicitly.
-- Otherwise, LEFT JOIN becomes effectively INNER JOIN.
--
-- Time Complexity Consideration:
-- O(n) relative to Employee table size.
-- Join cost depends on indexing.
--
-- Indexing & Performance Thoughts:
-- Ideal indexes:
--   Employee.empId → PRIMARY KEY
--   Bonus.empId → INDEX or PRIMARY KEY
--
-- Example:
-- CREATE INDEX idx_bonus_empid
-- ON Bonus(empId);
--
-- Edge Case Handling:
-- - Employees without bonus should be included.
-- - bonus < 1000 excludes NULL automatically,
--   so we explicitly include NULL via OR condition.
-- - Assumes bonus column is numeric.
--
-- Execution Order Reminder:
-- FROM → JOIN → WHERE → SELECT
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT e.name,
       b.bonus
FROM Employee e
LEFT JOIN Bonus b
       ON e.empId = b.empId
WHERE b.bonus < 1000
   OR b.bonus IS NULL;