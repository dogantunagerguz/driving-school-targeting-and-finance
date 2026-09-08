-- Raw landing tables mirror all five public Power BI demo workbooks.

CREATE TABLE raw_candidates (
    source_row_no   INTEGER,
    candidate_id    INTEGER,
    first_name      TEXT,
    last_name       TEXT,
    gender          TEXT,
    group_label     TEXT,
    education_level TEXT,
    birth_date      TEXT,
    current_licence TEXT,
    calendar_year   INTEGER,
    calendar_month  INTEGER,
    group_number    INTEGER
);

CREATE TABLE raw_exam_accounts (
    candidate_id           INTEGER,
    total_debt             NUMERIC,
    paid_amount            NUMERIC,
    remaining_debt         NUMERIC,
    exam_fee_total         NUMERIC,
    exam_paid              NUMERIC,
    exam_remaining         NUMERIC,
    certificate_issue_date TEXT,
    calendar_year          INTEGER,
    calendar_month         INTEGER
);

CREATE TABLE raw_income (
    receipt_no       INTEGER,
    collection_date TEXT,
    candidate_id     INTEGER,
    licence_group    TEXT,
    amount           NUMERIC,
    calendar_year    INTEGER,
    calendar_month   INTEGER
);

CREATE TABLE raw_expenses (
    transaction_id   INTEGER,
    transaction_date TEXT,
    description      TEXT,
    amount           NUMERIC
);

CREATE TABLE raw_other_income (
    transaction_id   INTEGER,
    transaction_date TEXT,
    description      TEXT,
    amount           NUMERIC
);

