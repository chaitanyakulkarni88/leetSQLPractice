-- =========================================================
-- Problem: 1661. Average Time of Process per Machine
-- Category: Subqueries / Aggregation
-- =========================================================
--
-- Core Query Logic:
-- Each process has exactly two records:
--   - start timestamp
--   - end timestamp
--
-- Steps:
--   1. Pair start and end timestamps per machine_id & process_id
--   2. Compute duration (end - start)
--   3. Compute average duration per machine_id
--   4. Round result to 3 decimal places
--
-- Schema & Relationship Understanding:
-- Table: Activity
--   machine_id    (INT)
--   process_id    (INT)
--   activity_type (ENUM: 'start', 'end')
--   timestamp     (FLOAT)
--
-- Composite logical key:
--   (machine_id, process_id)
--
-- Each process has exactly one 'start' and one 'end'.
--
-- Join Strategy Explanation:
-- Instead of self-joining twice, we:
--   - Use conditional aggregation
--   - Extract start and end timestamps per process
--   - Use a derived table (subquery)
--
-- This avoids unnecessary joins and improves clarity.
--
-- Time Complexity Consideration:
-- O(n) scan of Activity table.
-- GROUP BY on (machine_id, process_id).
--
-- Performance depends on grouping efficiency.
--
-- Indexing & Performance Thoughts:
-- Ideal composite index:
--   CREATE INDEX idx_activity_machine_process
--   ON Activity(machine_id, process_id);
--
-- This improves grouping performance significantly.
--
-- Edge Case Handling:
-- - Assumes exactly one start and one end per process.
-- - If malformed data exists (missing start/end),
--   duration would become NULL.
-- - ROUND required to 3 decimal places.
--
-- Execution Order Reminder:
-- FROM → GROUP BY → SELECT → OUTER GROUP BY
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT machine_id,
       ROUND(AVG(end_time - start_time), 3) AS processing_time
FROM (
    SELECT machine_id,
           process_id,
           MAX(CASE WHEN activity_type = 'start' THEN timestamp END) AS start_time,
           MAX(CASE WHEN activity_type = 'end'   THEN timestamp END) AS end_time
    FROM Activity
    GROUP BY machine_id, process_id
) AS process_durations
GROUP BY machine_id;