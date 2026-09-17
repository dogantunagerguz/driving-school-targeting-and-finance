[← Project overview](../README.md) · [Full project story](story.md) · [Dashboard walkthrough](dashboard.md)

# From candidate selection to staff action

## Business question

Which past trainees are worth contacting for another licence class, and how can staff make that choice alongside a shared view of the school's finances?

The initial request concerned commercial-licence candidates. Staff were already identifying them manually, repeatedly filtering incomplete lists. I made that selection repeatable, then used the same work to address other licence classes and the gap between trainee and financial records.

## Decisions I made

| Decision | Reason and operational use | Evidence |
|---|---|---|
| Extend the commercial-licence request to motorcycle and car segments | Staff can change the segment they contact when a commercial class is full, using their knowledge of available capacity. | [Scope expansion](story.md#what-was-asked-and-what-was-added), [report use](story.md#how-its-used) |
| Separate group, month and year from a combined text field | Cohorts become usable for time-based analysis instead of requiring a new manual interpretation each time. Excel/VBA performs this preparation step. | [Data preparation](story.md#preparing-the-data) |
| Put the selection rules into the model and provide a drill-through detail table | The segment, year and age-band view leads to the trainee details staff need for a call. Each trainee is evaluated on their most recent certificate. | [Segmentation](story.md#marketing-segmentation), [contact detail view](dashboard.md#candidate-detail-table) |
| Bring the financial sources into the analysis and classify expenses into nine categories | Staff can review income, expenses, debt and nominal cost per trainee alongside the trainee analysis. Power Query reruns the expense classification on refresh. | [Expense categories](story.md#expense-categorization), [financial view](dashboard.md#financial-overview) |

The commercial segments include gender and education filters based on observed take-up. These are targeting assumptions, not statutory eligibility requirements; they can exclude a potential candidate. The report makes that narrowing explicit in the [rule documentation](story.md#marketing-segmentation).

## Sources, units of analysis and constraints

The five source types are trainee records, tuition income, expenses, other income, and exam/debt accounts. The trainee view uses one row per person; financial transactions and account balances have different meanings and should not be counted as trainees. In the public SQL companion, income, expenses and trainee counts are aggregated separately before the yearly finance view is joined. Its [data dictionary](../sql/DATA_DICTIONARY.md) records the table grains.

Group parsing remains an Excel preparation step repeated when the source is updated. The report is refreshed manually. Age and its dependent segments recalculate on model refresh. Cost-per-trainee comparisons use nominal amounts and do not establish inflation-adjusted cost changes.

## How staff use it

1. Prepare the source files and refresh the model.
2. Choose the licence segment using current class capacity, then narrow by cohort and age band.
3. Drill through to the detail table and contact the selected trainees through the existing staff process.
4. Review expense categories and cost-per-trainee trends for cost questions, keeping the nominal-value limitation in view.

These steps connect analysis to a person taking action. A dated log linking every contact, outcome and enrolment is a proposed extension; it is not demonstrated by this repository's reported funnel.

## Evidence and outcome scope

- [Dashboard pages](dashboard.md) show the original selection and financial views; names and contact details are anonymised and monetary values are scaled.
- [Reported results](story.md#numbers) describe 200 contacts, 47 expressions of interest and 12 enrolments. Their period and row-level source are not public. These observations do not establish incremental enrolments caused by the report. The separate eight-enrolment launch-month note is not added to the funnel because overlap is unknown.
- [SQL results](../sql/RESULTS.md), [queries](../sql/03_marts.sql) and [checks](../sql/04_quality_checks.sql) demonstrate the public synthetic companion. They are separate from the original Power BI and Excel/VBA workflow.

## Implemented and proposed work

**Implemented:** source preparation, licence segmentation, drill-through contact views, expense categorisation, financial reporting and a runnable synthetic SQL companion.

**Proposed, not implemented here:** move group parsing into Power Query; record contact dates, selected segments and enrolment outcomes consistently; define comparable reporting periods before evaluating campaign performance. These changes would make the preparation and feedback process easier to maintain and assess.
