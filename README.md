# Driving School Targeting and Financial Report


[Run the public demo](#run-the-public-demo) — synthetic sample data, no private files or API key required.

| | |
|---|---|
| **Business impact** | Converts historic trainee records into a targeted licence-upgrade call list and unifies income and expense analysis. |
| **Tools** | Power BI, Power Query, DAX, Excel/VBA |
| **Status** | In operational use; source data remains private; attribution limitations are documented. |


**TL;DR:** A Power BI report for a driving school. It identifies past trainees who are eligible for commercial licence classes from their existing records and turns them into a call list. The same report brings together separately kept income and expense data to calculate the cost per trainee.

## Context

The school's data lived in five separate lists: trainee records, income, expenses, other income, and an exam-and-debt list. No connection existed between them.

The request I received was specific: identify past trainees eligible for truck, bus, and articulated lorry licences.

This identification was already being done, by hand. Finding eligible candidates meant re-filtering the lists every time. The data was also incomplete; trainee records, for example, carried no gender field. As a result the process wasn't systematic, it was largely ad hoc.

The report's purpose was to make this repeatable and to build a workflow around it.

## What was asked and what was added

The request covered only C, D, and E class candidates.

While working through it, I saw the same logic applied to the other classes and added A, A2, and B segments. Since no link existed between the school's financial data and its trainee data, I also brought in income, expenses, and cost-per-trainee analysis.

I'm marking this distinction because part of the report answers the request as given, and the rest answers questions that came up while working with the data.

## Preparing the data

Group information lived in a single text field: `1017/2020-January Group 1`. Readable by a person, not usable by a machine.

The income and debt lists carried only a certificate issue date, so when a group started and how many people were in it couldn't be derived from the data.

I parsed the text into group, year, and month columns. Resolving month names took a small Excel VBA function. A virtual date built from the year and month columns made groups trackable over time.

Trainee records also carried no gender field. I entered it by hand and integrated it into the segmentation.

## Marketing segmentation

Licence classes in Turkey have prerequisites. Class C requires a class B licence, CE requires class C, and each class has its own minimum age. That makes the school's past trainee records a ready-made candidate pool.

Each trainee is assigned one segment:

| Segment | Condition |
|---|---|
| Only C Potential | Class B licence, male, eligible education, age 21-23 |
| C-D Potential | Class B licence, male, eligible education, age 24+ |
| CE Potential | Class C licence, male, eligible education, age 24+ |
| A Potential | Class A2 licence, age 20+ |
| B Potential | Class A1 licence, age 17+ |
| Out of Scope | Everyone else |

The commercial classes (Only C, C-D, CE) carry two additional filters, on gender and education level. Neither A nor B applies them.

Both filters are assumptions, drawn from observing who actually takes up these licences in practice. The aim is to spend calling time on the people most likely to want one. Being assumptions, they risk excluding a real candidate, so I'm stating them as a deliberate narrowing rather than a hard rule.

The segmentation is written as a DAX calculated column. Table and column names below are translated for readability; the live version in the report keeps its original Turkish names, since other DAX in the model references this column directly.

```dax
Marketing Segment = 
VAR CurrentAge = [Age]
VAR IsMale = [Gender] = "Male"
VAR EducationEligible = [Education Level] IN { "Primary School", "Middle School", "High School", "Elementary Education", "Vocational-Technical High School", "Adult Education Stage 2", "Associate Degree" }
VAR HasB = 'Trainee List'[Certificate] = "B"
VAR HasA1 = 'Trainee List'[Certificate] IN { "A1", "A1 Automatic" }
VAR HasA2 = 'Trainee List'[Certificate] = "A2"
VAR HasC = 'Trainee List'[Certificate] = "C"
RETURN
SWITCH(
    TRUE(),
    IsMale && EducationEligible && HasB && CurrentAge >= 21 && CurrentAge <= 23, "Only C Potential",
    IsMale && EducationEligible && HasB && CurrentAge >= 24, "C-D Potential",
    HasA1 && CurrentAge >= 17, "B Potential",
    HasA2 && CurrentAge >= 20, "A Potential",
    IsMale && EducationEligible && HasC && CurrentAge >= 24, "CE Potential",
    "Out of Scope"
)
```

Each trainee has one row, evaluated on their most recently obtained certificate.

**Age means completed years at model refresh.** The `Yaş` calculated column compares the birth month and day with `TODAY()`, so someone born on 31 December 2005 is still 20 on 8 September 2026. Missing or future birth dates return blank and do not meet the age thresholds. For 29 February births, this model advances age on 1 March in non-leap years. Age and the dependent segments update when the model is refreshed.

## Expense categorization

Expense records carried a description field but no category. Reading through the descriptions turned up recurring patterns, and nine categories were defined from keywords in that text. The classification runs in Power Query M, so it re-runs automatically on every refresh.

This makes each expense category's share of total spending visible as a percentage.

## How it's used

The report doesn't just produce a list, it includes the path to acting on it.

The user opens the segment they want to look at through a decomposition tree. If commercial-class capacity is full for a given month, they can shift focus to the motorcycle or automobile segments instead.

Drilling through from a segment leads to a detail table carrying the trainee's group, age, licence class, and phone number. Getting from analysis to a call takes two clicks.

## Numbers

The reported licence-upgrade funnel contains **200 targeted contacts, 47 expressions of interest, and 12 enrolments**. Its reporting period and snapshot date are not specified in the available records. These are reported observations, not current live totals or results from the public demo.

| Metric | Count | Denominator | Rate |
|---|---:|---|---:|
| Targeted contacts reached | 200 | Base of the reported funnel | — |
| Expressed interest in a new licence class | 47 | 200 targeted contacts | 23.50% |
| Enrolled after expressing interest | 12 | 47 interested contacts | 25.53% |
| Contact-to-enrolment conversion | 12 | 200 targeted contacts | 6.00% |

A separate launch-month note reports **8 enrolments in the month the report launched**. The calendar month and whether those 8 are included in the 12 above are not documented. The counts therefore cannot be reconciled into a time series or a combined total.

Enrolment is a count of people, not a revenue amount. The figures describe the observed funnel; they do not establish how many enrolments were caused by the calls.

An unplanned result also came out of this. Some of the people called turned out to be interested in psychotechnical assessment instead of a licence. They aren't counted among the 47. A single call ended up generating demand for a second, untargeted service.

## Limitations and next step

**The cost-per-trainee chart uses nominal values.** Most of the rise seen from 2020 to 2025 is inflation, not a real cost increase. The chart doesn't measure real cost change.

**The data transformation was done in Excel.** This was the first Power BI work I did with real data, and the group-parsing step was done in Excel rather than Power Query. As a result, that step has to be repeated by hand on every update. The right approach would have been to do it in Power Query; the next version will.

**Attribution for the enrolments isn't measured.** Neither the 12-enrolment funnel nor the separate 8-enrolment launch-month observation shows how many people would have enrolled without being called. Their scope and missing period information are documented under [Numbers](#numbers).

**The data isn't published here.** This repository holds the code and the method, not the data. Monetary values in the screenshots are scaled. Category percentages are real.

## Run the public demo

The public demo uses **fully synthetic data**, generated locally without private files, credentials, or API requests. Demo figures are illustrative and do not reproduce the [reported business results](#numbers).

1. Download this repository (Code → Download ZIP) and extract it, or clone it.
2. Install Python 3.10+ and a current Power BI Desktop for Windows with PBIP/TMDL support.
3. Close the project in Power BI Desktop, then run these commands from the repository folder:

```bash
python -m pip install -r requirements.txt
python scripts/setup_demo.py
```

4. Open `pbip/driving_mock_report.pbip` and select **Refresh**.

The script writes the sample workbooks to `demo-data/` and updates the single `DemoDataFolder` Power Query parameter in the local project. If you move the repository, close Power BI Desktop and run the setup command again. To use another sample-data location, run `python scripts/setup_demo.py --data-dir "path/to/demo-data"`. You can also edit `DemoDataFolder` through **Transform data → Manage Parameters**.

Python can generate the files on Windows, macOS, or Linux; opening the report requires [Power BI Desktop](https://learn.microsoft.com/en-us/power-bi/developer/projects/projects-overview). No Power BI Service workspace or cloud refresh setup is required for this local demo. If a map requests an online map service, the remaining report pages can still be reviewed offline.

The sample is anchored to 2026. It contains invented identities and transactions, with matching keys across related tables. Existing screenshots and operational results describe the original project; their totals will differ from this demo.

Run the automated source-data and relocation checks with:

```bash
python -m unittest discover -s tests -v
```

To check age boundaries in the actual DAX engine, generate a query from the current model expression:

```bash
python scripts/build_age_checks.py --output demo-data/age_checks.dax
```

Open the generated file, copy its contents into Power BI Desktop's **DAX query view**, and run it. An empty result means all 18 cases passed; any returned row shows an expected and actual age that differ. The cases cover birthdays at the 17, 20, 21 and 24 thresholds, year changes, leap-day birthdays, missing/future dates and age zero. This uses the model's actual formula with fixed test dates, rather than a separately maintained copy of the age calculation. The Python command generates the query; it does not execute or validate it in the DAX engine.
