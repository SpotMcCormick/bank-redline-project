/*
running batch load every friday at 1pm central time. each tasks is running a the stored procedure that we created.
If you look at the second tasks, the AFTER clause will run as soon as the first task is done.

NOTE: after creating the tasks, you need to run these commands to resume them:

    ALTER TASK SE_BANK_DEV.BANK_REDLINE.MERGE_STG_TO_DIM_BANKS_TASK RESUME;
    ALTER TASK SE_BANK_DEV.BANK_REDLINE.LOAD_S3_STG_SE_BANKS_TASK RESUME;
*/

CREATE OR REPLACE TASK SE_BANK_DEV.BANK_REDLINE.LOAD_S3_STG_SE_BANKS_TASK
  WAREHOUSE = DEV_WH
  SCHEDULE = 'USING CRON 0 13 * * 5 America/Chicago'
  AS
    CALL SE_BANK_DEV.BANK_REDLINE.LOAD_S3_STG_SE_BANKS();

-- ==================================
CREATE OR REPLACE TASK SE_BANK_DEV.BANK_REDLINE.MERGE_STG_TO_DIM_BANKS_TASK
  WAREHOUSE = DEV_WH
  AFTER SE_BANK_DEV.BANK_REDLINE.LOAD_S3_STG_SE_BANKS_TASK
  AS
    CALL SE_BANK_DEV.BANK_REDLINE.MERGE_STG_TO_DIM_BANKS();