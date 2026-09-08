# SQL portfolio companion

These files demonstrate equivalent analytical logic on a purpose-built, fully synthetic SQLite dataset. They do **not** imply that SQL was part of the original production workflow and do not reconstruct private records.

The fixture intentionally produces a **10 contacted / 4 interested / 2 enrolled** demo funnel. It does not validate or replace the separately reported **200 / 47 / 12** operational snapshot, whose period is undocumented. The separately reported eight launch-month enrolments also remain a different, non-combinable scope.

## What this demonstrates

- completed-age calculation at an explicit `2026-09-08` as-of date
- licence-upgrade targeting with `CASE` and stated gender/education assumptions
- distinct-candidate funnel counts and guarded conversion denominators
- pre-aggregation of finance and enrolments to avoid join multiplication
- expense shares and ranking with window functions
- stage-order, referential, date, finance and funnel quality checks

## Run

Python 3 is the only requirement; the runner uses the standard-library SQLite engine.

```bash
python sql/run_demo.py
```

A successful run ends with `PASS: all SQL data-quality checks returned zero issues.`

## Files

| File | Purpose |
|---|---|
| `01_demo_schema_and_seed.sql` | normalized schema and invented candidates, events and transactions |
| `02_analysis.sql` | targeting, funnel, monthly finance and expense-rank views |
| `03_data_quality.sql` | auditable integrity and metric checks |
| `run_demo.py` | reproducible execution and bounded output preview |

