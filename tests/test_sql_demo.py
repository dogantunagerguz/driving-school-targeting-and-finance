import sys
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "sql"))
import run_demo  # noqa: E402


class SqlPortfolioDemoTests(unittest.TestCase):
    def setUp(self):
        self.connection = run_demo.build_connection()

    def tearDown(self):
        self.connection.close()

    def test_completed_age_boundaries(self):
        rows = self.connection.execute("""
            SELECT candidate_id, completed_age
            FROM candidate_targeting_2026
            WHERE candidate_id IN (9, 10)
            ORDER BY candidate_id
        """).fetchall()
        self.assertEqual([tuple(row) for row in rows], [(9, 20), (10, 21)])

    def test_target_segments_match_fixture(self):
        rows = self.connection.execute("""
            SELECT candidate_id, target_segment
            FROM candidate_targeting_2026
            WHERE candidate_id IN (1, 2, 3, 4, 5, 10, 12)
            ORDER BY candidate_id
        """).fetchall()
        self.assertEqual([tuple(row) for row in rows], [
            (1, "Only C Potential"),
            (2, "C-D Potential"),
            (3, "CE Potential"),
            (4, "A Potential"),
            (5, "B Potential"),
            (10, "Only C Potential"),
            (12, "A Potential"),
        ])

    def test_funnel_uses_distinct_candidates_and_correct_denominators(self):
        rows = self.connection.execute("""
            SELECT stage_name, candidates, conversion_from_contact_pct,
                   conversion_from_previous_stage_pct
            FROM lead_funnel ORDER BY stage_order
        """).fetchall()
        self.assertEqual([tuple(row) for row in rows], [
            ("Contacted", 10, 100.0, None),
            ("Interested", 4, 40.0, 40.0),
            ("Enrolled", 2, 20.0, 50.0),
        ])

    def test_finance_is_aggregated_before_enrolment_join(self):
        rows = self.connection.execute("""
            SELECT activity_month, expense, enrolled_candidates, cost_per_enrolment
            FROM monthly_finance_kpis ORDER BY activity_month
        """).fetchall()
        self.assertEqual([tuple(row) for row in rows], [
            ("2026-01", 6000, 0, None),
            ("2026-02", 6500, 1, 6500.0),
            ("2026-03", 7000, 1, 7000.0),
        ])

    def test_all_quality_checks_pass(self):
        failures = self.connection.execute(
            "SELECT check_name FROM quality_check_results WHERE issue_count <> 0"
        ).fetchall()
        self.assertEqual(failures, [])


if __name__ == "__main__":
    unittest.main()

