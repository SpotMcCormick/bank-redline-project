# Welcome to the Bank Redline Project
Thank you for checking out my github and this project. This project was inspired by using Snowflake at work and I wanted to get my hands dirty with some data engineering with Snowflake. 

## About the project
I really wanted to find out if there is any redlining from banks in the south east using FDIC and Census data. I am still researching the other data sources because to really find out if redlining is happening is to get loan counts and amounts to incorporate with this analysis. That being said im still looking at other data sources so this is an on going project.  

### Tools 
One reason i like answering these questions is that it is an opportunity to learn new tools of the trade for data engineering and analytics. The tools used for this is  
- Python
- Amazon S3
- Snowflake (External Storage Integrations, Stored Procedures, Tasks)
- Github Actions
- Tableau 

### Architecture 
```mermaid
graph LR
    %% Data Sources
    subgraph Sources ["Data Sources (Extract)"]
        FDIC[FDIC API]
        CENSUS[CENSUS API]
    end

    %% Load
    subgraph Storage ["Loaded"]
        S3[AWS S3]
    end

    %% snf loaded
    subgraph stg_snf ["Loaded"]
        snf["Snowflake Staging"]
    end

    %% snf transform
    subgraph snf_transfrom ["Transform"]
        transform["Snowflake Transform"]
    end

       %% snf_gold
    subgraph snf_gold["Gold View"]
        gold["Create Gold View"]
    end


    %% Data Flow Pipeline
    FDIC -->|Extraction | S3
    CENSUS -->|Extraction| S3
    S3 -->|external storage integration|snf
    snf -->|Copy Into| transform
    transform -->|Create View As| gold   

```
Data is ingest via a python scrpit that pulls and loads into an Amazon S3 Bucket. From there Snowflake's external storage integration is configured to read the S3 bucket and ingested into the staging area. From there those files are copied into a staging table then merged into a dimension table. The raw data is scheduled via GitHub Actions and then once it lands into the S3 bucket then Snowflake stored procedures and tasks to ingest the data into the dimension tables. From there a view is created for our gold/analytics layer

### Deliverable 
[Tableau Dashboard](https://public.tableau.com/app/profile/jeremy.mccormick/viz/bank_redline/Dashboard1#1)

### Project Directory
```
├── config.yml <- containing API's, query params, AWS buckets 
├── data <- folder for raw data exports
├── etl <-scripts for extracting from api and loading to s3
│   ├── extract.py
│   └── load.py
├── main.py <- run etl (technically EL)
├── README.md <- this file
├── requirements.txt <-dependencies for this file
├── sql <- sql queries for the transforming the loaded data
│   ├── census
│   │   ├── census_stage.sql
│   │   ├── dim_county_census_stats.sql
│   │   └── stg_county_data.sql
│   ├── fdic
│   │   ├── create_stage.sql
│   │   ├── load_s3_stg_se_banks.sql
│   │   ├── merge_stg_to_dim_banks.sql
│   │   ├── storage_integration.sql
│   │   └── tasks.sql
│   ├── gold
│   │   └── mart_bank_redline.sql
│   └── hmda
│       └── create_stage.sql
└── static_main.py <- static data used for uploading to s3
```

## Contact

**Jeremy McCormick** — Data Engineer  
JeremyAlanMcCormick@gmail.com  

- [LinkedIn](https://www.linkedin.com/in/jeremyalanmccormick/)
- [GitHub](https://github.com/SpotMcCormick)