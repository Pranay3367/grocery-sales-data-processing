# 🛒 Grocery Sales Data Processing & Analytics

## 🚀 Project Overview

The **Grocery Sales Data Processing & Analytics** project is a data transformation pipeline built using **dbt (Data Build Tool)** to transform raw grocery sales data into structured, analytics-ready datasets.

The project processes grocery sales, store, transaction, oil price, and holiday/event data through a layered data architecture:

**Bronze → Silver → Gold**

The pipeline uses **dbt models, SQL transformations, source definitions, reusable macros, and dimensional data modeling** to create clean and analytics-ready datasets for downstream reporting and analysis.

The project is based on the grocery sales dataset containing historical sales information across stores, product families, transactions, promotions, oil prices, and holidays.

---

## 🎯 Project Objectives

The main objectives of this project are:

* Build a structured grocery sales data transformation pipeline using dbt.
* Organize raw data using a **Bronze → Silver → Gold** architecture.
* Create reusable staging models for raw source datasets.
* Clean and standardize grocery sales and store information.
* Combine sales data with store, oil price, and holiday information.
* Build intermediate models for data enrichment and transformation.
* Create analytical fact and dimension tables.
* Implement a dimensional **star schema** for analytics.
* Improve data transformation modularity and maintainability using dbt.
* Maintain a clear separation between raw, transformed, and analytics-ready data.

---

## 🏗️ Data Architecture

The project follows a layered data architecture:


![Grocery Sales Data Model Pipeline](design/High-level-Structure.png)
```text
                    RAW DATA
                       │
                       ▼
              ┌─────────────────┐
              │  BRONZE LAYER   │
              │                 │
              │ train           │
              │ test            │
              │ stores          │
              │ transactions    │
              │ oil             │
              │ holidays_events │
              └────────┬────────┘
                       │
                       ▼
              ┌─────────────────┐
              │  SILVER LAYER   │
              │                 │
              │    STAGING      │
              │        +        │
              │   INTERMEDIATE  │
              └────────┬────────┘
                       │
                       ▼
              ┌─────────────────┐
              │   GOLD LAYER    │
              │                 │
              │ dim_date        │
              │ dim_product     │
              │ dim_store       │
              │ fact_sales      │
              └────────┬────────┘
                       │
                       ▼
                ANALYTICS /
                 REPORTING
```

The repository also contains architecture and data-model diagrams under the `design/` directory.

---

## 🛠️ Technology Stack

| Technology         | Purpose                                |
| ------------------ | -------------------------------------- |
| **dbt**            | Data transformation and modeling       |
| **SQL**            | Data transformation logic              |
| **Databricks SQL** | Data processing and analytical storage |
| **Delta Lake**     | Storage layer for transformed datasets |
| **Git / GitHub**   | Version control and project management |

---

## 📂 Dataset

The project works with grocery sales datasets containing information related to:

* Grocery sales
* Store information
* Transactions
* Oil prices
* Holidays and events
* Training data
* Test data
* Product families
* Promotions

The repository currently contains the following raw datasets under `datasets/raw/`:

| Dataset                 | Description                   |
| ----------------------- | ----------------------------- |
| `train.txt`             | Historical grocery sales data |
| `test.txt`              | Test sales data               |
| `stores.txt`            | Store information             |
| `transactions.txt`      | Store transaction information |
| `oil.txt`               | Historical oil price data     |
| `holidays_events.txt`   | Holiday and event information |
| `sample_submission.txt` | Sample submission structure   |

---

# 🏗️ ELT Design

## 🥉 Bronze Layer – Raw Data

The **Bronze layer** represents the raw source datasets before business transformations.

The project defines the Bronze source as:

`adb_p2_grocery_serverless.bronze`

with the following source tables:

* `train`
* `test`
* `stores`
* `transactions`
* `oil`
* `holidays_events`

These sources are registered in `models/sources.yml`.

### Bronze Data Flow

```text
Raw Grocery Data
       │
       ▼
Bronze Tables
       │
       ├── train
       ├── test
       ├── stores
       ├── transactions
       ├── oil
       └── holidays_events
```

---

## 🥈 Silver Layer – Staging & Intermediate Transformations

The Silver layer contains the cleaned, standardized, and enriched datasets.

