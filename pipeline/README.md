# Python ETL Pipeline

## Overview

This folder contains the Python ETL pipeline used to ingest source CSV files, apply basic cleaning and transformation, and load the results into the PostgreSQL `raw` schema.

The pipeline is designed to complement the SQL-based warehouse architecture of the project:

```text
CSV files
   ↓
Python ETL pipeline
   ↓
PostgreSQL raw layer
   ↓
SQL analytics / mart / analysis
```

## HOW TO RUN
from the project root: python pipeline/pipeline.py