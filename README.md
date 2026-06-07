# Olist E-Commerce Analytics Engineering Project (dbt + Snowflake)

This repository showcases an end-to-end, enterprise-grade data transformation architecture built using **dbt (v1.11)** and **Snowflake Cloud Data Warehouse**. The project implements a robust **Star Schema (Dimensional Modeling)** by processing over 100,000+ rows of raw Brazilian E-Commerce (Olist) data, transforming it from a raw data lake state into highly optimized, production-ready analytics tables.

## Data Architecture & Layering (Medallion Standard)

The project strictly follows modern data engineering best practices by organizing the transformation pipeline into 4 distinct layers:

### 1.Bronze (Raw Data Layer)
*   **Source Tables:** Direct landing zone for Kaggle Olist datasets (`RAW_OLIST_CUSTOMERS`, `RAW_OLIST_ORDERS`, etc.).
*   Managed and declared securely using dbt `sources` configurations to separate raw data from code logic.

### 2.Silver (Staging Layer - `stg_`)
*   **Materialization:** `VIEW` (to prevent redundant storage costs and ensure real-time query efficiency).
*   **Operations:** Explicit type casting, strict renaming for global accessibility, text normalization using custom macros, and filtering out null rows.

### 3.Intermediate Layer (`int_`)
*   **Materialization:** `VIEW`
*   **Operations:** Complex join heavy matrices, order-level financial metrics grouping, dynamic payment channel breakdown, and historical customer aggregation. 
*   Acts as a robust architectural backbone to eliminate repeating code in final analytical models (DRY Principle).

### 4.Gold (Marts Layer - `dim_` & `fct_`)
*   **Materialization:** `TABLE` (optimized for BI visualization performance).
*   **Dimensional Models:** 
    *   `dim_customers`: Enriched with location metadata and dynamic behavioral segmentation tags ('VIP', 'Regular', etc.).
    *   `dim_products`: Optimized logistics dimension including product volumetric weight (Desi) calculations sourced from SCD Type 2 history.
    *   `fct_sales`: Enterprise KPI hub containing dynamic conversion metrics, net profit margins, and revenue flows.
    *   `fct_shipping_performance`: Advanced temporal analytics tracking supply chain efficiency through actual vs. estimated carrier days using Snowflake `DATEDIFF` logic and custom `is_weekend` macro.

## Data Quality & Advanced Testing (Zırhlama)

To ensure enterprise-grade data integrity, the project deploys a dual-layered testing strategy containing **50+ automated data tests**:

1.  **Generic Schema Tests:** Enforcing `not_null`, `unique`, and strict business constraint `accepted_values` within `.yml` files across all critical dimensions and keys.
2.  **Singular Business Logic Tests:** Custom SQL auditing macros deployed inside the `tests/` directory (e.g., catching structural edge cases like checking if shipping durations drop below 0 on active shipments).
3.  **Audit Controls:** Integrated with `--store-failures` flags to automatically record any operational business rule anomalies directly into a dedicated Snowflake `_dbt_test__audit` schema for instant root-cause analysis.

## Advanced dbt Configurations Implemented

*   **Custom Jinja Macros:** Deployed dynamic text sanitization algorithms and automated supply chain logic tracking (`is_weekend` flag) to handle text trimming and complex temporal feature engineering globally.
*   **dbt Snapshots (SCD Type 2):** Implemented historical state tracking over `RAW_OLIST_PRODUCTS` using temporal tracking check fields (`dbt_valid_from`, `dbt_valid_to`) to preserve slowly changing product characteristics over time.
*   **Optimized Execution:** Configured high-throughput multi-threaded synchronization executing up to **4 threads** concurrently inside Snowflake to achieve high optimization metrics.

## How to Run & Replicate This Project

1. Clone the repository and configure your credentials inside `~/.dbt/profiles.yml` using `SYSADMIN` role.
2. Install package dependencies: `dbt deps`
3. Test your connection parameters: `dbt debug`
4. Build the entire analytics catalog (Models, Snapshots, and Audit Tests) from scratch:
   ```bash
   dbt build --no-partial-parse
   ```
5. Generate and spin up the visual lineage portal:
   ```bash
   dbt docs generate && dbt docs serve
   ```
