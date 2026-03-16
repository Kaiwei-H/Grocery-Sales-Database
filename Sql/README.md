# Data Architecture

The project uses a **three-layer data architecture**.

## 1. Raw Layer

Stores the original cleaned data imported from source tables.
Purpose:

- Preserve original structure
- Apply minimal cleaning
- Maintain referential integrity

---

## 2. Analytics Layer

Transforms raw data into **analysis-ready views**.

Key features:

- Dimensional modeling
- Data enrichment via joins
- Derived metrics
- Date normalization

Additional calculated fields include:

- `sales_month`
- `gross_amount`
- `net_amount_estimated`

Revenue is recalculated because the original dataset contains unreliable `total_price` values.

---

## 3. Mart Layer

Aggregated tables designed for reporting and analysis.