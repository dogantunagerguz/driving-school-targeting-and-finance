# SQL portfolio companion

This companion loads the **same five fully synthetic Excel workbooks used by the public Power BI project**, lands them in raw SQLite tables, standardizes them in staging views, and builds targeting and finance marts. It does **not** imply that SQL was part of the original production workflow and contains no private trainee or financial records.

[View the executed result snapshot](RESULTS.md)

[Review the SQL data dictionary](DATA_DICTIONARY.md)

## What this demonstrates

- source-to-mart lineage across candidate, debt, receipt, expense and other-income workbooks
- completed-age calculation at an explicit `2026-09-08` as-of date
- licence-upgrade targeting with stated gender and education assumptions
- finance and trainee pre-aggregation before cost-per-trainee joins
- keyword-based expense classification and window-function ranking
- debt reconciliation, orphan-key, month-coverage and denominator controls
- transparent arithmetic validation of the reported 200 / 47 / 12 funnel

The funnel view does not fabricate row-level outreach data. It checks the three published summary inputs and labels their period and source limitations. The separately reported eight launch-month enrolments remain a different, non-combinable scope.

## Run

The runner generates the same public-demo workbooks in a temporary folder, loads them with `openpyxl`, and executes SQLite in memory.

```bash
python sql/run_demo.py
```

Refresh the committed evidence snapshot with `python sql/run_demo.py --write-results`. A successful run ends with `PASS: all SQL data-quality checks returned zero issues.`

## Files

| File | Purpose |
|---|---|
| `01_raw_schema.sql` | landing tables matching the five generated workbooks |
| `02_staging.sql` | typing, completed age, targeting and expense classification |
| `03_marts.sql` | targeting, finance, debt and reported-funnel views |
| `04_quality_checks.sql` | row-grain, reconciliation, coverage and denominator controls |
| `run_demo.py` | source generation, loading, execution and result rendering |
| `RESULTS.md` | committed output generated from the runnable pipeline |
| `DATA_DICTIONARY.md` | relation grains, keys and metric interpretation |
