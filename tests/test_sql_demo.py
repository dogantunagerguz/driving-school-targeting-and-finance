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

    def test_pipeline_loads_all_public_demo_sources(self):
        row = self.connection.execute("""
            SELECT candidates, exam_accounts, tuition_receipts,
                   expense_rows, other_income_rows
            FROM pipeline_reconciliation
        """).fetchone()
        self.assertEqual(tuple(row), (48, 48, 48, 648, 72))

    def test_completed_age_and_targeting_use_fixed_as_of_date(self):
        row = self.connection.execute("""
            SELECT completed_age, target_segment
            FROM candidate_targeting_2026
            WHERE candidate_id = 1001
        """).fetchone()
        self.assertEqual(tuple(row), (22, "Only C Potential"))

    def test_reported_funnel_denominators_are_explicit(self):
        row = self.connection.execute("""
            SELECT targeted_contacts, interested, enrolled,
                   contact_to_interest_pct, interest_to_enrolment_pct,
                   contact_to_enrolment_pct
            FROM reported_funnel_reconciliation
        """).fetchone()
        self.assertEqual(tuple(row), (200, 47, 12, 23.5, 25.53, 6.0))

    def test_all_quality_checks_pass(self):
        failures = self.connection.execute(
            "SELECT check_name FROM quality_check_results WHERE issue_count <> 0"
        ).fetchall()
        self.assertEqual(failures, [])

    def test_committed_results_snapshot_is_current(self):
        expected = run_demo.render_results(self.connection)
        actual = (ROOT / "sql/RESULTS.md").read_text(encoding="utf-8")
        self.assertEqual(actual, expected)


if __name__ == "__main__":
    unittest.main()

