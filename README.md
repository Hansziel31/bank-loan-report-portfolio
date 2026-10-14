# Bank Loan Report — Loan Portfolio Analysis

A data analytics project exploring loan application volume, funding, recorded payments, loan status, borrower characteristics, and application trends. PostgreSQL is used for data checks and SQL analysis, while Power BI presents key metrics and patterns across the loan portfolio.

## Dashboard Preview

### Summary

The Summary page presents the main portfolio KPIs, Good Loan and Bad Loan indicators, and a loan-status table.

![Bank Loan Report — Summary dashboard](Image/Dashboard%20Summary.png)

### Overview

The Overview page highlights monthly application counts, applications by loan term, employee length and purpose, home ownership, and the state map.

![Bank Loan Report — Overview dashboard](Image/Dashboard%20Overview.png)

## Project Objectives

- Summarize application volume, total funded amount, recorded payments, average interest rate, and average debt-to-income ratio (DTI).
- Review the distribution of `Fully Paid`, `Current`, and `Charged Off` loans.
- Identify the loan purposes with the highest application volume.
- Explore application trends by issue month and borrower or loan characteristics.
- Translate the findings into practical questions for further analysis.

## Business Questions

1. How many loan applications are recorded, and what is the total funded amount?
2. What total payment amount is recorded across the loan records?
3. How are applications distributed across `Fully Paid`, `Current`, and `Charged Off` statuses?
4. Which loan purposes account for the highest number of applications?
5. How do application counts vary by issue month, and what date-coverage limitations should be considered?

## Dataset Overview

| Item | Value |
|---|---:|
| Records | 38,576 |
| Columns | 24 |
| Unique loan IDs | 38,576 |
| Duplicate loan IDs | 0 |
| Missing `emp_title` values | 1,438 (3.73%) |
| Earliest issue date | January 1, 2021 |
| Latest issue date | December 12, 2021 |

The source `issue_date` values use the `MM/DD/YYYY` format and must be parsed as dates for time-based analysis. Because the dataset ends on December 12, December is an incomplete month and should be interpreted carefully.

## Tools and Methods

- **PostgreSQL / DBeaver:** data checks, date parsing, aggregations, loan-status summaries, monthly application trends, and comparisons by loan characteristics.
- **Power BI:** KPI cards, status indicators, a loan-status table, monthly trend, state map, loan-term distribution, and categorical breakdowns.
- **Data storytelling:** concise findings, limitations, and recommendations based on the available data.

## Key Metrics

The detailed values below are calculated from the 38,576 records. Power BI uses compact display formats for the dashboard cards.

| Metric | Detailed result | Power BI display |
|---|---:|---:|
| Total loan applications | 38,576 | 38.6K |
| Total funded amount | $435,757,075 | $435.8M |
| Total amount received (`total_payment`) | $473,070,933 | $473.1M |
| Average interest rate | 12.049% | 12.05% |
| Average DTI | 13.327% | 13.33% |
| Good Loan applications (`Fully Paid` + `Current`) | 33,243 (86.18%) | 33.2K (86.18%) |
| Bad Loan applications (`Charged Off`) | 5,333 (13.82%) | 5.3K (13.82%) |

### Dashboard KPI Details

| KPI | Overall | MTD | MoM |
|---|---:|---:|---:|
| Total Loan Application | 38.6K | 4.3K | 6.9% |
| Total Funded Amount | $435.8M | $54.0M | 13.0% |
| Total Amount Received | $473.1M | $58.1M | 15.8% |
| Average Interest Rate | 12.05% | 12.4% | 3.5% |
| Average DTI | 13.33% | 13.7% | 2.7% |

**Metric definitions:** `Total Amount Received` is the sum of the `total_payment` field in the dataset; it is not the bank's net profit. In this report, **Good Loan** is defined as `Fully Paid` plus `Current`, while **Bad Loan** is defined as `Charged Off`. These are reporting groups, not predictions from a credit-risk model.

## Loan Status Summary

| Loan status | Applications | Share of all applications |
|---|---:|---:|
| Fully Paid | 32,145 | 83.33% |
| Current | 1,098 | 2.85% |
| Charged Off | 5,333 | 13.82% |
| **Total** | **38,576** | **100.00%** |

## Key Findings

- `Fully Paid` is the largest status group, with **32,145 records**. `Charged Off` accounts for **5,333 records**, while `Current` accounts for **1,098 records**.
- `Debt consolidation` is the most common loan purpose, with **18,214 applications**, or approximately **47.2%** of all records.
- Monthly application counts rise from approximately **2.3K in January** to **4.0K in November**. December shows approximately **4.3K** applications in the dataset, but the month is incomplete because the latest issue date is December 12, 2021.
- Application volume alone does not establish that a purpose or borrower group is more profitable or has a higher default risk. Loan status and other characteristics should be examined before drawing those conclusions.

## Power BI Report Pages

| Page | Main content |
|---|---|
| **Summary** | KPI cards, Good Loan Issued and Bad Loan Issued indicators, and the Loan Status table. |
| **Details** | Loan-level records with fields such as purpose, grade, issue date, funded amount, interest rate, installment, and amount received. |
| **Overview** | Monthly applications, state map, loan-term distribution, applications by employee length and purpose, and home ownership. |

## Recommendations

1. Review `Charged Off` loans by grade/sub-grade, term, interest rate, DTI, and purpose to identify segments for further investigation.
2. For `Debt consolidation`, compare the loan-status distribution and average loan amount rather than relying on application volume alone.
3. Confirm date coverage and compare equivalent periods before interpreting month-over-month changes, especially when the final month is incomplete.
4. For monthly collections analysis, use an actual payment date if available. Grouping `total_payment` by `issue_date` does not show when cash was received.

## Repository Contents

- [PowerPoint presentation](Presentation/Bank_Loan_PPT.pptx) — editable portfolio presentation.
- [SQL analysis](Analysis/Bank-Loan-Report_Analysis.sql) — PostgreSQL queries for data checks and summary analysis.
- [Dataset](Dataset/financialloandata%285%29.csv) — dataset used for the analysis.
- [Dashboard Summary image](Image/Dashboard%20Summary.png) — screenshot of the Summary page.
- [Dashboard Overview image](Image/Dashboard%20Overview.png) — screenshot of the Overview page.
- [Power BI report](Bank%20Loan%20Report%20Dashboard.pbix) — interactive Power BI dashboard file.

## Scope and Limitations

This is a descriptive analysis of the loan records available in the dataset. It summarizes portfolio size, status composition, recorded payment totals, and application patterns; it does not establish the causes of loan outcomes or predict future defaults. The incomplete December date coverage should be considered when interpreting monthly trends.
