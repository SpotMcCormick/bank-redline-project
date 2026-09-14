/*
Stored procedure that will taked our data in the stage area and copy it into our staging table. this will be run via snowflake task. 
*/

CREATE OR REPLACE PROCEDURE SE_BANK_DEV.BANK_REDLINE.LOAD_S3_STG_SE_BANKS()
RETURNS VARCHAR
LANGUAGE SQL
EXECUTE AS OWNER
AS '
BEGIN
  COPY INTO SE_BANK_DEV.BANK_REDLINE.STG_SE_BANKS
      (json, ingested_at, source_filename)
  FROM (
    SELECT
      $1 AS json,
      CURRENT_TIMESTAMP() AS ingested_at,
      METADATA$FILENAME AS source_filename --this is the file that is contained in the s3 bucket. ill use the for trouble shooting 
    FROM @SE_BANK_DEV.BANK_REDLINE.S3_FDIC_STAGE
  )
  FILE_FORMAT = (
    TYPE = ''JSON'',
    STRIP_OUTER_ARRAY = TRUE
  )
  ON_ERROR = ''CONTINUE''
  PURGE = FALSE;

  RETURN ''Copy operation successfully executed.'';
END;
';