The project separates Silver transformations into two stages:

### Staging Models

The `models/staging/` directory contains:

* `stg_train.sql`
* `stg_test.sql`
* `stg_stores.sql`
* `stg_transactions.sql`
* `stg_oil.sql`
* `stg_holidays_events.sql`

These models provide the first transformation layer over the Bronze sources.

### Intermediate Models

The `models/intermediate/` directory contains:

* `int_train_sales.sql`
* `int_sales.sql`
* `int_sales_complete.sql`
* `int_sales_enriched.sql`
* `int_sales_oil.sql`

These models combine and enrich the staging datasets before they are consumed by the Gold layer.

For example, `int_sales_enriched` combines sales information with store information to add attributes such as:

* City
* State
* Store type
* Cluster

This creates a more complete sales dataset for downstream analytical models.

---

## 🥇 Gold Layer – Analytics & Data Marts

The Gold layer contains analytics-ready fact and dimension tables.

The project currently contains the following marts:

| Gold Model    | Purpose                  |
| ------------- | ------------------------ |
| `dim_date`    | Date dimension           |
| `dim_product` | Product family dimension |
| `dim_store`   | Store dimension          |
| `fact_sales`  | Sales fact table         |

These models are stored in the `models/marts/` directory.

### ⭐ Fact Table

The `fact_sales` model combines the transformed sales data with store, oil, and holiday attributes.

The resulting fact table includes fields such as:

* Sales ID
* Sales date
* Store number
* Product family
* Sales
* Promotion status
* City
* State
* Store type
* Cluster
* Oil price
* Holiday type
* Holiday locale
* Holiday description

This creates the central analytical dataset for grocery sales analysis.

### 📐 Dimension Tables

#### `dim_product`

Contains distinct grocery product families used in the sales data.

#### `dim_store`

Contains store-level attributes.

#### `dim_date`

Provides date-related attributes for analytical queries.

---

# 📊 Data Model

The Gold layer follows a **Star Schema** design:

![Grocery Sales Star Schema](design/Data-Model.png)

```text
                    ┌──────────────┐
                    │   dim_date   │
                    └──────┬───────┘
                           │
                           │
┌──────────────┐    ┌──────▼───────┐    ┌───────────────┐
│ dim_product  │────│  fact_sales  │────│   dim_store   │
└──────────────┘    └──────────────┘    └───────────────┘
```

### Fact Table

**fact_sales**

Contains measurable sales information and references the relevant dimensions.

### Dimension Tables

* **dim_date**
* **dim_product**
* **dim_store**

This structure makes the data easier to query and supports analytical workloads.

---

# 🔄 dbt Transformation Flow

The overall transformation flow is:

```text
                 Bronze Sources
                      │
                      ▼
              ┌───────────────┐
              │    Staging    │
              │    Models     │
              └───────┬───────┘
                      │
                      ▼
              ┌───────────────┐
              │ Intermediate  │
              │    Models     │
              └───────┬───────┘
                      │
                      ▼
              ┌───────────────┐
              │     Marts     │
              │               │
              │ fact_sales    │
              │ dim_date      │
              │ dim_product   │
              │ dim_store     │
              └───────────────┘
```

dbt manages dependencies between models using `ref()` and source definitions.

The project configuration maps:

* **Staging → Silver**
* **Intermediate → Silver**
* **Marts → Gold**

and materializes these models as tables.

---

# 🧩 Project Structure

```text
grocery-sales-data-processing/
│
├── analyses/
│
├── datasets/
│   └── raw/
│       ├── holidays_events.txt
│       ├── oil.txt
│       ├── sample_submission.txt
│       ├── stores.txt
│       ├── test.txt
│       ├── train.txt
│       └── transactions.txt
│
├── design/
│   ├── Data-Model.png
│   ├── High-level-Structure.png
│   └── Low-Level.png
│
├── macros/
│   └── generate_schema_name.sql
│
├── models/
│   ├── staging/
│   │   ├── stg_holidays_events.sql
│   │   ├── stg_oil.sql
│   │   ├── stg_stores.sql
│   │   ├── stg_test.sql
│   │   ├── stg_train.sql
│   │   └── stg_transactions.sql
│   │
│   ├── intermediate/
│   │   ├── int_sales.sql
│   │   ├── int_sales_complete.sql
│   │   ├── int_sales_enriched.sql
│   │   ├── int_sales_oil.sql
│   │   └── int_train_sales.sql
│   │
│   ├── marts/
│   │   ├── dim_date.sql
│   │   ├── dim_product.sql
│   │   ├── dim_store.sql
│   │   └── fact_sales.sql
│   │
│   └── sources.yml
│
├── seeds/
├── snapshots/
├── tests/
│
├── .gitignore
├── dbt_project.yml
└── README.md
```

