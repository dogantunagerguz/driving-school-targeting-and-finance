# Executed SQL results

> Generated from the same fully synthetic Excel workbooks used by the public Power BI demo. These are portfolio-demo outputs, not private or operational results.

**As-of date:** 2026-09-08 for completed age and targeting.

**Scope note:** the 200 / 47 / 12 funnel is arithmetic validation of a reported snapshot only; its row-level source and reporting period are not public. The separately reported eight launch-month enrolments are not combined with it.

## Pipeline reconciliation

| candidates | exam_accounts | tuition_receipts | expense_rows | other_income_rows | target_candidates |
|---|---|---|---|---|---|
| 48 | 48 | 48 | 648 | 72 | 37 |

## Targeting distribution

| target_segment | candidates |
|---|---|
| Not targeted | 11 |
| A Potential | 8 |
| B Potential | 8 |
| C-D Potential | 7 |
| CE Potential | 7 |
| Only C Potential | 7 |

## Yearly finance KPIs

| calendar_year | income | expense | net_result | trainees | cost_per_trainee |
|---|---|---|---|---|---|
| 2020 | 70000.0 | 29160.0 | 40840.0 | 8 | 3645.0 |
| 2021 | 72000.0 | 34560.0 | 37440.0 | 8 | 4320.0 |
| 2022 | 118000.0 | 39960.0 | 78040.0 | 8 | 4995.0 |
| 2023 | 108000.0 | 45360.0 | 62640.0 | 8 | 5670.0 |
| 2024 | 166000.0 | 50760.0 | 115240.0 | 8 | 6345.0 |
| 2025 | 144000.0 | 56160.0 | 87840.0 | 8 | 7020.0 |

## Expense-category ranking

| expense_category | total_expense | expense_share_pct | expense_rank |
|---|---|---|---|
| Other | 37080.0 | 14.49 | 1 |
| Equipment | 34920.0 | 13.64 | 2 |
| Books | 32760.0 | 12.8 | 3 |
| Rent | 30600.0 | 11.95 | 4 |
| Bank | 28440.0 | 11.11 | 5 |
| Refreshments | 26280.0 | 10.27 | 6 |
| Personnel | 24120.0 | 9.42 | 7 |
| Vehicle Maintenance | 21960.0 | 8.58 | 8 |
| Fuel | 19800.0 | 7.74 | 9 |

## Debt and certification controls

| total_debt | paid_amount | remaining_debt | candidates | certificates_not_issued |
|---|---|---|---|---|
| 744000.0 | 642000.0 | 102000.0 | 48 | 9 |

## Reported funnel arithmetic

| targeted_contacts | interested | enrolled | contact_to_interest_pct | interest_to_enrolment_pct | contact_to_enrolment_pct | evidence_scope |
|---|---|---|---|---|---|---|
| 200 | 47 | 12 | 23.5 | 25.53 | 6.0 | Reported snapshot; period and row-level source are not public |

## Data-quality checks

| check_name | issue_count |
|---|---|
| debt_not_reconciled | 0 |
| duplicate_candidate_id | 0 |
| exam_account_without_candidate | 0 |
| expense_month_missing | 0 |
| finance_year_without_trainee_denominator | 0 |
| future_or_missing_birth_date | 0 |
| income_without_candidate | 0 |
| nonpositive_finance_amount | 0 |
| reported_funnel_rate_mismatch | 0 |
