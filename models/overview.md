{% docs __overview__ %}

# Olist E-Commerce Enterprise Data Warehouse

Welcome to the official analytics engineering documentation for the **Olist E-Commerce Data Warehouse**, fully architected using **dbt (v1.11)** and hosted on **Snowflake Cloud Data Platform**.

# Business Objective
The primary goal of this data product is to ingest, sanitize, and model raw transaction records into an optimized **Star Schema (Dimensional Modeling)**. It empowers corporate stakeholders, marketing analysts, and supply chain managers with high-throughput tables to track revenue flow, dynamic customer segments, and delivery latency metrics.

---

# Architectural Overview & Pipeline Flow

The transformation engine strictly enforces the **Medallion Architecture** guidelines to isolate technical casting from complex analytical aggregations:

1.  **Bronze (Raw Source Vault):** Governs immutable ingestion landing schemas without modifications.
2.  **Silver (Staging Layer - `stg_`):** Applied custom translation logic via **Jinja Macros** to standardize alphanumeric characters and cast system datatypes (`TIMESTAMP`, `VARCHAR`, `INT`). Materialized strictly as `VIEW`.
3.  **Intermediate Layer (`int_`):** Grouped high-join velocity structures such as order level financials and user touchpoint frequencies to avoid compute redundancies.
4.  **Gold (Marts Layer - `dim_` / `fct_`):** Materialized as relational physical `TABLE` models, optimized with pre-computed key performance indicators (KPIs) like volumetric package desis and geographical segment cohorts.

---

# Governance & Enterprise Testing Strategies
This asset is reinforced with a robust testing footprint checking critical keys against systemic failures:
*   **Temporal Logic Asserts:** Restricting negative velocity bounds (e.g., catching structural exceptions where internal shipment indicators report delivery timestamps prior to order placement dates).
*   **Audit Vault Storage:** Coupled with `--store-failures` parameters to route system-driven semantic failures straight into specialized schema tables for post-incident debugging.
*   **SCD Type 2 Tracking:** Product metadata changes are captured recursively through dbt snapshots, preventing historic tracking gaps and preserving master record reproducibility.

{% enddocs %}
