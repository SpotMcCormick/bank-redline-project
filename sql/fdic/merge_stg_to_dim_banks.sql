/*
Stored procedure that will take the data in the staging table and merge it into the dim_banks. will be ran via snowflake task.
*/

CREATE OR REPLACE PROCEDURE SE_BANK_DEV.BANK_REDLINE.MERGE_STG_TO_DIM_BANKS()
RETURNS VARCHAR
LANGUAGE SQL
EXECUTE AS OWNER
AS '
BEGIN
  MERGE INTO dim_banks AS tgt
  USING (
    SELECT
      json:data:UNINUM::INT AS office_id,
      json:data:NAME::STRING AS branch_name,
      json:data:CERT::INT AS branch_id,
      json:data:OFFNAME::STRING AS office_name,
      json:data:ADDRESS::STRING AS address,
      json:data:CITY::STRING AS city,
      json:data:STNAME::STRING AS state,
      json:data:COUNTY::STRING AS county,
      LEFT(json:data:ZIP::STRING, 5) AS zip_code,
      json:data:LATITUDE::FLOAT AS lat,
      json:data:LONGITUDE::FLOAT AS lon,
      TO_DATE(json:data:RUNDATE::STRING, ''MM/DD/YYYY'') AS last_updated_from_fdic,
      ingested_at,
      source_filename
    FROM STG_SE_BANKS
    QUALIFY ROW_NUMBER() OVER (
      PARTITION BY json:data:UNINUM::INT
      ORDER BY ingested_at DESC
    ) = 1
  ) AS src

  ON tgt.office_id = src.office_id

  WHEN MATCHED THEN UPDATE SET
    tgt.branch_name = src.branch_name,
    tgt.branch_id = src.branch_id,
    tgt.office_name = src.office_name,
    tgt.address = src.address,
    tgt.city = src.city,
    tgt.state = src.state,
    tgt.county = src.county,
    tgt.zip_code = src.zip_code,
    tgt.lat = src.lat,
    tgt.lon = src.lon,
    tgt.last_updated_from_fdic = src.last_updated_from_fdic,
    tgt.ingested_at = src.ingested_at,
    tgt.source_filename = src.source_filename

  WHEN NOT MATCHED THEN INSERT (
    office_id,
    branch_name,
    branch_id,
    office_name,
    address,
    city,
    state,
    county,
    zip_code,
    lat,
    lon,
    last_updated_from_fdic,
    ingested_at,
    source_filename
  )

  VALUES (
    src.office_id,
    src.branch_name,
    src.branch_id,
    src.office_name,
    src.address,
    src.city,
    src.state,
    src.county,
    src.zip_code,
    src.lat,
    src.lon,
    src.last_updated_from_fdic,
    src.ingested_at,
    src.source_filename
  );

  TRUNCATE TABLE STG_SE_BANKS;

  RETURN ''Merge complete, staging truncated.'';
END;
';
