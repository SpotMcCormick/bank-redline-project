/*
 setting up external stage for census data. uses the same integration as the FDIC data
  For the full set up external staging visit  https://docs.snowflake.com/en/user-guide/data-load-s3-config-storage-integration
*/

CREATE STAGE census_stage
  URL = 's3://bank-snowflake-project/raw/census/'
  STORAGE_INTEGRATION = s3_integration
  FILE_FORMAT = (TYPE = 'JSON', STRIP_OUTER_ARRAY = TRUE);
