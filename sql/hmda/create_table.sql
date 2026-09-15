/*
Table created to copy s3 HMDA data into a staged table
*/
CREATE OR REPLACE TABLE stg_hmda_data (
    state_abbrev VARCHAR(2),
    county_code VARCHAR(10),
    derived_loan_product_type VARCHAR(150),
    derived_dwelling_category VARCHAR(150),
    derived_ethnicity VARCHAR(150),
    derived_race VARCHAR(150),
    derived_sex VARCHAR(40),
    loan_amount FLOAT,
    source_filename VARCHAR(150),
    ingested_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);