-- =========================================================
-- Problem: 197. Rising Temperature
-- Category: Window Functions / Navigation
-- =========================================================
--
-- Core Query Logic:
-- Identify days where the temperature is higher than the
-- previous day.
--
-- We compare the current day's temperature with the
-- previous day's temperature.
--
-- Steps:
--   1. Order rows by date
--   2. Use LAG() to access the previous day's temperature
--   3. Filter rows where temperature > previous_temperature
--   4. Return the corresponding id
--
-- Schema Understanding:
-- Table: Weather
--   id           (INT, Primary Key)
--   recordDate   (DATE)
--   temperature  (INT)
--
-- Relationship:
-- Each row represents the temperature recorded on a day.
-- Rows must be ordered chronologically to compare days.
--
-- Window Function Strategy:
-- LAG(temperature) OVER (ORDER BY recordDate)
--
-- Explanation:
-- - ORDER BY recordDate ensures chronological comparison
-- - LAG() retrieves the temperature from the previous row
-- - If current temperature > previous temperature,
--   then the temperature increased
--
-- Example:
--
-- id   date        temp   prev_temp
-- ----------------------------------
-- 1    Jan1        10     NULL
-- 2    Jan2        25     10    ← rising
-- 3    Jan3        20     25
-- 4    Jan4        30     20    ← rising
--
-- Result ids:
-- 2, 4
--
-- Time Complexity Consideration:
-- O(n) scan with ordered window processing.
--
-- Indexing & Performance Thoughts:
-- Recommended index:
--
-- CREATE INDEX idx_weather_recorddate
-- ON Weather(recordDate);
--
-- Helps optimize ordering.
--
-- Edge Case Handling:
-- - First row has no previous temperature
-- - Only compare rows where a previous day exists
--
-- Execution Order Reminder:
-- FROM → WINDOW FUNCTION → FILTER → SELECT
--
-- Clean, Production-Ready SQL:
-- =========================================================
SELECT id
FROM (
    SELECT id,
           temperature,
           LAG(temperature) OVER (ORDER BY recordDate) AS prev_temp
    FROM Weather
) t
WHERE temperature > prev_temp;