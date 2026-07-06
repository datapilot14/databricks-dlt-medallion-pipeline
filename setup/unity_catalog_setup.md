# Unity Catalog Storage Setup (No Keys, No Mounts)

This project uses Unity Catalog to securely access Azure Data Lake Storage Gen2 without using storage account keys, SAS tokens, service principals, or deprecated DBFS mounts.

```
Azure Access Connector (managed identity)
        → Storage Credential
        → External Location
        → Unity Catalog Volume
```
> Note: This approach provides centralized governance, secure authentication, auditing, and fine-grained access control.

## 1. Azure [Data Plane] — Access Connector

An **Access Connector for Azure Databricks** provides a **Managed Identity** that Databricks uses to authenticate with Azure Storage.

**Steps**
1. Create an **Access Connector for Azure Databricks** in Azure.
2. Assign the connector's Managed Identity one of the following roles on the ADLS Gen2 storage account:
    - **Storage Blob Data Contributor** | Grants read, write, and delete access to blob data in Azure Storage containers.
    - **Storage Queue Data Contributor** | Grants read, write, and manage access to Azure Storage queue messages.
    - **Storage Account Contributor** | Allows management of storage accounts (configuration and settings)
    -  **EventGrid EventSubscription Contributor** | Allows creation, modification, and deletion of Event Grid event subscriptions

The Managed Identity replaces the need for storage account keys or SAS tokens.

## 2. Databricks [Control Plane] — Storage Credential

Catalog Explorer → External Data → Credentials → Create credential, pointing to the Access Connector's resource ID. (Or via SQL:)

```sql
-- Example (replace with your connector resource ID)
CREATE STORAGE CREDENTIAL adls_credential
  WITH (AZURE_MANAGED_IDENTITY
    (ACCESS_CONNECTOR_ID = '/subscriptions/<sub-id>/resourceGroups/<rg>/providers/Microsoft.Databricks/accessConnectors/<connector-name>'));
```
> Note: Storage Credentials define how Databricks authenticates to cloud storage.

## 3. External Location

An **External Location** maps a storage path in ADLS Gen2 to a Storage Credential.

It specifies **where the data resides** and **which credential should be used** to access it.

```sql
CREATE EXTERNAL LOCATION landing_location
  URL 'abfss://<container>@<storage-account>.dfs.core.windows.net/<path>'
  WITH (STORAGE CREDENTIAL adls_credential);
```
> Note: External Locations allow Unity Catalog to centrally govern access to external storage.

## 4. Unity Catalog Volume

```sql
CREATE EXTERNAL VOLUME dlt_demo_ws1.default.landing_vol
  LOCATION 'abfss://<container>@<storage-account>.dfs.core.windows.net/<path>/landing';
```

Result: a clean, governed, auditable path — `/Volumes/dlt_demo_ws1/default/landing_vol/` — with zero secrets in any notebook or pipeline code.

> Note: placeholders (`<sub-id>`, `<storage-account>`, etc.) are intentional — replace with your own resource names. TODO: verify these commands match the exact steps used (UI vs SQL) and adjust.

## Object Responsibilities

| Object | Responsibility |
|--------|----------------|
| **Access Connector** | Managed Identity that authenticates to Azure Storage |
| **Storage Credential** | Stores the authentication mechanism used by Unity Catalog |
| **External Location** | Maps an ADLS path to a Storage Credential |
| **Volume** | Provides a governed file-system path for accessing files |
| **Unity Catalog** | Governs permissions, auditing, and data access |

## End-to-End Flow

```
Azure Storage (ADLS Gen2)
          ▲
          │
Managed Identity (Access Connector)
          │
          ▼
 Storage Credential
          │
          ▼
 External Location
          │
          ▼
 Unity Catalog Volume
          │
          ▼
DLT Pipelines • Notebooks • SQL Warehouses

```

## Author & Document Details

**Project:** Databricks DLT Medallion Pipeline  
**Document:** Unity Catalog Storage Setup  
**Author:** Mayank Jain  
