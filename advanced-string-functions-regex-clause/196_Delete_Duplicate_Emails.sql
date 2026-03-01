-- =========================================================
-- Problem: 196. Delete Duplicate Emails
-- Category: Data Modification / Self Join
-- =========================================================
--
-- Core Query Logic:
-- Delete duplicate email records, keeping only the record
-- with the smallest id for each email.
--
-- Steps:
--   1. Self-join Person table
--   2. Match rows with same email
--   3. Delete the row with larger id
--
-- Schema & Relationship Understanding:
-- Table: Person
--   id    (INT, Primary Key)
--   email (VARCHAR)
--
-- Duplicate emails may exist.
--
-- Join Strategy Explanation:
-- Self-join required to compare two rows
-- of the same table.
--
-- We delete the row where:
--   p1.email = p2.email
--   AND p1.id > p2.id
--
-- This ensures smallest id is preserved.
--
-- Time Complexity Consideration:
-- O(n²) worst-case without indexing.
-- With index on email → much faster.
--
-- Indexing & Performance Thoughts:
-- Recommended index:
--
-- CREATE INDEX idx_person_email
-- ON Person(email);
--
-- Improves duplicate detection performance.
--
-- Edge Case Handling:
-- - Only exact email matches considered duplicates.
-- - Primary key constraint ensures unique id.
-- - Safe because smallest id is retained.
--
-- Execution Order Reminder:
-- DELETE → JOIN → WHERE condition
--
-- Clean, Production-Ready SQL:
-- =========================================================

DELETE p1
FROM Person p1
JOIN Person p2
  ON p1.email = p2.email
 AND p1.id > p2.id;