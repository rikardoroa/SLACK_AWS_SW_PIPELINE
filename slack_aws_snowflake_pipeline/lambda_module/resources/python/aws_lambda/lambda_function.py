import json
from slack_content import GetSlackFile


def lambda_handler(event, context):
    # getting the lambda event
    body = json.loads(event["body"])
    
    # validating slack api response
    if body.get('type') == 'url_verification':
        get_slack_data = GetSlackFile()
        # getting the file id from the api response
        file_id = body['event'].get('file_id')

       
        
        # validating if the file exists using the slack api response
        if file_id:
            get_slack_data.get_file_info(file_id)
            get_slack_data.get_file_url()
            

        return {
            "statusCode": 200,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"challenge": body.get("challenge")})
        }

        

    else:
        return {
            "statusCode": 400,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"error": "file_id is missing in the event"})
        }