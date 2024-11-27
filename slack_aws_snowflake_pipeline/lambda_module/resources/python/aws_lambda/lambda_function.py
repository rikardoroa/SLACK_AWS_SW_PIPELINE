import json
from slack_content import GetSlackFile
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def lambda_handler(event, context):
    # getting the lambda event
    body = json.loads(event["body"])
    logger.info(f"este es el body:{body}")
    # Handle Slack URL verification
    if body.get('type') == 'url_verification':
        return {
            "statusCode": 200,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"challenge": body.get("challenge")})
        }

    # Handle other events here
    get_slack_data = GetSlackFile()
    # getting the the file_id
    file_id = body['event'].get('file_id')
   
    logger.info(f"este es el file id:{file_id}")
    # validating if the file exists using the slack api response
    if file_id:
        get_slack_data.get_file_info(file_id)
        get_slack_data.get_file_url()
        return {
            "statusCode": 200,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"message": "File processing initiated"})
        }
    else:
        return {
            "statusCode": 400,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"error": "file_id is missing in the event"})
        }


