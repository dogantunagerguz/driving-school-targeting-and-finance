-- Fully synthetic SQLite fixture for the driving-school portfolio project.
-- Counts and identities below are invented and are not operational results.

PRAGMA foreign_keys = ON;

CREATE TABLE candidates (
    candidate_id     INTEGER PRIMARY KEY,
    candidate_name   TEXT NOT NULL,
    gender           TEXT NOT NULL CHECK (gender IN ('M', 'F')),
    education_level  TEXT NOT NULL,
    birth_date       TEXT NOT NULL,
    current_licence  TEXT NOT NULL CHECK (current_licence IN ('A1', 'A2', 'B', 'C', 'D'))
);

CREATE TABLE lead_events (
    candidate_id INTEGER NOT NULL REFERENCES candidates(candidate_id),
    event_type   TEXT NOT NULL CHECK (event_type IN ('contacted', 'interested', 'enrolled')),
    event_date   TEXT NOT NULL,
    PRIMARY KEY (candidate_id, event_type)
);

CREATE TABLE finance_transactions (
    transaction_id   INTEGER PRIMARY KEY,
    transaction_date TEXT NOT NULL,
    transaction_type TEXT NOT NULL CHECK (transaction_type IN ('income', 'expense')),
    category         TEXT NOT NULL,
    amount           NUMERIC NOT NULL CHECK (amount > 0)
);

INSERT INTO candidates (
    candidate_id, candidate_name, gender, education_level, birth_date, current_licence
) VALUES
    (1,  'DEMO CANDIDATE 001', 'M', 'High School',      '2004-01-15', 'B'),
    (2,  'DEMO CANDIDATE 002', 'M', 'Associate Degree', '1995-01-15', 'B'),
    (3,  'DEMO CANDIDATE 003', 'M', 'High School',      '1990-01-15', 'C'),
    (4,  'DEMO CANDIDATE 004', 'F', 'University',       '2004-01-15', 'A2'),
    (5,  'DEMO CANDIDATE 005', 'F', 'High School',      '2008-01-15', 'A1'),
    (6,  'DEMO CANDIDATE 006', 'F', 'High School',      '1995-01-15', 'B'),
    (7,  'DEMO CANDIDATE 007', 'M', 'University',       '1995-01-15', 'B'),
    (8,  'DEMO CANDIDATE 008', 'M', 'High School',      '1985-01-15', 'D'),
    (9,  'DEMO CANDIDATE 009', 'M', 'High School',      '2005-12-31', 'B'),
    (10, 'DEMO CANDIDATE 010', 'M', 'High School',      '2005-09-08', 'B'),
    (11, 'DEMO CANDIDATE 011', 'M', 'High School',      '2002-09-09', 'C'),
    (12, 'DEMO CANDIDATE 012', 'M', 'Middle School',    '2006-09-08', 'A2');

INSERT INTO lead_events (candidate_id, event_type, event_date) VALUES
    (1,  'contacted',  '2026-01-05'), (1, 'interested', '2026-01-10'), (1, 'enrolled', '2026-02-01'),
    (2,  'contacted',  '2026-01-06'), (2, 'interested', '2026-01-15'),
    (3,  'contacted',  '2026-02-01'), (3, 'interested', '2026-02-10'), (3, 'enrolled', '2026-03-01'),
    (4,  'contacted',  '2026-03-01'), (4, 'interested', '2026-03-04'),
    (5,  'contacted',  '2026-03-02'),
    (6,  'contacted',  '2026-03-03'),
    (7,  'contacted',  '2026-03-04'),
    (8,  'contacted',  '2026-03-05'),
    (9,  'contacted',  '2026-03-06'),
    (10, 'contacted',  '2026-03-07');

INSERT INTO finance_transactions (
    transaction_id, transaction_date, transaction_type, category, amount
) VALUES
    (1,  '2026-01-10', 'income',  'Tuition',   13000),
    (2,  '2026-01-15', 'expense', 'Rent',       3000),
    (3,  '2026-01-15', 'expense', 'Fuel',       1000),
    (4,  '2026-01-15', 'expense', 'Personnel',  2000),
    (5,  '2026-02-10', 'income',  'Tuition',    8000),
    (6,  '2026-02-15', 'expense', 'Rent',       3000),
    (7,  '2026-02-15', 'expense', 'Fuel',       1200),
    (8,  '2026-02-15', 'expense', 'Personnel',  2300),
    (9,  '2026-03-10', 'income',  'Tuition',   10000),
    (10, '2026-03-15', 'expense', 'Rent',       3000),
    (11, '2026-03-15', 'expense', 'Fuel',       1400),
    (12, '2026-03-15', 'expense', 'Personnel',  2600);

