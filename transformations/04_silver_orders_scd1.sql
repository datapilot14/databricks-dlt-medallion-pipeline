-- ============================================================
-- SILVER LAYER (FACT): Orders as SCD Type 1
-- Latest state only — updates overwrite in place
-- ============================================================

CREATE OR REFRESH STREAMING TABLE orders_silver;

APPLY CHANGES INTO orders_silver
FROM STREAM(orders_silver_cleaned)
KEYS (order_id)
SEQUENCE BY load_time
STORED AS SCD TYPE 1;
