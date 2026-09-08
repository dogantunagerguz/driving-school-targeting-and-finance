CREATE VIEW quality_check_results AS
SELECT 'duplicate_candidate_id' AS check_name, COUNT(*) AS issue_count
FROM (SELECT candidate_id FROM stg_candidates GROUP BY candidate_id HAVING COUNT(*) > 1)
UNION ALL
SELECT 'exam_account_without_candidate', COUNT(*)
FROM stg_exam_accounts AS a
LEFT JOIN stg_candidates AS c USING (candidate_id)
WHERE c.candidate_id IS NULL
UNION ALL
SELECT 'income_without_candidate', COUNT(*)
FROM raw_income AS i
LEFT JOIN stg_candidates AS c USING (candidate_id)
WHERE c.candidate_id IS NULL
UNION ALL
SELECT 'future_or_missing_birth_date', COUNT(*)
FROM stg_candidates
WHERE completed_age IS NULL
UNION ALL
SELECT 'debt_not_reconciled', COUNT(*)
FROM stg_exam_accounts
WHERE ABS((total_debt - paid_amount) - remaining_debt) > 0.01
   OR ABS((exam_fee_total - exam_paid) - exam_remaining) > 0.01
UNION ALL
SELECT 'nonpositive_finance_amount', COUNT(*)
FROM (
    SELECT amount FROM stg_income
    UNION ALL SELECT amount FROM stg_expenses
)
WHERE amount <= 0
UNION ALL
SELECT 'expense_month_missing', ABS(72 - COUNT(*))
FROM (
    SELECT DISTINCT strftime('%Y-%m', transaction_date) AS expense_month
    FROM stg_expenses
)
UNION ALL
SELECT 'finance_year_without_trainee_denominator', COUNT(*)
FROM yearly_finance_kpis
WHERE trainees = 0
UNION ALL
SELECT 'reported_funnel_rate_mismatch', COUNT(*)
FROM reported_funnel_reconciliation
WHERE contact_to_interest_pct <> 23.50
   OR interest_to_enrolment_pct <> 25.53
   OR contact_to_enrolment_pct <> 6.00;

