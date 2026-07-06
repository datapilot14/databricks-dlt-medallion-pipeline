# Change Data Feed (CDF)

## Overview

**Change Data Feed (CDF)** is a **Delta Lake** feature that records **row-level changes** made to a Delta table. Instead of reprocessing the entire dataset, downstream pipelines can read only the incremental changes, making data processing faster and more efficient.

CDF is particularly useful for implementing **Change Data Capture (CDC)** workflows, where downstream systems need to identify records that were **inserted, updated, or deleted**.

---

# Why Use Change Data Feed?

### Without CDF

- Every pipeline execution scans the entire table.
- Increased compute costs and longer execution times.
- Difficult to identify which records have changed.
- Inefficient for large datasets.

### With CDF

- Read only changed records.
- Faster incremental processing.
- Lower compute costs.
- Easier audit and data lineage.
- Efficient synchronization between Bronze, Silver, and Gold layers.
- Better scalability for production workloads.

---

# What Information Does CDF Capture?

Whenever data changes in a Delta table, CDF records metadata such as:

- Inserted rows
- Updated rows
- Deleted rows
- Change type:
  - `insert`
  - `update_preimage`
  - `update_postimage`
  - `delete`
- Commit version
- Commit timestamp

This metadata allows downstream consumers to determine **what changed, when it changed, and how it changed**.

---

# Common Use Cases

- Incremental ETL/ELT pipelines
- Bronze → Silver → Gold data propagation
- Change Data Capture (CDC)
- Audit and compliance reporting
- Data synchronization
- Slowly Changing Dimensions (SCD)
- Streaming pipelines
- Near real-time analytics

---

# Enabling Change Data Feed

CDF can be enabled in multiple ways.

## 1. Enable While Creating a New Delta Table (Recommended)

```sql
CREATE TABLE orders (
    order_id INT,
    order_date STRING,
    customer_id INT,
    order_status STRING
)
USING DELTA
TBLPROPERTIES (
    delta.enableChangeDataFeed = true
);
```

---

## 2. Enable on an Existing Delta Table

```sql
ALTER TABLE orders
SET TBLPROPERTIES (
    delta.enableChangeDataFeed = true
);
```

---

## 3. Enable CDF by Default for New Delta Tables

```sql
SET spark.databricks.delta.properties.defaults.enableChangeDataFeed = true;
```

After setting this Spark configuration, **all newly created Delta tables** in the current Spark session will automatically have **Change Data Feed enabled**.

> **Note:** This configuration does **not** enable CDF retroactively on existing Delta tables.

---

# Reading Changes from a Delta Table

You can query change data by specifying a **starting table version** or **timestamp**.

### Example

```sql
SELECT *
FROM table_changes('orders', 5);
```

The above query returns **all row-level changes** beginning from **table version 5**.

---

# How CDF Supports Incremental MERGE Operations

A common production architecture looks like this:

```text
Source System
      │
      ▼
 Bronze Table
 (CDF Enabled)
      │
 Read Only Changed Rows
      │
      ▼
MERGE INTO Silver Table
      │
      ▼
Materialized View / Gold Layer
```

Instead of processing the entire Bronze table, downstream pipelines read **only the changes exposed by CDF** and apply them using **MERGE** operations.

This approach significantly improves performance and reduces processing time for large datasets.

---

# Benefits

- Efficient incremental data processing
- Tracks inserts, updates, and deletes at the row level
- Simplifies audit and compliance requirements
- Reduces processing time and compute costs
- Integrates seamlessly with **Delta Live Tables (DLT)** and **Structured Streaming**
- Enables scalable CDC-style data pipelines in the Lakehouse architecture

---

# CDF at a Glance

| **Feature** | **Description** |
|-------------|-----------------|
| **Purpose** | Track row-level changes in Delta tables |
| **Granularity** | Row level |
| **Captured Operations** | Insert, Update, Delete |
| **Metadata Available** | Change type, commit version, commit timestamp |
| **Best For** | Incremental processing and CDC pipelines |
| **Performance** | Reads only changed data instead of full tables |

---

# Best Practices

- Enable CDF during table creation whenever possible.
- Use CDF for incremental processing instead of full-table scans.
- Combine CDF with **MERGE** operations to build efficient Silver and Gold pipelines.
- Retain Delta table history according to your organization's data retention requirements.
- Use CDF with **Delta Live Tables (DLT)** to build scalable and production-ready Lakehouse pipelines.

---

# Project Usage

In this project, **Change Data Feed (CDF)** is used to support **incremental data processing** across the **Medallion Architecture**.

The pipeline reads only the changed records from the Bronze Delta tables and applies them to downstream Silver and Gold layers using **MERGE** operations. This eliminates unnecessary full-table scans, improves performance, reduces compute costs, and enables a scalable, production-ready data engineering solution.