-- ============================================================
-- SILVER LAYER (CLEANED): Type casting, standardization,
-- and data-quality enforcement via DLT Expectations
-- ============================================================

CREATE OR REFRESH STREAMING TABLE orders_silver_cleaned (
  CONSTRAINT valid_order_id EXPECT (order_id IS NOT NULL)    ON VIOLATION DROP ROW,
  CONSTRAINT valid_customer EXPECT (customer_id IS NOT NULL) ON VIOLATION DROP ROW
)
AS
SELECT
  CAST(OrderID AS INT)         AS order_id,
  CAST(CustomerID AS INT)      AS customer_id,
  CAST(OrderDate AS DATE)      AS order_date,
  CAST(TotalAmount AS DOUBLE)  AS total_amount,
  INITCAP(TRIM(Status))        AS status,
  load_time
FROM STREAM(orders_bronze);

CREATE OR REFRESH STREAMING TABLE customers_silver_cleaned (
  CONSTRAINT valid_customer_id EXPECT (customer_id IS NOT NULL) ON VIOLATION DROP ROW
)
AS
SELECT
  CAST(CustomerID AS INT)        AS customer_id,
  INITCAP(TRIM(CustomerName))    AS customer_name,
  CAST(ContactNumber AS STRING)  AS contact_number,
  LOWER(TRIM(Email))             AS email,
  TRIM(Address)                  AS address,
  CAST(DateOfBirth AS DATE)      AS date_of_birth,
  load_time
FROM STREAM(customers_bronze);
