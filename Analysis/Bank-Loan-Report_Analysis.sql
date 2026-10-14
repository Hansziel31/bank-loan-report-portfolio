-- BANK LOAN REPORT ANALYSIS
-- Tools: PostgreSQL / DBeaver
-- Table: public.financialloandata
-- This script summarizes loan applications, loan status,
-- monthly patterns, and loan characteristics.
-- Run one query section at a time.


-- 1. DATA OVERVIEW

SELECT *
FROM public.financialloandata
LIMIT 10;


-- Check total rows and unique loan IDs
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT id) AS unique_loan_ids,
    COUNT(*) - COUNT(DISTINCT id) AS duplicate_id_count
FROM public.financialloandata;


-- Check date range. Supports issue_date stored as
-- MM/DD/YYYY text or as a date.
WITH parsed_data AS (
    SELECT
        CASE
            WHEN NULLIF(BTRIM(issue_date::text), '') IS NULL
                THEN NULL
            WHEN BTRIM(issue_date::text)
                 ~ '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
                THEN TO_DATE(
                    BTRIM(issue_date::text),
                    'MM/DD/YYYY'
                )
            WHEN BTRIM(issue_date::text)
                 ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
                THEN BTRIM(issue_date::text)::date
            ELSE NULL
        END AS issue_date_parsed
    FROM public.financialloandata
)
SELECT
    MIN(issue_date_parsed) AS earliest_issue_date,
    MAX(issue_date_parsed) AS latest_issue_date,
    COUNT(*) FILTER (
        WHERE issue_date_parsed IS NULL
    ) AS missing_or_unparsed_date
FROM parsed_data;


-- Check missing values in key columns
SELECT
    COUNT(*) FILTER (
        WHERE emp_title IS NULL OR BTRIM(emp_title) = ''
    ) AS missing_emp_title,

    COUNT(*) FILTER (
        WHERE emp_length IS NULL OR BTRIM(emp_length) = ''
    ) AS missing_emp_length,

    COUNT(*) FILTER (
        WHERE loan_status IS NULL OR BTRIM(loan_status) = ''
    ) AS missing_loan_status,

    COUNT(*) FILTER (
        WHERE loan_amount IS NULL
    ) AS missing_loan_amount,

    COUNT(*) FILTER (
        WHERE total_payment IS NULL
    ) AS missing_total_payment
FROM public.financialloandata;


-- 2. MAIN KPIs

SELECT
    COUNT(*) AS total_loan_applications,
    SUM(loan_amount) AS total_funded_amount,
    SUM(total_payment) AS total_amount_received_recorded,
    ROUND(
        (AVG(int_rate) * 100)::numeric,
        3
    ) AS average_interest_rate_pct,
    ROUND(
        (AVG(dti) * 100)::numeric,
        3
    ) AS average_dti_pct
FROM public.financialloandata;


-- 3. LOAN STATUS SUMMARY

SELECT
    loan_status,
    COUNT(*) AS total_applications,
    SUM(loan_amount) AS total_loan_amount,
    SUM(total_payment) AS total_payment_recorded,
    ROUND(
        (AVG(int_rate) * 100)::numeric,
        3
    ) AS average_interest_rate_pct,
    ROUND(
        (AVG(dti) * 100)::numeric,
        3
    ) AS average_dti_pct
FROM public.financialloandata
GROUP BY loan_status
ORDER BY total_applications DESC;


-- 3.1 Good Loan: Fully Paid + Current
-- As defined in the project brief
SELECT
    COUNT(*) FILTER (
        WHERE loan_status IN ('Fully Paid', 'Current')
    ) AS good_loan_applications,

    ROUND(
        (
            100.0 * COUNT(*) FILTER (
                WHERE loan_status IN ('Fully Paid', 'Current')
            ) / NULLIF(COUNT(*), 0)
        )::numeric,
        3
    ) AS good_loan_percentage,

    SUM(loan_amount) FILTER (
        WHERE loan_status IN ('Fully Paid', 'Current')
    ) AS good_loan_funded_amount,

    SUM(total_payment) FILTER (
        WHERE loan_status IN ('Fully Paid', 'Current')
    ) AS good_loan_payment_recorded
FROM public.financialloandata;


-- 3.2 Bad Loan: Charged Off
-- As defined in the project brief
SELECT
    COUNT(*) FILTER (
        WHERE loan_status = 'Charged Off'
    ) AS bad_loan_applications,

    ROUND(
        (
            100.0 * COUNT(*) FILTER (
                WHERE loan_status = 'Charged Off'
            ) / NULLIF(COUNT(*), 0)
        )::numeric,
        3
    ) AS bad_loan_percentage,

    SUM(loan_amount) FILTER (
        WHERE loan_status = 'Charged Off'
    ) AS bad_loan_funded_amount,

    SUM(total_payment) FILTER (
        WHERE loan_status = 'Charged Off'
    ) AS bad_loan_payment_recorded
