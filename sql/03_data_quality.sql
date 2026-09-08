-- Auditable checks. Every row should return zero issues for the demo fixture.
CREATE VIEW quality_check_results AS
SELECT 'orphan_lead_event' AS check_name, COUNT(*) AS issue_count
FROM lead_events AS e
LEFT JOIN candidates AS c ON c.candidate_id = e.candidate_id
WHERE c.candidate_id IS NULL
UNION ALL
SELECT 'interested_without_contact', COUNT(*)
FROM lead_events AS interested
LEFT JOIN lead_events AS contacted
  ON contacted.candidate_id = interested.candidate_id
 AND contacted.event_type = 'contacted'
WHERE interested.event_type = 'interested'
  AND contacted.candidate_id IS NULL
UNION ALL
SELECT 'enrolled_without_interest', COUNT(*)
FROM lead_events AS enrolled
LEFT JOIN lead_events AS interested
  ON interested.candidate_id = enrolled.candidate_id
 AND interested.event_type = 'interested'
WHERE enrolled.event_type = 'enrolled'
  AND interested.candidate_id IS NULL
UNION ALL
SELECT 'stage_date_out_of_order', COUNT(*)
FROM lead_events AS later
JOIN lead_events AS earlier ON earlier.candidate_id = later.candidate_id
WHERE (later.event_type = 'interested' AND earlier.event_type = 'contacted'
       OR later.event_type = 'enrolled' AND earlier.event_type = 'interested')
  AND date(later.event_date) < date(earlier.event_date)
UNION ALL
SELECT 'future_birth_date', COUNT(*)
FROM candidates
WHERE date(birth_date) > date('2026-09-08')
UNION ALL
SELECT 'nonpositive_finance_amount', COUNT(*)
FROM finance_transactions
WHERE amount <= 0
UNION ALL
SELECT 'funnel_stage_increase', COUNT(*)
FROM (
    SELECT
        candidates,
        LAG(candidates) OVER (ORDER BY stage_order) AS previous_candidates
    FROM lead_funnel
)
WHERE previous_candidates IS NOT NULL AND candidates > previous_candidates;

