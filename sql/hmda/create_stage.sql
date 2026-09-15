/*
Created stage for HMDA loan data for snowflake to read in from s3 bucket
*/
CREATE STAGE hmda_stage
  URL = 's3://bank-snowflake-project/raw/hmda/'
  STORAGE_INTEGRATION = s3_integration
  FILE_FORMAT = (
    TYPE = 'CSV'
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  )