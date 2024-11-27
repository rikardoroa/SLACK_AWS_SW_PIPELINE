import json
from slack_content import GetSlackFile

def lambda_handler(event, context):
    
    # sending a responde per event to slack api
    return {
            "statusCode": 200,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"challenge": body.get("challenge")})
        }

    # getting the lambda event
    body = json.loads(event["body"])
    
    # validating slack api response
    if body.get('type') == 'url_verification':
        get_slack_data = GetSlackFile()
        # getting the event data safely
        event_data = body.get('event', {})
        
        # getting the file id from the event
        file_id = event_data.get('file_id')
        
        # validating if the file exists using the slack api response
        if file_id:
            get_slack_data.get_file_info(file_id)
            get_slack_data.get_file_url()
        
        

    else:
        return {
            "statusCode": 400,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"error": "file_id is missing in the event"})
        }


