-- ============================================================
-- SILVER LAYER (DIMENSION): Customers as SCD Type 2
-- Full change history preserved with __START_AT / __END_AT
-- Declarative CDC — no manual MERGE logic
-- ============================================================

CREATE OR REFRESH STREAMING TABLE customers_silver;

APPLY CHANGES INTO customers_silver
FROM STREAM(customers_silver_cleaned)
KEYS (customer_id)
SEQUENCE BY load_time
STORED AS SCD TYPE 2;
