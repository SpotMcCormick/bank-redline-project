/*
Gold Layer view for analyst to use as a datamart.
*/

CREATE
    OR REPLACE VIEW mart_bank_redline AS WITH loan_amount AS(
        SELECT
            county_code,
            SUM(loan_amount) as loan_amount_by_county
        FROM
            stg_hmda_data
        GROUP BY
            county_code
    )
SELECT
    b.*,
    c.population as pop_by_county,
    c.median_income as median_income_by_county,
    l.loan_amount_by_county
FROM
    dim_banks b
    LEFT JOIN DIM_COUNTY_CESNUS_STATS c ON b.state = c.state
    AND b.county = c.county_name
    LEFT JOIN loan_amount l ON l.county_code = c.state_fips || c.county_fips;
select
    *
from
    mart_bank_redline