FROM public.financialloandata;


-- 4. APPLICATIONS BY MONTH AND MONTH-OVER-MONTH CHANGE
-- Data ends on 12 December 2021.
-- Verify date coverage before comparing partial months
-- with full months.

WITH parsed_data AS (
    SELECT
        loan_amount,
        total_payment,
        int_rate,
        dti,
        CASE
            WHEN NULLIF(BTRIM(issue_date::text), '') IS NULL
                THEN NULL
            WHEN BTRIM(issue_date::text)
                 ~ '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
                THEN TO_DATE(
                    BTRIM(issue_date::text),
                    'MM/DD/YYYY'
                )
            WHEN BTRIM(issue_date::text)
                 ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
                THEN BTRIM(issue_date::text)::date
            ELSE NULL
        END AS issue_date_parsed
    FROM public.financialloandata
),
monthly AS (
    SELECT
        DATE_TRUNC(
            'month',
            issue_date_parsed
        )::date AS month_start,

        COUNT(*) AS applications,
        SUM(loan_amount) AS funded_amount,
        SUM(total_payment) AS payment_recorded,
        AVG(int_rate) * 100 AS avg_interest_pct,
        AVG(dti) * 100 AS avg_dti_pct
    FROM parsed_data
    WHERE issue_date_parsed IS NOT NULL
    GROUP BY DATE_TRUNC(
        'month',
        issue_date_parsed
    )::date
),
lagged AS (
    SELECT
        monthly.*,

        LAG(applications)
            OVER (ORDER BY month_start)
            AS prev_applications,

        LAG(funded_amount)
            OVER (ORDER BY month_start)
            AS prev_funded_amount,

        LAG(payment_recorded)
            OVER (ORDER BY month_start)
            AS prev_payment_recorded
    FROM monthly
)
SELECT
    month_start,
    TO_CHAR(month_start, 'FMMonth') AS month_name,
    applications,
    funded_amount,
    payment_recorded,

    ROUND(
        (
            100.0 * (applications - prev_applications)
            / NULLIF(prev_applications, 0)
        )::numeric,
        2
    ) AS applications_mom_pct,

    ROUND(
        (
            100.0 * (funded_amount - prev_funded_amount)
            / NULLIF(prev_funded_amount, 0)
        )::numeric,
        2
    ) AS funded_amount_mom_pct,

    ROUND(
        (
            100.0 * (payment_recorded - prev_payment_recorded)
            / NULLIF(prev_payment_recorded, 0)
        )::numeric,
        2
    ) AS payment_recorded_mom_pct,

    ROUND(avg_interest_pct::numeric, 3)
        AS average_interest_rate_pct,

    ROUND(avg_dti_pct::numeric, 3)
        AS average_dti_pct
FROM lagged
ORDER BY month_start;


-- 5. LOAN CHARACTERISTICS


-- 5.1 Applications by state
SELECT
    address_state,
    COUNT(*) AS applications,
    SUM(loan_amount) AS loan_amount,
    SUM(total_payment) AS payment_recorded
FROM public.financialloandata
GROUP BY address_state
ORDER BY applications DESC;


-- 5.2 Applications by loan term
SELECT
    BTRIM(term) AS loan_term,
    COUNT(*) AS applications,
    SUM(loan_amount) AS loan_amount,
    SUM(total_payment) AS payment_recorded
FROM public.financialloandata
GROUP BY BTRIM(term)
ORDER BY applications DESC;


-- 5.3 Applications by employment length
SELECT
    emp_length,
    COUNT(*) AS applications,
    SUM(loan_amount) AS loan_amount,
    SUM(total_payment) AS payment_recorded
FROM public.financialloandata
GROUP BY emp_length
ORDER BY emp_length;


-- 5.4 Applications by loan purpose
SELECT
    purpose,
    COUNT(*) AS applications,
    SUM(loan_amount) AS loan_amount,
    SUM(total_payment) AS payment_recorded
FROM public.financialloandata
GROUP BY purpose
ORDER BY applications DESC;


-- 5.5 Applications by home ownership
SELECT
    home_ownership,
    COUNT(*) AS applications,
    SUM(loan_amount) AS loan_amount,
    SUM(total_payment) AS payment_recorded
FROM public.financialloandata
GROUP BY home_ownership
ORDER BY applications DESC;





