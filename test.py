# import yfinance as yf

# data = yf.download("AAPL", period="3y", interval="1h")   
# print(data.head())
# ==============================================

# import pandas as pd
# import requests
# from dotenv import load_dotenv
# import os

# # Load environment variables
# load_dotenv()

# # Query FDIC API directly for Trustmark National Bank (Cert #4988)
# url = "https://banks.data.fdic.gov/api/locations"
# params = {
#     "filters": "CERT:4988 AND STALP:*",
#     "fields": "NAME,OFFNAME,ADDRESS,CITY,STNAME,COUNTY,ZIP,LATITUDE,LONGITUDE",
#     "limit": 1000,
#     "format": "json",
#     "api_key": os.getenv('API_KEY') }

# response = requests.get(url, params=params)
# data = response.json()
# print(data)
# =================================================

# # Flatten payload into a DataFrame
# df = pd.DataFrame([item["data"] for item in data])

# # Clean up column names and data types
# df = df.rename(
#     columns={
#         "NAME": "bank_name",
#         "OFFNAME": "branch_name",
#         "ADDRESS": "address",
#         "CITY": "city",
#         "STNAME": "state",
#         "COUNTY": "county",
#         "ZIP": "zip_code",
#         "LATITUDE": "latitude",
#         "LONGITUDE": "longitude",
#     }
# )

# df["latitude"] = pd.to_numeric(df["latitude"])
# df["longitude"] = pd.to_numeric(df["longitude"])

# # Preview the data
# print(df['branch_name'].value_counts().sum())
# print(df.head())
# df.to_csv("data/trustmark_branches.csv", index=False)

# ==========================================
import os
import requests
import pandas as pd
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()
API_KEY = os.getenv("cenus_api_key")

if not API_KEY:
    raise ValueError("CENSUS_API_KEY not found in .env file.")

BASE_URL = "https://api.census.gov/data/2022/acs/acs5/profile"

# Variables: Geography Name, Total Population, Median Household Income
VARIABLES = "NAME,DP05_0001E,DP03_0062E"

# State FIPS codes for strictly Southeastern states
SOUTHEAST_FIPS = {
    "01": "Alabama",
    "12": "Florida",
    "13": "Georgia",
    "22": "Louisiana",
    "28": "Mississippi",
    "37": "North Carolina",
    "45": "South Carolina",
    "47": "Tennessee"
}

all_records = []

for fips, state_name in SOUTHEAST_FIPS.items():
    params = {
        "get": VARIABLES,
        "for": "county:*",
        "in": f"state:{fips}",
        "key": API_KEY
    }
    
    response = requests.get(BASE_URL, params=params)
    
    if response.status_code == 200:
        data = response.json()
        print(data)