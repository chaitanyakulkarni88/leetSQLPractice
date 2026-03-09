-- =========================================================
-- Problem: 626. Exchange Seats
-- Category: Window Functions / Row Navigation
-- =========================================================
--
-- Core Query Logic:
-- Swap the seat assignments of every two consecutive students.
--
-- Rules:
--   - Seat 1 ↔ Seat 2
--   - Seat 3 ↔ Seat 4
--   - Seat 5 ↔ Seat 6
--   - If the total number of students is odd, the last seat
--     remains unchanged.
--
-- Steps:
--   1. Use LEAD() to access the next student
--   2. Use LAG() to access the previous student
--   3. Determine seat parity (odd/even)
--   4. Swap students accordingly
--
-- Schema Understanding:
-- Table: Seat
--   id      (INT, Primary Key)
--   student (VARCHAR)
--
-- Relationship:
-- Each row represents a seat assignment.
-- Seats are sequentially numbered.
--
-- Window Function Strategy:
-- LEAD(student) OVER (ORDER BY id)
-- LAG(student)  OVER (ORDER BY id)
--
-- Explanation:
-- - LEAD(student) retrieves the next student's name
-- - LAG(student) retrieves the previous student's name
-- - Odd seats take the next student
-- - Even seats take the previous student
--
-- Edge Case Handling:
-- - If the last seat is odd, LEAD() returns NULL
-- - We keep the original student in that case
--
-- Time Complexity Consideration:
-- O(n) scan with window navigation.
--
-- Indexing & Performance Thoughts:
-- Recommended index:
--
-- CREATE INDEX idx_seat_id
-- ON Seat(id);
--
-- Execution Order Reminder:
-- FROM → WINDOW FUNCTIONS → CASE → SELECT → ORDER BY
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT
    id,
    CASE
        WHEN id % 2 = 1 AND LEAD(student) OVER (ORDER BY id) IS NOT NULL
             THEN LEAD(student) OVER (ORDER BY id)
        WHEN id % 2 = 0
             THEN LAG(student) OVER (ORDER BY id)
        ELSE student
    END AS student
FROM Seat
ORDER BY id;