-- ============================================================
-- GOLD LAYER: Business-ready customer metrics
-- Joins orders + current customer version (SCD2 active rows)
-- ============================================================

CREATE OR REFRESH MATERIALIZED VIEW customer_orders_gold
AS
SELECT
  c.customer_id,
  c.customer_name,
  c.address,
  COUNT(o.order_id)    AS total_orders,
  SUM(o.total_amount)  AS total_spent
FROM orders_silver o
JOIN customers_silver c
  ON o.customer_id = c.customer_id
WHERE c.`__END_AT` IS NULL
GROUP BY c.customer_id, c.customer_name, c.address;
