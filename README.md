# Driving School Targeting and Finance

![Dashboard](assets/dashboard.png)

**What it does:** Turns past trainee records into licence-upgrade call lists and combines income, expenses, and cost-per-trainee analysis.  
**Tools:** Power BI · DAX · Power Query · Excel/VBA · Python · SQLite  
**Status:** In operational use; manual refresh and Excel preparation step; source data private.

[▶ Run the public demo](#run-the-public-demo) · [SQL companion](sql/) · [Full story](docs/story.md)

The cover shows the **Decomposition Tree**: segment → year → age band. [Explore all four dashboard pages](docs/dashboard.md).

Python and SQLite support the public demo and SQL companion; the original operational workflow uses Power BI and Excel/VBA.

## Run the public demo

The demo generates **fully synthetic data** locally, without private files, credentials, or API requests. Its illustrative figures do not reproduce the [reported business results](docs/story.md#numbers).

1. Download this repository (Code → Download ZIP) and extract it, or clone it.
2. Install Python 3.10+ and a current Power BI Desktop for Windows with PBIP/TMDL support.
3. Close the project in Power BI Desktop, then run these commands from the repository folder:

```bash
python -m pip install -r requirements.txt
python scripts/setup_demo.py
```

4. Open `pbip/driving_mock_report.pbip` and select **Refresh**.

Setup writes sample workbooks to `demo-data/` and updates the local `DemoDataFolder` Power Query parameter. If you move the repository, close Power BI Desktop and run setup again. For another sample-data location, use `python scripts/setup_demo.py --data-dir "path/to/demo-data"`, or edit the parameter through **Transform data → Manage Parameters**.

Python can generate the files on Windows, macOS, or Linux; opening the report requires [Power BI Desktop](https://learn.microsoft.com/en-us/power-bi/developer/projects/projects-overview). No Power BI Service workspace or cloud refresh setup is needed. Map visuals may request an online map service; other pages remain available offline. The sample is anchored to 2026; its totals differ from the original screenshots and operational results.

## SQL evidence and checks

The [SQL companion README](sql/README.md) explains source-to-mart lineage, completed-age targeting, finance pre-aggregation, window-function ranking, and reconciliation checks across the same five synthetic workbooks.

[Executed SQL results](sql/RESULTS.md) · [SQL data dictionary](sql/DATA_DICTIONARY.md) · [CI workflow](https://github.com/dogantunagerguz/driving-school-targeting-and-finance/actions/workflows/ci.yml)

From the repository folder, run the SQL demo and automated tests:

```bash
python sql/run_demo.py
python -m unittest discover -s tests -v
```

For the additional age-boundary query that must be run in Power BI Desktop's DAX query view, see the [full demo and DAX validation instructions](docs/story.md#run-the-public-demo).
