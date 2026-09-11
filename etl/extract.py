#extract.py

#standard
import logging

#third party
import requests

logger = logging.getLogger(__name__)

def extract_from_api_with_offset(url: str, params: dict = None) -> list:
    """
    Extract data from an API endpoint, handling offset-based pagination.

    Args:
        url (str): The API endpoint URL.
        params (dict, optional): Query parameters for the API request. Defaults to None.

    Returns:
        dict: The JSON response from the API.
    """
    try:
        all_records = []
        while True:
            response = requests.get(url, params=params)
            response.raise_for_status()
            data = response.json()

            records = data.get("data", [])
            all_records.extend(records)

            if len(records) < params["limit"]:
                break

            params["offset"] += params["limit"]

        logger.info(f"Successfully extracted data from API with {len(all_records)} rows.")
        return all_records
    except requests.exceptions.RequestException as e:
        logger.error(f"Error extracting data from API: {e}")
        raise