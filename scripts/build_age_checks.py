#!/usr/bin/env python3
"""Generate a Power BI DAX regression query from the model's actual age formula.

This script generates checks; it does not execute DAX. Run the resulting query
in Power BI Desktop's DAX query view. An empty result means every case passed.
"""

import argparse
import re
import textwrap
from datetime import date
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MODEL = ROOT / "pbip/driving_mock_report.SemanticModel/definition/tables/Kursiyer Listesi.tmdl"

# Expected ages are fixed examples, independent of the implementation.
# Feb 29 birthdays advance on March 1 in non-leap years (model convention).
CASES = [
    ("Original year-boundary regression", "2005-12-31", "2026-09-08", 20),
    ("Before 17th birthday", "2009-09-08", "2026-09-07", 16),
    ("On 17th birthday", "2009-09-08", "2026-09-08", 17),
    ("Before 20th birthday", "2006-09-08", "2026-09-07", 19),
    ("On 20th birthday", "2006-09-08", "2026-09-08", 20),
    ("Before 21st birthday", "2005-09-08", "2026-09-07", 20),
    ("On 21st birthday", "2005-09-08", "2026-09-08", 21),
    ("Before 24th birthday", "2002-09-08", "2026-09-07", 23),
    ("On 24th birthday", "2002-09-08", "2026-09-08", 24),
    ("Feb 29 before non-leap anniversary", "2008-02-29", "2026-02-28", 17),
    ("Feb 29 on non-leap anniversary", "2008-02-29", "2026-03-01", 18),
    ("Feb 29 before leap anniversary", "2008-02-29", "2028-02-28", 19),
    ("Feb 29 on leap anniversary", "2008-02-29", "2028-02-29", 20),
    ("Missing birth date", None, "2026-09-08", None),
    ("Future birth date", "2026-09-09", "2026-09-08", None),
    ("Born today", "2026-09-08", "2026-09-08", 0),
    ("Year change is not a birthday", "2005-12-31", "2026-01-01", 20),
    ("Birthday on New Year", "2005-01-01", "2026-01-01", 21),
]


def age_expression():
    source = MODEL.read_text(encoding="utf-8")
    match = re.search(r"(?ms)^\tcolumn Yaş =(?P<body>.*?)^\t\tformatString:", source)
    if match is None:
        raise ValueError("Cannot locate the model's Yaş calculated column.")
    expression = textwrap.dedent(match.group("body")).strip()
    expression, birth_count = re.subn(
        re.escape("'Kursiyer Listesi'[D.TARİHİ]") + r"(?:\.\[Date\])?",
        "[BirthDate]", expression,
    )
    expression, today_count = re.subn(r"\bTODAY\s*\(\s*\)", "[AsOfDate]", expression)
    if birth_count != 1 or today_count != 1:
        raise ValueError("Expected exactly one birth-date reference and one TODAY() call.")
    return expression


def dax_date(value):
    if value is None:
        return "BLANK()"
    parsed = date.fromisoformat(value)
    return f"DATE({parsed.year}, {parsed.month}, {parsed.day})"


def build_query():
    rows = []
    for name, birth, as_of, expected in CASES:
        label = name.replace('"', '""')
        expected_dax = "BLANK()" if expected is None else str(expected)
        rows.append(
            f'        ROW("CaseName", "{label}", "BirthDate", {dax_date(birth)}, '
            f'"AsOfDate", {dax_date(as_of)}, "ExpectedAge", {expected_dax})'
        )
    fixtures = ",\n".join(rows)
    formula = textwrap.indent(age_expression(), "        ")
    return (
        "// Generated from the model's current Yaş expression; no private data.\n"
        f"// {len(CASES)} fixed cases. Run in DAX query view: zero rows means all passed.\n"
        "// Strict equality keeps BLANK distinct from a valid age of zero.\n"
        "EVALUATE\n"
        "VAR TestCases =\n    UNION(\n" + fixtures + "\n    )\n"
        "VAR Results =\n    ADDCOLUMNS(\n        TestCases,\n        \"ActualAge\",\n"
        + formula + "\n    )\n"
        "RETURN\n    FILTER(Results, NOT([ActualAge] == [ExpectedAge]))\n"
    )


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True, help="Generated .dax file")
    args = parser.parse_args()
    query = build_query()
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(query, encoding="utf-8")
    print(f"Generated {len(CASES)} age cases in {args.output}.")
    print("Run this query in Power BI Desktop's DAX query view; zero rows means all passed.")


if __name__ == "__main__":
    main()
