/*
Setting up a staging area for the FDIC data. with will use your external torage interation that we just up in the storage_integration.sql file.
*/

CREATE STAGE s3_fdic_stage
  STORAGE_INTEGRATION = S3_INTEGRATION
  URL = 's3://bank-snowflake-project/raw/fdic/'
  --strip outter array is set to true because the what it doesn it puts the json in array into an individual record rather than dumping the whole json into one record.
  FILE_FORMAT = (TYPE = 'JSON', STRIP_OUTER_ARRAY = TRUE);


