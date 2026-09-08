-- Clean candidate attributes and calculate completed age at a reproducible date.
CREATE VIEW stg_candidates AS
WITH parameters AS (
    SELECT date('2026-09-08') AS as_of_date
),
typed AS (
    SELECT
        CAST(candidate_id AS INTEGER) AS candidate_id,
        TRIM(first_name || ' ' || last_name) AS candidate_name,
        UPPER(TRIM(gender)) AS gender,
        TRIM(group_label) AS group_label,
        TRIM(education_level) AS education_level,
        date(birth_date) AS birth_date,
        UPPER(TRIM(current_licence)) AS current_licence,
        CAST(calendar_year AS INTEGER) AS cohort_year,
        CAST(calendar_month AS INTEGER) AS cohort_month,
        p.as_of_date
    FROM raw_candidates
    CROSS JOIN parameters AS p
)
SELECT
    *,
    CASE
        WHEN birth_date IS NULL OR birth_date > as_of_date THEN NULL
        ELSE
            CAST(strftime('%Y', as_of_date) AS INTEGER)
            - CAST(strftime('%Y', birth_date) AS INTEGER)
            - CASE WHEN strftime('%m-%d', as_of_date) < strftime('%m-%d', birth_date)
                   THEN 1 ELSE 0 END
    END AS completed_age
FROM typed;

CREATE VIEW candidate_targeting_2026 AS
WITH eligibility AS (
    SELECT
        *,
        education_level IN ('İlkokul', 'Ortaokul', 'Lise', 'İlköğretim',
                            'Mesleki ve Teknik Lise', 'Yetişkin Eğitimi Kademe 2',
                            'Ön Lisans') AS education_eligible
    FROM stg_candidates
)
SELECT
    *,
    CASE
        WHEN gender = 'E' AND education_eligible AND current_licence = 'B'
             AND completed_age BETWEEN 21 AND 23 THEN 'Only C Potential'
        WHEN gender = 'E' AND education_eligible AND current_licence = 'B'
             AND completed_age >= 24 THEN 'C-D Potential'
        WHEN current_licence = 'A1' AND completed_age >= 17 THEN 'B Potential'
        WHEN current_licence = 'A2' AND completed_age >= 20 THEN 'A Potential'
        WHEN gender = 'E' AND education_eligible AND current_licence = 'C'
             AND completed_age >= 24 THEN 'CE Potential'
        ELSE NULL
    END AS target_segment
FROM eligibility;

CREATE VIEW stg_exam_accounts AS
SELECT
    CAST(candidate_id AS INTEGER) AS candidate_id,
    CAST(total_debt AS REAL) AS total_debt,
    CAST(paid_amount AS REAL) AS paid_amount,
    CAST(remaining_debt AS REAL) AS remaining_debt,
    CAST(exam_fee_total AS REAL) AS exam_fee_total,
    CAST(exam_paid AS REAL) AS exam_paid,
    CAST(exam_remaining AS REAL) AS exam_remaining,
    date(certificate_issue_date) AS certificate_issue_date,
    CAST(calendar_year AS INTEGER) AS cohort_year,
    CAST(calendar_month AS INTEGER) AS cohort_month
FROM raw_exam_accounts;

CREATE VIEW stg_expenses AS
SELECT
    CAST(transaction_id AS INTEGER) AS transaction_id,
    date(transaction_date) AS transaction_date,
    TRIM(description) AS description,
    CAST(amount AS REAL) AS amount,
    CASE
        WHEN UPPER(description) LIKE '%YAKIT%' THEN 'Fuel'
        WHEN UPPER(description) LIKE '%ARAÇ BAKIM%' THEN 'Vehicle Maintenance'
        WHEN UPPER(description) LIKE '%PERSONEL%' THEN 'Personnel'
        WHEN UPPER(description) LIKE '%ÇAY%' THEN 'Refreshments'
        WHEN UPPER(description) LIKE '%BANKA%' THEN 'Bank'
        WHEN UPPER(description) LIKE '%KİRA%' THEN 'Rent'
        WHEN UPPER(description) LIKE '%KİTAP%' THEN 'Books'
        WHEN UPPER(description) LIKE '%DEMİRBAŞ%' THEN 'Equipment'
        ELSE 'Other'
    END AS expense_category
FROM raw_expenses;

CREATE VIEW stg_income AS
SELECT
    'TUITION-' || CAST(receipt_no AS TEXT) AS transaction_key,
    date(collection_date) AS transaction_date,
    'Tuition' AS income_category,
    CAST(amount AS REAL) AS amount
FROM raw_income
UNION ALL
SELECT
    'OTHER-' || CAST(transaction_id AS TEXT),
    date(transaction_date),
    'Other income',
    CAST(amount AS REAL)
FROM raw_other_income;

