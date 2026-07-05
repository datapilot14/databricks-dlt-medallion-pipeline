-- ============================================================
-- BRONZE LAYER: Raw incremental ingestion with Auto Loader
-- Source: CSV files landing in a Unity Catalog Volume
-- ============================================================

CREATE OR REFRESH STREAMING TABLE orders_bronze
AS
SELECT
  *,re
  _metadata.file_name AS filename,
  current_timestamp() AS load_time
FROM cloud_files(
  '/Volumes/retail_catalog/retail/landing_vol/orders/',
  'csv',
  map("cloudFiles.inferColumnTypes", "true")
);

CREATE OR REFRESH STREAMING TABLE customers_bronze
AS
SELECT
  *,
  _metadata.file_name AS filename,
  current_timestamp() AS load_time
FROM cloud_files(
  '/Volumes/retail_catalog/retail/landing_vol/customers/',
  'csv',
  map("cloudFiles.inferColumnTypes", "true")
);
