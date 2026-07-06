# Delta Live Tables (DLT)
## What is Delta Live Tables (DLT)?

Delta Live Tables (DLT) is a managed ETL framework in Databricks that enables you to build reliable, scalable, and production-ready data pipelines using a declarative programming approach.

Rather than writing code to manage the entire pipeline infrastructure, you define what transformations should happen, and DLT automatically manages how they are executed.

## What is Declarative Programming?

In a declarative approach, you specify what you want to achieve, not how to perform each step.

**Example:**

Imperative: Write code to create tables, manage dependencies, schedule execution, and handle failures.
Declarative (DLT): Define the target tables and transformations; DLT determines the execution order and manages the pipeline automatically.
Traditional ETL Challenges

Building ETL pipelines traditionally requires handling many operational tasks in addition to writing transformation logic:

- Data extraction, transformation, and loading (ETL)
- Pipeline orchestration
- Infrastructure provisioning and auto-scaling
- Dependency management
- Batch and streaming pipeline handling
- Data quality validation
- Failure handling and automatic retries
- Data lineage tracking
- Pipeline monitoring and optimization
- Deployment across Development, Test, and Production environments

In traditional ETL, a significant amount of engineering effort is spent on pipeline management and tooling, rather than on implementing business logic.

## How DLT Solves These Challenges

DLT automates much of the operational complexity, allowing data engineers to focus on data transformations.

### Key capabilities include:

- Declarative pipeline development (SQL or Python)
- Automatic dependency resolution
- Built-in orchestration
- Automatic infrastructure management and auto-scaling
- Unified support for batch and streaming workloads
- Built-in data quality expectations
- Automatic retries and failure recovery
- Data lineage and pipeline monitoring
- Native support for Slowly Changing Dimensions (SCD Type 1 & Type 2)
- Easy deployment and maintenance
- How DLT Works

### The development workflow is simple:

- Write declarative transformations using SQL or Python.
- Create a Delta Live Tables pipeline in Databricks.
- DLT automatically:
- Determines execution order
- Resolves dependencies
- Executes transformations
- Monitors pipeline health
- Manages compute resources
- Updates target Delta tables

```
Source Data
      │
      ▼
Write DLT Code (SQL / Python)
      │
      ▼
Create DLT Pipeline
      │
      ▼
DLT Handles Execution
      │
      ├── Dependency Management
      ├── Orchestration
      ├── Auto Scaling
      ├── Data Quality
      ├── Lineage
      ├── Monitoring
      └── Failure Recovery
      │
      ▼
Bronze → Silver → Gold Tables
```
## Why Use DLT?
- Simplifies ETL pipeline development.
- Reduces operational overhead.
- Improves reliability and maintainability.
- Supports production-scale batch and streaming pipelines.
- Enables faster development by allowing engineers to focus on business logic instead of infrastructure.

# Core Abstractions in Delta Live Tables (DLT)

**Delta Live Tables (DLT)** provides two primary abstractions for building reliable ETL pipelines:

- **Streaming Tables** – For incremental data ingestion
- **Materialized Views** – For data transformations and analytical datasets

These abstractions define how data is processed, refreshed, and managed within a DLT pipeline.

---

# 1. Streaming Table

A **Streaming Table** is a Delta table that continuously ingests and processes new data as it arrives. Instead of reprocessing the entire dataset during each pipeline execution, DLT processes only the newly available records, making it highly efficient for real-time and high-volume workloads.

## Characteristics

- **Backed by** a Delta table
- **Continuously** ingests new data
- **Incremental** processing
- Supports both **streaming** and **incremental batch** sources
- Low latency and highly scalable
- Avoids expensive full-table recomputation

## Common Use Cases

- Auto Loader ingestion
- Kafka event streams
- IoT data ingestion
- Change Data Feed (CDF)
- Change Data Capture (CDC) pipelines
- Bronze layer ingestion

---

# 2. Materialized View

A **Materialized View** is a Delta table that stores the physical result of a transformation query. Unlike a standard SQL view, the transformed data is persisted, enabling faster query performance.

Whenever the upstream data changes, DLT automatically refreshes the Materialized View by recomputing the affected results.

## Characteristics

- Stores the output of transformation queries
- Physically materialized as a Delta table
- Automatically refreshed by DLT
- Optimized for analytical workloads
- Ideal for deterministic transformations, joins, and aggregations

## Common Use Cases

- Silver layer transformations
- Gold layer aggregations
- Business KPI tables
- Reporting datasets
- Feature tables for Machine Learning

---

# Streaming Table vs Materialized View

| **Feature** | **Streaming Table** | **Materialized View** |
|-------------|---------------------|------------------------|
| **Processing Model** | Incremental | Recomputed as needed |
| **Data Source** | Streaming or incremental sources | Existing Delta tables |
| **Primary Purpose** | Continuous data ingestion | Data transformation and aggregation |
| **Storage** | Delta Table | Delta Table |
| **Performance** | Optimized for ingestion | Optimized for analytics |
| **Typical Medallion Layer** | Bronze | Silver / Gold |

---

# When to Use a Streaming Table

Use a **Streaming Table** when you need to:

- Continuously ingest incoming data
- Process real-time or high-volume event streams
- Minimize processing latency
- Avoid full-table recomputation
- Build the **Bronze** layer of a Medallion Architecture

---

# When to Use a Materialized View

Use a **Materialized View** when you need to:

- Clean and transform existing Delta tables
- Join multiple datasets
- Aggregate data for reporting
- Create **Silver** and **Gold** datasets
- Serve BI dashboards or Machine Learning features

---

# Typical DLT Pipeline

```text
Source Files / Kafka / CDF
            │
            ▼
     Streaming Table
      (Bronze Layer)
            │
            ▼
    Materialized View
      (Silver Layer)
            │
            ▼
    Materialized View
       (Gold Layer)
```

---

# Medallion Architecture in DLT

| **Layer** | **Recommended DLT Object** | **Purpose** |
|-----------|----------------------------|-------------|
| **Bronze** | Streaming Table | Incremental ingestion of raw data |
| **Silver** | Materialized View | Data cleansing, validation, enrichment |
| **Gold** | Materialized View | Business-ready datasets, KPIs, and aggregations |

---

# Best Practices

- Use **Streaming Tables** only for incremental ingestion workloads.
- Use **Materialized Views** for deterministic transformations and aggregations.
- Keep the **Bronze** layer as close to the raw source as possible.
- Apply business rules and data quality checks in the **Silver** layer.
- Build reporting, analytics, and ML-ready datasets in the **Gold** layer.
- Leverage DLT Expectations to enforce data quality throughout the pipeline.

---

# Project Note

In a typical **Medallion Architecture**:

- **Streaming Tables** are commonly used for the **Bronze** layer to efficiently capture incremental data from sources such as Auto Loader, Kafka, or Change Data Feed (CDF).
- **Materialized Views** are used for the **Silver** and **Gold** layers to build cleaned, enriched, aggregated, and business-ready datasets.

This combination provides:

- Efficient incremental ingestion
- Scalable data processing
- Optimized analytical performance
- Simplified pipeline maintenance through automatic dependency management and refreshes