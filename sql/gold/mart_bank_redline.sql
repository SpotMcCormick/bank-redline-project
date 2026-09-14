/*
Gold Layer view for analyst to use as a datamart.
*/

CREATE OR REPLACE VIEW mart_bank_redline AS
SELECT *
FROM dim_banks b
LEFT JOIN dim_county_census_stats c
  ON b.state = c.state
  AND b.county = c.county_name;
