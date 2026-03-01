-- =========================================================
-- Problem: 1251. Average Selling Price
-- Category: Advanced Select and Joins / Aggregation
-- =========================================================
--
-- Core Query Logic:
-- Compute the average selling price per product.
--
-- Important:
-- Each price record applies only within its date range.
-- Units sold must be multiplied by the corresponding price.
--
-- Formula:
--   average_price =
--     SUM(price * units) / SUM(units)
--
-- If a product has no sales → return 0.
--
-- Schema & Relationship Understanding:
-- Table: Prices
--   product_id (INT)
--   start_date (DATE)
--   end_date   (DATE)
--   price      (INT)
--
-- Table: UnitsSold
--   product_id   (INT)
--   purchase_date (DATE)
--   units         (INT)
--
-- Relationship:
-- UnitsSold must match Prices where:
--   UnitsSold.product_id = Prices.product_id
--   AND purchase_date BETWEEN start_date AND end_date
--
-- Join Strategy Explanation:
-- LEFT JOIN ensures products with no sales appear.
-- Range join required on date interval.
--
-- Time Complexity Consideration:
-- Potentially expensive due to range join.
-- Performance depends on indexing and data size.
--
-- Indexing & Performance Thoughts:
-- Recommended indexes:
--
-- CREATE INDEX idx_prices_product_date
-- ON Prices(product_id, start_date, end_date);
--
-- CREATE INDEX idx_units_product_date
-- ON UnitsSold(product_id, purchase_date);
--
-- Range joins are costly at scale.
-- Consider partitioning by product_id in large systems.
--
-- Edge Case Handling:
-- - Products with no matching sales → average_price = 0.
-- - Division by zero prevented via NULLIF.
-- - Assumes price ranges do not overlap.
--
-- Execution Order Reminder:
-- FROM → JOIN (range condition) → GROUP BY → SELECT
--
-- Clean, Production-Ready SQL:
-- =========================================================

SELECT p.product_id,
       ROUND(
           COALESCE(
               SUM(p.price * u.units) / NULLIF(SUM(u.units), 0),
               0
           ),
           2
       ) AS average_price
FROM Prices p
LEFT JOIN UnitsSold u
       ON p.product_id = u.product_id
      AND u.purchase_date BETWEEN p.start_date AND p.end_date
GROUP BY p.product_id;