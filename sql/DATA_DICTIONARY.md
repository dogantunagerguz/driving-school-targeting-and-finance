# SQL data dictionary

| Relation | Grain | Key fields / interpretation |
|---|---|---|
| `raw_candidates` | one generated trainee | `candidate_id`, birth date, licence, gender, education and cohort |
| `raw_exam_accounts` | one debt/certificate account per trainee | total, paid and remaining balances |
| `raw_income` | one tuition receipt | receipt date, candidate and amount |
| `raw_expenses` | one expense transaction | date, description and amount |
| `raw_other_income` | one other-income transaction | date, description and amount |
| `stg_candidates` | one typed trainee | completed age at 2026-09-08 |
| `candidate_targeting_2026` | one trainee | nullable target segment based on documented assumptions |
| `yearly_finance_kpis` | one calendar year | pre-aggregated income, expense, trainee count and cost per trainee |
| `expense_category_rank` | one expense category | total, share and rank |
| `reported_funnel_reconciliation` | one documented snapshot | 200 contacts, 47 interested, 12 enrolled; no public row-level source |
| `quality_check_results` | one validation rule | `issue_count = 0` is required |

The eight launch-month enrolments are a separate reported scope and are not represented as additional funnel rows.

