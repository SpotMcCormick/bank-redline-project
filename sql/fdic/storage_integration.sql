/*
Getting sotrage integration set up for the snowflake stages. I wanted to document this so i has something on record 
there was something weird with the wildcard "*" in setting up snowflake and aws permissions but i remembered snowflake doesnt like "*" .
Documentation below. Also i had to grant permisions to a read and write role. 

https://docs.snowflake.com/en/user-guide/data-load-s3-config-storage-integration
*/

CREATE STORAGE INTEGRATION s3_integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::<ACCOUNT_ID>:role/de_snf' --a place holder for the real arn
  STORAGE_ALLOWED_LOCATIONS = ('s3://bank-snowflake-project/');

l.

-- Grants needed for the working role to create stages and use the integration
GRANT CREATE STAGE ON SCHEMA bank_redline TO ROLE de_read_write;
GRANT USAGE ON INTEGRATION s3_integration TO ROLE de_read_write;
