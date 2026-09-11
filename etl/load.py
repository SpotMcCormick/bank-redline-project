#load.py

#standard
import logging
import os
import json
from typing import Any

#third party
from dotenv import load_dotenv
import botocore.exceptions

logger = logging.getLogger(__name__)

#loading in environment variables from .env file
load_dotenv()

def load_to_s3(s3_client: Any, data: dict | list, bucket_name: str, object_name: str) -> None:
    """
    Load data to an S3 bucket.

    Args:
        s3_client: The S3 client.
        data (dict | list): The data to be loaded.
        bucket_name (str): The name of the S3 bucket.
        object_name (str): The name of the object in the S3 bucket.

    """
    try:
        #we are going to create the authentication in the main.py
        s3_client.put_object(Bucket=bucket_name, Key=object_name, Body=json.dumps(data))
        logger.info(f"Successfully loaded data to S3 bucket '{bucket_name}' with object name '{object_name}'.")
    except botocore.exceptions.ClientError as e:
        error_code = e.response['Error']['Code']
        logger.error(f"S3 error ({error_code}): {e}")
        raise