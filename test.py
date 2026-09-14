import os
import boto3
from dotenv import load_dotenv

load_dotenv()

access_key = os.getenv("aws_access_key_id")
secret_key = os.getenv("aws_secret_access_key")

print("ACCESS KEY:", repr(access_key))
print("ACCESS KEY LEN:", len(access_key or ""))
print("SECRET KEY LEN:", len(secret_key or ""))

s3 = boto3.client(
    "s3",
    aws_access_key_id=access_key,
    aws_secret_access_key=secret_key,
)

# Simplest possible authenticated call — no bucket-specific permissions needed
try:
    response = s3.list_buckets()
    print("SUCCESS. Buckets:", [b["Name"] for b in response["Buckets"]])
except Exception as e:
    print("FAILED:", e)