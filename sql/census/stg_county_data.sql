/*
Creating a staging table for census county data to land in. Since this updates at a very long candence by the years i will run this mannually. 
*/

CREATE TABLE stg_se_county_data (
  load_id INTEGER AUTOINCREMENT,
  json VARIANT,
  source_filename STRING,
  ingested_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

/*
  this will be ran manually with the extract.py. data has infrequent updates 
*/

COPY INTO stg_se_county_data (json, source_filename)
FROM (
    SELECT
        $1,
        METADATA$FILENAME
    FROM @se_bank_dev.bank_redline.census_stage
)
FILE_FORMAT = (TYPE = 'JSON', STRIP_OUTER_ARRAY = TRUE);
