## dbt Data Transformation

This dbt project transforms raw data into analytics-ready datasets using a layered architecture.

### Structure

staging: clean and standardize raw data

intermediate: join and enrich datasets

marts: business-level aggregated tables

### Data Flow
raw → staging → intermediate → marts

Usage

Install:
pip install dbt-postgres

Run:
cd dbt
dbt run

Test:
dbt test

### Notes

Models are built using ref() for dependency management

dbt automatically generates data lineage and documentation