/*
falltens the stange data and well as split data into clean columns. i.e state and county. This works a little
differently that data:COLUMNNAME::STING because it has headers. the fdic data gets flattened out differently
*/

CREATE OR REPLACE TABLE dim_county_census_stats AS (
  SELECT
    INITCAP(TRIM(REPLACE(SPLIT_PART(value[0]::STRING, ',', 1), ' County', ''))) AS county_name,
    TRIM(SPLIT_PART(value[0]::STRING, ',', 2)) AS state,
    value[1]::NUMBER AS population,
    value[2]::NUMBER AS median_income,
    value[3]::STRING AS state_fips,
    value[4]::STRING AS county_fips
  FROM stg_se_county_data,
  LATERAL FLATTEN(input => json:data)
  WHERE index > 0
);
