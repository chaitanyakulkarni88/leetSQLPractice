-- =========================================================
-- Problem: 1174. Immediate Food Delivery II
-- Category: Subqueries / Aggregation
-- =========================================================
--
-- Core Query Logic:
-- Compute the percentage of customers whose FIRST order
-- was delivered on their preferred delivery date.
--
-- Steps:
--   1. Identify first order per customer
--   2. Check if order_date = customer_pref_delivery_date
--   3. Compute percentage
--   4. Round to 2 decimal places
--
-- Schema & Relationship Understanding:
-- Table: Delivery
--   delivery_id                  (INT)
--   customer_id                  (INT)
--   order_date                   (DATE)
--   customer_pref_delivery_date  (DATE)
--
-- Each customer may have multiple orders.
--
-- Join Strategy Explanation:
-- Use subquery to find first order per customer:
--   MIN(order_date)
--
-- Then evaluate immediate delivery condition.
--
-- Time Complexity Consideration:
-- O(n) scan with grouping.
-- Subquery grouped by customer_id.
--
-- Indexing & Performance Thoughts:
-- Recommended index:
--
-- CREATE INDEX idx_delivery_customer_date
-- ON Delivery(customer_id, order_date);
--
-- This significantly improves MIN(order_date) grouping.
--
-- Edge Case Handling:
-- - Each customer has at least one order.
-- - Avoid integer division.
-- - ROUND result to 2 decimal places.
--
-- Execution Order Reminder:
-- FROM → JOIN → GROUP BY → SELECT
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT ROUND(
           SUM(d.order_date = d.customer_pref_delivery_date) * 100.0
           / COUNT(*),
           2
       ) AS immediate_percentage
FROM Delivery d
JOIN (
    SELECT customer_id,
           MIN(order_date) AS first_order_date
    FROM Delivery
    GROUP BY customer_id
) first_orders
  ON d.customer_id = first_orders.customer_id
 AND d.order_date = first_orders.first_order_date;