/*
COPY INTO command to copy data from the s3 bucket into the staged table
*/
COPY INTO stg_hmda_data (
    state_abbrev,
    county_code,
    derived_loan_product_type,
    derived_dwelling_category,
    derived_ethnicity,
    derived_race,
    derived_sex,
    loan_amount,
    source_filename
)
FROM (
    SELECT 
        $4 AS state_abbrev,
        $5 AS county_code,
        $8 AS derived_loan_product_type,
        $9 AS derived_dwelling_category,
        $10 AS derived_ethnicity,
        $11 AS derived_race,
        $12 AS derived_sex,
        $22 AS loan_amount,
        METADATA$FILENAME AS source_filename
    FROM @hmda_stage
)
FILE_FORMAT = (TYPE = 'CSV', SKIP_HEADER = 1, FIELD_OPTIONALLY_ENCLOSED_BY = '"');