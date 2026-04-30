# Databricks Projects

Data engineering projects built on Databricks using medallion architecture patterns. Covers data ingestion, transformation, aggregation, dashboarding, and workflow orchestration via Databricks notebooks, Delta tables, and Lakeflow Declarative Pipelines.

---

## Directory Structure

```
Databricks/
├── DLT/
│   ├── 01_stock_data_ingestion.ipynb
│   ├── 02_bronze_stock.py
│   ├── 03_silver_stock.py
│   ├── 04_gold_stock.py
│   └── Stock Market Analysis Dashboard.pdf
├── ETL/
│   ├── 01_Bronze_Ingestion.ipynb
│   ├── 02_Silver_Transformation.ipynb
│   ├── 03_Gold_Aggregation.ipynb
│   └── Fraud-Analytics-Dashboard.pdf
└── README.md
```

---

## Projects

### 1. Stock Market Analytics — Lakeflow Declarative Pipeline

**Location:** `DLT/`

A Databricks Lakeflow Declarative Pipeline for stock market analytics using Alpha Vantage API data. Follows medallion architecture and processes daily stock prices, latest quotes, and company profile information.

**Tracked Symbols:** AAPL · MSFT · GOOGL · AMZN

#### Pipeline Flow

```
Alpha Vantage API
  → Unity Catalog Volume
  → Bronze (raw streaming tables)
  → Silver (parsed & typed tables)
  → Gold (analytics tables)
  → Dashboard
```

#### Notebooks

| File | Description |
|------|-------------|
| `01_stock_data_ingestion.ipynb` | Extracts data from Alpha Vantage API and writes raw JSON to a Unity Catalog volume (daily prices, latest quotes, company info) |
| `02_bronze_stock.py` | Creates raw Bronze streaming tables via `spark.readStream`; preserves raw API responses and source file metadata |
| `03_silver_stock.py` | Parses raw JSON into structured Silver tables with typed columns (daily prices, latest quotes, company info) |
| `04_gold_stock.py` | Builds Gold analytics tables: price trends, % changes, rolling volume, stock snapshots, company valuations, sector summaries |
| `Stock Market Analysis Dashboard.pdf` | Dashboard output built from Gold-layer tables |

#### Key Gold Tables

- `gold_stock_price_trends`
- `gold_latest_stock_snapshot`
- `gold_company_valuation_summary`
- `gold_sector_summary`

---

### 2. Fraud Analytics — ETL Pipeline

**Location:** `ETL/`

A Databricks ETL pipeline for fraud analytics using medallion architecture. Ingests raw financial data, cleans and enriches it in the Silver layer, and produces Gold-level aggregates for fraud analysis and dashboarding.

#### Pipeline Flow

```
Raw Financial Data
  → Bronze (raw ingestion)
  → Silver (cleaned & enriched)
  → Gold (fraud analytics aggregates)
  → Dashboard
```

#### Notebooks

| File | Description |
|------|-------------|
| `01_Bronze_Ingestion.ipynb` | Ingests raw source data: transactions, cards, users, MCC codes, and fraud labels |
| `02_Silver_Transformation.ipynb` | Cleans and standardizes Bronze tables; parses fields, converts types, enriches with fraud labels and MCC descriptions |
| `03_Gold_Aggregation.ipynb` | Creates dashboard-ready Gold aggregation tables for fraud analytics |
| `Fraud-Analytics-Dashboard.pdf` | Dashboard output built from Gold-layer fraud analytics tables |

#### Key Analytical Areas

- Total transactions, fraud count, and fraud rate
- Fraud losses and fraud trend over time
- Fraud by merchant category, amount tier, and time of day
- Fraud by day of week
- Top fraudulent users
- User behavior before and after fraud events

---

## Architecture

Both projects follow the **medallion architecture**:

| Layer | Description |
|-------|-------------|
| **Bronze** | Raw ingested data with minimal transformation |
| **Silver** | Cleaned, typed, standardized, and enriched data |
| **Gold** | Business-level aggregations and dashboard-ready analytical tables |

---

## Orchestration

Projects run through **Databricks Jobs**.

**Stock Market Analytics job flow:**
1. Run `01_stock_data_ingestion.ipynb`
2. Trigger the Lakeflow Declarative Pipeline update
3. Refresh the dashboard or validate Gold dashboard source tables

**Fraud Analytics ETL job flow:**
1. Run Bronze ingestion
2. Run Silver transformation
3. Run Gold aggregation
4. Refresh or review the dashboard built on Gold tables

---

## Technologies Used

- **Platform:** Databricks, Unity Catalog
- **Processing:** PySpark, Delta Lake, Lakeflow Declarative Pipelines / Delta Live Tables
- **Orchestration:** Databricks Workflows / Jobs
- **Dashboarding:** Databricks Dashboards
- **Languages:** Python, SQL
- **External API:** Alpha Vantage

---

## Notes

- The DLT project uses **streaming ingestion** from raw files in a Unity Catalog volume.
- The ETL project uses **notebook-based batch transformations**.
- All dashboards are built from Gold-layer outputs.

---

## Future Improvements

1. **Data quality checks** — Add automated alerting for missing files, schema changes, null values, and failed API responses.
2. **Secrets management** — Store API keys and credentials using Databricks Secrets instead of notebook variables; add retry logic for API rate limits and transient failures.
3. **CI/CD support** — Add deployment pipelines for Databricks assets including notebooks, DLT pipeline definitions, job configurations, and dashboard artifacts.