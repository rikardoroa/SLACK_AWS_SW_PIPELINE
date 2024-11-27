from slack_sdk import WebClient
import requests
import pandas as pd
import os
from dotenv import load_dotenv
import boto3
from io import BytesIO
import uuid
import logging

load_dotenv()
slack_token = os.getenv("SLACK_TOKEN")
s3_bucket_name = os.getenv("BUCKET")

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class GetSlackFile:

    def __init__(self):
        # setting attributes and objects
        self.bucket = s3_bucket_name
        self.token = slack_token
        self.file_info = {}
        self.client = boto3.client('s3')
        self.file_id = str

    def get_file_info(self, file_id):
        # getting the file id from slack api (event)
        self.file_id = file_id
        return self.file_id

    def get_api_call(self):
        # getting the response using the file id
        client = WebClient(token=self.token)
        response = client.files_info(file=self.file_id)
        self.file_info = response.get('file')
        yield self.file_info

    def get_file_url(self):
        try:
            # getting the content from the response using the slack api token
            for file_info in self.get_api_call():
                url = file_info.get('url_private_download')
                headers = {"Authorization": f"Bearer {self.token}"}
                response = requests.get(url, headers=headers, stream=True)
                if response.status_code == 200:
                    buffer = BytesIO(response.content)
                    if url.split("/")[-1].endswith('.csv'):

                        # for transformations you can add logic here
                        # additional logic
                        file_name = "".join(['lmi_data_', str(uuid.uuid4()), '.csv'])
                        self.client.put_object(Bucket=self.bucket, Key=file_name, Body=buffer.getvalue())
                else:
                    logger.info("please review the process, the file can not be ingested in the s3 bucket")
        except Exception as e:
            logger.info(f"please review the process,an error occurred:{e}")