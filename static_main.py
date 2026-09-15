#static_main.py

#standard
import logging
import os
from pathlib import Path
from datetime import datetime, timezone

#third party
import boto3
import yaml
from dotenv import load_dotenv

#local
from etl.extract import extract_from_api, extract_from_api_csv
from etl.load import load_to_s3, load_to_s3_csv

logger = logging.getLogger(__name__)
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s"
)

BASE_DIR = Path(__file__).resolve().parent
CONFIG_PATH = BASE_DIR / "config.yml"
ENV_PATH = BASE_DIR / ".env"

load_dotenv(ENV_PATH)

def main():
    """
    Main function to extract Census and HMDA data (annually updated sources)
    and load them into an S3 bucket.
    """
    try:
        logger.info("Starting the static ETL process.")
        with open(CONFIG_PATH) as f:
            config = yaml.safe_load(f)

        census_api_key = os.getenv("census_api_key")

        s3_client = boto3.client(
            "s3",
            aws_access_key_id=os.getenv("aws_access_key_id"),
            aws_secret_access_key=os.getenv("aws_secret_access_key"),
        )

        api_config = config["api_paths"]
        bucket_name = config["aws"]["s3_bucket_name"]
        today = datetime.now(timezone.utc).strftime("%Y%m%d_%H%M%S")

        # Census extraction and loading
        census_params = {
            "get": api_config["census_variables"],
            "for": api_config["census_for"],
            "in": f"state:{','.join(api_config['census_states'].keys())}",
            "key": census_api_key,
        }
        logger.info(f"Extracting data from Census API")

        census_data = extract_from_api(api_config["census_url"], census_params)
        census_object_name = f"raw/census/{today}.json"

        logger.info(f"Loading data to S3 bucket '{bucket_name}' with object name '{census_object_name}'")
        load_to_s3(s3_client, census_data, bucket_name, census_object_name)

        # HMDA extraction and loading
        hmda_params = {
            "states": api_config["hmda_states"],
            "years": api_config["hmda_years"],
            "loan_purposes": api_config["hmda_loan_purposes"],
        }
        logger.info(f"Extracting data from HMDA API")

        hmda_data = extract_from_api_csv(api_config["hmda_url"], hmda_params)
        hmda_object_name = f"raw/hmda/{today}.csv"

        logger.info(f"Loading data to S3 bucket '{bucket_name}' with object name '{hmda_object_name}'")
        load_to_s3_csv(s3_client, hmda_data, bucket_name, hmda_object_name)

        logger.info("Static ETL process completed successfully.")
    except Exception as e:
        logger.error(f"Static ETL process failed: {e}")
        raise

if __name__ == "__main__":
    main()