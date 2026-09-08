-- Portfolio companion queries: deterministic SQLite 3.25+ analysis.

CREATE VIEW candidate_targeting_2026 AS
WITH parameters AS (
    SELECT date('2026-09-08') AS as_of_date
),
ages AS (
    SELECT
        c.*,
        p.as_of_date,
        CASE
            WHEN date(c.birth_date) > p.as_of_date THEN NULL
            ELSE
                CAST(strftime('%Y', p.as_of_date) AS INTEGER)
                - CAST(strftime('%Y', c.birth_date) AS INTEGER)
                - CASE
                    WHEN strftime('%m-%d', p.as_of_date) < strftime('%m-%d', c.birth_date)
                    THEN 1 ELSE 0
                  END
        END AS completed_age
    FROM candidates AS c
    CROSS JOIN parameters AS p
),
eligibility AS (
    SELECT
        ages.*,
        education_level IN ('Primary School', 'Middle School', 'High School',
                            'Elementary Education', 'Vocational-Technical High School',
                            'Adult Education Stage 2', 'Associate Degree') AS education_eligible
    FROM ages
)
SELECT
    candidate_id,
    candidate_name,
    as_of_date,
    birth_date,
    completed_age,
    current_licence,
    gender,
    education_level,
    CASE
        WHEN gender = 'M' AND education_eligible AND current_licence = 'B'
             AND completed_age BETWEEN 21 AND 23 THEN 'Only C Potential'
        WHEN gender = 'M' AND education_eligible AND current_licence = 'B'
             AND completed_age >= 24 THEN 'C-D Potential'
        WHEN current_licence = 'A1' AND completed_age >= 17 THEN 'B Potential'
        WHEN current_licence = 'A2' AND completed_age >= 20 THEN 'A Potential'
        WHEN gender = 'M' AND education_eligible AND current_licence = 'C'
             AND completed_age >= 24 THEN 'CE Potential'
        ELSE NULL
    END AS target_segment
FROM eligibility;

CREATE VIEW lead_funnel AS
WITH stages(stage_order, stage_name, event_type) AS (
    VALUES
        (1, 'Contacted',  'contacted'),
        (2, 'Interested', 'interested'),
        (3, 'Enrolled',   'enrolled')
),
stage_counts AS (
    SELECT
        s.stage_order,
        s.stage_name,
        COUNT(DISTINCT e.candidate_id) AS candidates
    FROM stages AS s
    LEFT JOIN lead_events AS e ON e.event_type = s.event_type
    GROUP BY s.stage_order, s.stage_name
),
with_previous AS (
    SELECT
        stage_counts.*,
        LAG(candidates) OVER (ORDER BY stage_order) AS previous_stage_candidates
    FROM stage_counts
)
SELECT
    stage_order,
    stage_name,
    candidates,
    ROUND(100.0 * candidates /
          NULLIF((SELECT candidates FROM stage_counts WHERE stage_order = 1), 0), 2)
        AS conversion_from_contact_pct,
    CASE
        WHEN previous_stage_candidates IS NULL THEN NULL
        ELSE ROUND(100.0 * candidates / NULLIF(previous_stage_candidates, 0), 2)
    END AS conversion_from_previous_stage_pct
FROM with_previous;

CREATE VIEW monthly_finance_kpis AS
WITH finance_by_month AS (
    SELECT
        strftime('%Y-%m', transaction_date) AS activity_month,
        SUM(CASE WHEN transaction_type = 'income'  THEN amount ELSE 0 END) AS income,
        SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) AS expense
    FROM finance_transactions
    GROUP BY strftime('%Y-%m', transaction_date)
),
enrolments_by_month AS (
    SELECT
        strftime('%Y-%m', event_date) AS activity_month,
        COUNT(DISTINCT candidate_id) AS enrolled_candidates
    FROM lead_events
    WHERE event_type = 'enrolled'
    GROUP BY strftime('%Y-%m', event_date)
)
SELECT
    f.activity_month,
    f.income,
    f.expense,
    f.income - f.expense AS net_result,
    COALESCE(e.enrolled_candidates, 0) AS enrolled_candidates,
    ROUND(f.expense / NULLIF(e.enrolled_candidates, 0), 2) AS cost_per_enrolment
FROM finance_by_month AS f
LEFT JOIN enrolments_by_month AS e USING (activity_month);

CREATE VIEW expense_category_rank AS
WITH category_totals AS (
    SELECT category, SUM(amount) AS total_expense
    FROM finance_transactions
    WHERE transaction_type = 'expense'
    GROUP BY category
)
SELECT
    category,
    total_expense,
    ROUND(100.0 * total_expense / NULLIF(SUM(total_expense) OVER (), 0), 2) AS expense_share_pct,
    DENSE_RANK() OVER (ORDER BY total_expense DESC) AS expense_rank
FROM category_totals;

