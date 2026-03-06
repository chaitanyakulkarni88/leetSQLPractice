-- =========================================================
-- Problem: 1661. Average Time of Process per Machine
-- Category: Aggregation / Self Join / Conditional Aggregation
-- =========================================================
--
-- Core Query Logic:
-- Each process generates exactly two rows:
--   - 'start' timestamp
--   - 'end' timestamp
--
-- We must:
--   1. Pair start and end records for each process
--   2. Compute process duration
--   3. Compute the average duration per machine
--   4. Round result to 3 decimal places
--
-- Duration formula:
--   processing_time = end_timestamp - start_timestamp
--
--
-- =========================================================
-- Schema & Relationship Understanding
-- =========================================================
--
-- Table: Activity
--
--   machine_id    INT
--   process_id    INT
--   activity_type ENUM ('start','end')
--   timestamp     FLOAT
--
-- Logical Composite Key:
--
--   (machine_id, process_id, activity_type)
--
-- Each process contains exactly:
--
--   1 start record
--   1 end record
--
--
-- =========================================================
-- APPROACH 1: Conditional Aggregation
-- =========================================================
--
-- Strategy:
-- Convert row events (start/end) into columns using
-- conditional aggregation.
--
-- For each process:
--
--   start_time = MAX(CASE WHEN activity_type='start' THEN timestamp END)
--   end_time   = MAX(CASE WHEN activity_type='end'   THEN timestamp END)
--
-- After extracting timestamps:
--
--   duration = end_time - start_time
--
-- Then compute average duration per machine.
--
-- Advantages:
--   ✔ No self join required
--   ✔ Clean logic
--   ✔ Efficient single table scan
--
-- Time Complexity:
--   O(n log n) due to GROUP BY
--
-- Execution Flow:
--
--   Activity table
--       ↓
--   GROUP BY (machine_id, process_id)
--       ↓
--   Extract start_time / end_time
--       ↓
--   Compute durations
--       ↓
--   GROUP BY machine_id
--       ↓
--   AVG(duration)
--
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

-- =========================================================
-- APPROACH 2: Self Join (Pair Start and End Rows)
-- =========================================================
--
-- Strategy:
-- Join the Activity table with itself to directly match
-- the 'start' row with the 'end' row for the same process.
--
-- Join Conditions:
--
--   same machine_id
--   same process_id
--
-- Then filter rows:
--
--   start.activity_type = 'start'
--   end.activity_type   = 'end'
--
-- After joining:
--
--   duration = end.timestamp - start.timestamp
--
-- Finally compute average duration per machine.
--
-- Advantages:
--   ✔ Conceptually simple
--
-- Execution Flow:
--
--   Activity (start rows)
--          JOIN
--   Activity (end rows)
--       ↓
--   matched process pairs
--       ↓
--   compute durations
--       ↓
--   GROUP BY machine_id
--
-- Time Complexity:
--
--   O(n log n)
--
-- Join efficiency improves with indexes.
--
-- =========================================================

SELECT a.machine_id,
       ROUND(AVG(b.timestamp - a.timestamp), 3) AS processing_time
FROM Activity a
JOIN Activity b
     ON a.machine_id = b.machine_id
    AND a.process_id = b.process_id
WHERE a.activity_type = 'start'
  AND b.activity_type = 'end'
GROUP BY a.machine_id;



-- =========================================================
-- Indexing & Performance Considerations
-- =========================================================
--
-- Ideal composite index:
--
--   CREATE INDEX idx_activity_machine_process
--   ON Activity(machine_id, process_id);
--
-- Even better covering index:
--
--   CREATE INDEX idx_activity_machine_process_type
--   ON Activity(machine_id, process_id, activity_type);
--
-- Benefits:
--
--   ✔ Faster grouping
--   ✔ Faster join matching
--   ✔ Reduced table scans
--
--
-- =========================================================
-- Edge Case Handling
-- =========================================================
--
-- Problem constraints guarantee:
--
--   exactly 1 start
--   exactly 1 end
--
-- If malformed data existed:
--
--   missing start → NULL start_time
--   missing end   → NULL end_time
--
-- Duration would become:
--
--   NULL
--
-- AVG ignores NULL values automatically.
--
--
-- =========================================================
-- SQL Logical Execution Order
-- =========================================================
--
-- Actual SQL processing order:
--
--   FROM
--   → JOIN
--   → WHERE
--   → GROUP BY
--   → SELECT
--   → ORDER BY
--
-- Subqueries execute before the outer query.