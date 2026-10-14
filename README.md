# Bank Loan Report — Loan Portfolio Analysis

**Project type:** Data analytics learning case study  
**Tools:** PostgreSQL, DBeaver, Power BI  
**Data period in the supplied CSV:** 1 January–12 December 2021

## Project overview

This case study reviews loan application volume, loan amounts, recorded payments, interest rates, debt-to-income ratio (DTI), loan status, and loan purpose. It turns the dataset into business questions, summary metrics, findings, and recommendations.

## Business questions

1. How many loan applications are in the dataset, and what is the total funded amount?
2. What amount of payments is recorded across the loan records?
3. How are loans distributed across `Fully Paid`, `Current`, and `Charged Off`?
4. Which loan purposes account for the largest number of applications?
5. How do applications vary by recorded issue month, and what date-coverage caveats should be considered?

## Data checks and preparation

- Rows: **38,576**
- Columns: **24**
- Unique loan IDs: **38,576**
- Duplicate full rows detected in the supplied CSV: **0**
- Empty `emp_title` values: **1,438** (**3.73%** of rows)
- Source `issue_date` format: `MM/DD/YYYY`; dates need to be parsed before time-based analysis.
- Maximum `issue_date`: **12 December 2021**, so December is incomplete in the supplied file.

## Key results

| Metric | Result |
|---|---:|
| Loan applications | 38,576 (Power BI display: 38.6K) |
| Total funded amount | $435,757,075 (Power BI display: $435.8M) |
| Total amount received / payment recorded | $473,070,933 (Power BI display: $473.1M) |
| Average interest rate | 12.049% (Power BI display: 12.05%) |
| Average DTI | 13.327% (Power BI display: 13.33%) |
| Good Loan (`Fully Paid` + `Current`) | 33,243 (86.18%) |
| Bad Loan (`Charged Off`) | 5,333 (13.82%) |

Good Loan and Bad Loan follow the supplied project brief. These are reporting categories, not a credit-risk prediction model.

## Findings

- `Fully Paid` is the largest status group (**32,145** records), followed by `Charged Off` (**5,333**) and `Current` (**1,098**).
- `Debt consolidation` is the most common purpose, with **18,214 applications** (about **47.2%** of all records).
- The supplied file ends on 12 December 2021. Interpret monthly counts with care, especially December, until date coverage is confirmed consistently.

## Recommendations

1. Examine `Charged Off` by loan grade/sub-grade, term, interest rate, DTI, and purpose to identify segments for further review.
2. For `Debt consolidation`, compare status mix and average loan amount rather than relying only on application volume.
3. Confirm date coverage and use comparable periods before interpreting month-over-month changes.
4. Do not treat `total_payment` grouped by `issue_date` as cash received during that month. A payment date is needed for a true monthly collections analysis.

## Files in this repository

- `presentation/Bank_Loan_Report_Portfolio.pptx` — editable storytelling presentation.
- `presentation/Bank_Loan_Report_Portfolio.pdf` — PDF preview of the same presentation.
- `analysis/Bank_Loan_Report_Analysis.sql` — PostgreSQL queries for data checks and summary analysis.
- `assets/loan_status_summary.png` — preview of the Power BI Summary layout: Good Loan Issued, Bad Loan Issued, and Loan Status table.
- `assets/top_loan_purposes.png` — Top 10 purpose categories, with compact values consistent with the Power BI display.
- `assets/monthly_applications.png` — monthly application trend, with compact values consistent with the Power BI display.

## How this matches the Power BI report

The dashboard-related slides use matching metric definitions and displayed values from the Power BI report:

- **Slide 6:** Key KPIs, including applications, funded amount, recorded payments, average interest rate, and average DTI.
- **Slide 7:** Summary-page content — Good Loan Issued, Bad Loan Issued, and the Loan Status table. It does not use a separate Fully Paid / Charged Off / Current bar chart as a substitute for the Power BI visuals.
- **Slide 8:** Top 10 loan purposes from the Overview page.
- **Slide 9:** Monthly applications from the Overview page, including the caveat that December is incomplete.

Power BI abbreviates values for display (for example, 38.6K); the presentation may show a more precise underlying value where useful. These values are consistent after rounding. The presentation is a storytelling companion to the interactive dashboard, so its narrative pages (introduction, data checks, and recommendations) are not additional Power BI visuals.

## Project provenance and scope

This is a learning case study based on a supplied project brief, dataset, and reference project assets. The metrics were recalculated from the supplied CSV, and selected SQL summaries were reproduced in PostgreSQL. Describe personal contributions accurately; do not imply that an existing Power BI dashboard was built from scratch if it was supplied as part of the project materials.

## Publishing note

Before publishing, confirm that the source license permits public sharing. Do not upload the raw CSV or the `.pbix` file containing embedded data unless permission to redistribute is clear. The raw dataset and PBIX are intentionally excluded from this repository.
