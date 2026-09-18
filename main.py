#main.py

#standard
import logging
import os
from datetime import date
from pathlib import Path
from datetime import datetime, timezone

#third party
import boto3
import yaml
from dotenv import load_dotenv

#local
from etl.extract import extract_from_api_with_offset
from etl.load import load_to_s3

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
    with open(CONFIG_PATH) as f:
        config = yaml.safe_load(f)

    api_key = os.getenv("fdic_api_key")

    s3_client = boto3.client(
        "s3",
        aws_access_key_id=os.getenv("aws_access_key_id"),
        aws_secret_access_key=os.getenv("aws_secret_access_key"),
    )

    fdic_config = config["api_paths"]
    params = {
        "filters": f"STALP:({' OR '.join(fdic_config['fdic_states'])})",
        "fields": fdic_config["fdic_fields"],
        "limit": fdic_config["fdic_limit"],
        "offset": 0,
        "api_key": api_key,
    }

    data = extract_from_api_with_offset(fdic_config["fdic_url"], params)
    today = datetime.now(timezone.utc).strftime("%Y%m%d_%H%M%S")
    object_name = f"raw/fdic/{today}.json"
    bucket_name = config["aws"]["s3_bucket_name"]


    load_to_s3(s3_client, data, bucket_name, object_name)

if __name__ == "__main__":
    main()