The repository structure currently contains dedicated directories for analyses, raw datasets, design diagrams, macros, models, seeds, snapshots, and tests.

---

# 🧪 Data Quality & Testing

The project is structured to support dbt testing through the `tests/` directory and source/model configuration.

The dbt project defines:

```text
model-paths: ["models"]
analysis-paths: ["analyses"]
test-paths: ["tests"]
seed-paths: ["seeds"]
macro-paths: ["macros"]
snapshot-paths: ["snapshots"]
```

This provides a standardized dbt project structure for transformation, testing, analysis, seeds, macros, and snapshots.

Potential data quality checks include:

* Null validation
* Duplicate detection
* Schema validation
* Referential integrity
* Source validation
* Model-level testing

---

# 📈 Analytics Use Cases

The Gold-layer models can support analytical use cases such as:

### Sales Analytics

* Daily sales trends
* Store-level sales performance
* Product-family sales performance
* Promotional sales analysis

### Store Analytics

* Store performance comparison
* Sales by city and state
* Store type analysis
* Store cluster analysis

### External Factor Analysis

* Sales vs oil price
* Sales during holidays
* Holiday impact on sales
* Promotion impact on sales

### Product Analytics

* Product family performance
* Top-performing product families
* Promotion-driven sales patterns

---

# ⚙️ Running the Project

Clone the repository:

```bash
git clone https://github.com/Prabu-Kanth/grocery-sales-data-processing.git

cd grocery-sales-data-processing
```

Install dbt and configure the appropriate profile for the target data platform.

Then run:

```bash
dbt debug
```

Run the models:

```bash
dbt run
```

Run the tests:

```bash
dbt test
```

Generate documentation:

```bash
dbt docs generate
```

Launch the documentation locally:

```bash
dbt docs serve
```

---

# 🧱 dbt Model Layers

| Layer     | dbt Directory   | Schema   | Purpose                     |
| --------- | --------------- | -------- | --------------------------- |
| 🥉 Bronze | Sources         | `bronze` | Raw source datasets         |
| 🥈 Silver | `staging/`      | `silver` | Cleaning & standardization  |
| 🥈 Silver | `intermediate/` | `silver` | Enrichment & transformation |
| 🥇 Gold   | `marts/`        | `gold`   | Analytics-ready datasets    |

The schema configuration is defined directly in `dbt_project.yml`.

---

# 🎯 Key Outcomes

* Implemented a structured **dbt ELT pipeline**.
* Organized transformations using a **Bronze → Silver → Gold** architecture.
* Created modular staging and intermediate SQL models.
* Integrated multiple grocery sales datasets.
* Built an analytical **star schema**.
* Created reusable fact and dimension models.
* Separated raw data from business-ready datasets.
* Established a maintainable project structure for future analytical workloads.

---

# 🔮 Future Enhancements

Possible future enhancements include:

* Add comprehensive dbt schema tests.
* Add dbt documentation and column descriptions.
* Implement incremental models for large datasets.
* Add automated pipeline orchestration using Apache Airflow.
* Add CI/CD for dbt deployments.
* Add data quality monitoring.
* Build Power BI or Databricks dashboards.
* Add automated data freshness checks.
* Implement model-level lineage and observability.
* Add more advanced sales forecasting and analytical models.

---

# 📌 Conclusion

This project demonstrates how **dbt can be used to build a modular and maintainable grocery sales data transformation pipeline**.

By separating the data into **Bronze, Silver, and Gold layers**, the project establishes a clear transformation flow from raw source data to analytics-ready datasets.

The combination of **staging models, intermediate transformations, dimensional modeling, and fact tables** provides a strong foundation for grocery sales analytics and future expansion into orchestration, dashboards, data quality monitoring, and advanced analytics.
