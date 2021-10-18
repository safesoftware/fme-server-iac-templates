import requests
import json
import urllib.parse


def lambda_handler(event, context):
    bucket = event['Records'][0]['s3']['bucket']['name']
    # S3 object keys are the filename, URL encoded. E.g. "red flower.jpg" becomes "red+flower.jpg"
    key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'], encoding='utf-8')

    final_url='http://3.98.238.217:8080/fmerest/v3/automations/workflows/c30eee92-88b5-4679-9c26-16ca9c94499d/09fda7be-8c8a-c6eb-b7a5-468c2c3a30fb/message'
    headers = {'content-type': 'application/json'}
    payload = {'Bucket': bucket, 'File': key}
    data=json.dumps(payload)
    try:
        response = requests.post(final_url, data=data, headers=headers)
        print("JSON payload", data)
        print("Response text",response.text)
        print("Response status", response.status_code, response.reason)
    except Exception as e:
        print(e)
        print("JSON payload", data)
        print("Response text",response.text)
        print("Response status", response.status_code, response.reason)
        print('Error getting object {} from bucket {}. Make sure they exist and your bucket is in the same region as this function.'.format(key, bucket))
        raise e