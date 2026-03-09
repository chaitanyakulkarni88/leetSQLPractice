-- =========================================================
-- Problem: 197. Rising Temperature
-- Category: Window Functions / Navigation
-- =========================================================
--
-- Core Query Logic:
-- Find days where the temperature is higher than the
-- temperature of the previous calendar day.
--
-- Important:
-- Using LAG() alone compares the previous row, which may
-- not represent the previous day if there are gaps in dates.
--
-- Therefore we must also verify that the two records are
-- exactly one day apart.
--
-- Steps:
--   1. Order rows by recordDate
--   2. Use LAG() to retrieve:
--        - previous temperature
--        - previous date
--   3. Filter rows where:
--        - temperature increased
--        - date difference equals 1 day
--
-- Schema Understanding:
-- Table: Weather
--   id           (INT, Primary Key)
--   recordDate   (DATE)
--   temperature  (INT)
--
-- Relationship:
-- Each row represents temperature recorded on a specific day.
--
-- Window Function Strategy:
-- LAG(temperature) OVER (ORDER BY recordDate)
-- LAG(recordDate)  OVER (ORDER BY recordDate)
--
-- Explanation:
-- - LAG(temperature) retrieves the temperature of the
--   previous record in chronological order.
-- - LAG(recordDate) retrieves the previous date.
-- - DATEDIFF(recordDate, prev_date) ensures the rows
--   represent consecutive calendar days.
--
-- Example:
--
-- id   date        temp   prev_temp   prev_date
-- ----------------------------------------------
-- 1    Dec14       3      NULL        NULL
-- 2    Dec16       5      3           Dec14
--
-- DATEDIFF(Dec16, Dec14) = 2 → not consecutive
-- Therefore the row is excluded.
--
-- Time Complexity Consideration:
-- O(n) scan with ordered window processing.
--
-- Indexing & Performance Thoughts:
-- Recommended index:
--
-- CREATE INDEX idx_weather_recordDate
-- ON Weather(recordDate);
--
-- Improves ordering performance.
--
-- Edge Case Handling:
-- - First row has no previous day → ignored
-- - Missing days (date gaps) are excluded
--
-- Execution Order Reminder:
-- FROM → WINDOW FUNCTION → FILTER → SELECT
--
-- Clean, Production-Ready SQL:
-- =========================================================
SELECT id
FROM (
    SELECT id,
           recordDate,
           temperature,
           LAG(temperature) OVER (ORDER BY recordDate) AS prev_temp,
           LAG(recordDate) OVER (ORDER BY recordDate) AS prev_date
    FROM Weather
) t
WHERE temperature > prev_temp
AND DATEDIFF(recordDate, prev_date) = 1;