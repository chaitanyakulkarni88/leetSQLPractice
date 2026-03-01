-- =========================================================
-- Problem: 1280. Students and Examinations
-- Category: Advanced Select and Joins / Aggregation
-- =========================================================
--
-- Core Query Logic:
-- For every student and every subject,
-- count how many exams they attended.
--
-- Even if a student never attended a subject,
-- the result must include that combination with count = 0.
--
-- Steps:
--   1. Generate all possible (student, subject) pairs
--   2. LEFT JOIN with Examinations
--   3. COUNT exam records
--   4. GROUP BY student and subject
--
-- Schema & Relationship Understanding:
-- Table: Students
--   student_id   (Primary Key)
--   student_name (VARCHAR)
--
-- Table: Subjects
--   subject_name (Primary Key)
--
-- Table: Examinations
--   student_id   (Foreign Key → Students.student_id)
--   subject_name (Foreign Key → Subjects.subject_name)
--
-- Relationship:
-- Many-to-many between Students and Subjects via Examinations.
--
-- Join Strategy Explanation:
-- CROSS JOIN between Students and Subjects
-- ensures all possible combinations.
--
-- Then LEFT JOIN Examinations
-- to count actual attendance.
--
-- INNER JOIN would incorrectly remove zero-attendance rows.
--
-- Time Complexity Consideration:
-- O(S × Sub) for cross join size.
-- Performance depends on table sizes.
--
-- Indexing & Performance Thoughts:
-- Important index:
--   CREATE INDEX idx_exams_student_subject
--   ON Examinations(student_id, subject_name);
--
-- This improves join and grouping efficiency.
--
-- Edge Case Handling:
-- - Students with zero exams must still appear.
-- - Subjects never attended must still appear.
-- - COUNT(ex.student_id) correctly returns 0 for NULL matches.
--
-- Execution Order Reminder:
-- FROM → CROSS JOIN → LEFT JOIN → GROUP BY → SELECT → ORDER BY
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT s.student_id,
       s.student_name,
       sub.subject_name,
       COUNT(e.student_id) AS attended_exams
FROM Students s
CROSS JOIN Subjects sub
LEFT JOIN Examinations e
       ON s.student_id = e.student_id
      AND sub.subject_name = e.subject_name
GROUP BY s.student_id,
         s.student_name,
         sub.subject_name
ORDER BY s.student_id,
         sub.subject_name;