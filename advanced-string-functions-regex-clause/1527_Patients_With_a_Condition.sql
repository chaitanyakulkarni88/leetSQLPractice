-- =========================================================
-- Problem: 1527. Patients With a Condition
-- Category: String Functions / Pattern Matching
-- =========================================================
--
-- Core Query Logic:
-- Retrieve patients whose conditions include
-- the code 'DIAB1'.
--
-- Important:
-- - Conditions are space-separated strings.
-- - 'DIAB1' must match as a complete token.
-- - Avoid matching partial codes like 'DIAB100'.
--
-- Steps:
--   1. Check if conditions start with 'DIAB1 '
--   2. OR contain ' DIAB1 '
--   3. OR end with ' DIAB1'
--   4. OR equal exactly 'DIAB1'
--
-- Schema & Relationship Understanding:
-- Table: Patients
--   patient_id  (INT)
--   patient_name (VARCHAR)
--   conditions  (VARCHAR)
--
-- Multiple conditions stored as space-separated codes.
--
-- Join Strategy Explanation:
-- Not applicable (single-table filtering).
--
-- Time Complexity Consideration:
-- O(n) full scan due to LIKE pattern.
--
-- Indexing & Performance Thoughts:
-- Index on conditions is not useful with leading wildcard.
-- In production:
--   - Normalize conditions into separate table.
--   - Use proper indexing or full-text search.
--
-- Edge Case Handling:
-- - Avoid partial matches (e.g., DIAB100).
-- - Ensure boundary-aware matching.
--
-- Execution Order Reminder:
-- FROM → WHERE → SELECT
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT patient_id,
       patient_name,
       conditions
FROM Patients
WHERE conditions = 'DIAB1'
   OR conditions LIKE 'DIAB1 %'
   OR conditions LIKE '% DIAB1'
   OR conditions LIKE '% DIAB1 %';