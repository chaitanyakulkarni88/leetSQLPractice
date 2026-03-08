-- =========================================================
-- Problem: 196. Delete Duplicate Emails
-- Category: Window Functions / Data Deduplication
-- =========================================================
--
-- Core Query Logic:
-- Remove duplicate email records from the Person table,
-- keeping only the record with the smallest id for each email.
--
-- Window functions allow us to assign a ranking to rows
-- within each email group so duplicates can be identified
-- and removed safely.
--
-- Steps:
--   1. Partition rows by Email
--   2. Use ROW_NUMBER() to assign order within each partition
--   3. Keep the first occurrence (lowest id)
--   4. Delete rows where row_number > 1
--
-- Schema Understanding:
-- Table: Person
--   id     (INT, Primary Key)
--   email  (VARCHAR)
--
-- Relationship:
-- Each row represents a person record.
-- Multiple rows may contain the same email.
--
-- Window Function Strategy:
-- ROW_NUMBER() OVER (PARTITION BY email ORDER BY id)
--
-- Explanation:
-- - PARTITION BY email groups rows with the same email
-- - ORDER BY id ensures the smallest id is ranked first
-- - ROW_NUMBER() assigns sequential numbers inside each partition
--
-- Example Window Partition:
--
-- id   email        row_number
-- ----------------------------
-- 1    a@b.com           1
-- 3    a@b.com           2
-- 2    c@d.com           1
--
-- Rows where row_number > 1 are duplicates.
--
-- Deletion Logic:
-- Keep row_number = 1
-- Delete row_number > 1
--
-- Time Complexity Consideration:
-- O(n log n) due to partition sorting.
--
-- Indexing & Performance Thoughts:
-- Recommended index:
--
-- CREATE INDEX idx_person_email_id
-- ON Person(email, id);
--
-- Improves partition ordering efficiency.
--
-- Edge Case Handling:
-- - Emails with only one record remain untouched.
-- - When duplicates exist, the smallest id is preserved.
--
-- Execution Order Reminder:
-- FROM → WINDOW FUNCTION → FILTER → DELETE
--
-- Clean, Production-Ready SQL:
-- =========================================================

DELETE FROM Person
WHERE id IN (
    SELECT id
    FROM (
        SELECT id,
               ROW_NUMBER() OVER (
                   PARTITION BY email
                   ORDER BY id
               ) AS row_num
        FROM Person
    ) ranked
    WHERE row_num > 1
);