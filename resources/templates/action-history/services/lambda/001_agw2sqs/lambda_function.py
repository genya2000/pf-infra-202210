import json
import os
import datetime
import time
import boto3
import uuid

name = os.environ['queueName']
sqs = boto3.resource('sqs')
domain = '.switch-plus.jp'
expires = datetime.datetime.utcnow() + datetime.timedelta(days=365) # expires in 365 days
visitor_id = str(uuid.uuid4())
timestamp = int(time.time())

def lambda_handler(event, context):
    request = event['headers']
    queryStringParameters = event['queryStringParameters']
    # distributionId = event['Records'][0]['cf']['config']['distributionId']

    data = {
        # distributionId: distributionId,
        'CookieID': visitor_id,
        'Timestamp': int(time.time()),
        'queryStringParameters': queryStringParameters,
        'event': event
    }
    
    print(json.dumps(data) )
    print('SwitchPlusVID={}; Domain={}; expires={}; Path=/; SameSite=None; Secure'.format(visitor_id, domain, expires.strftime("%a, %d %b %Y %H:%M:%S GMT")))
    
    queue = sqs.get_queue_by_name(QueueName=name)
    # メッセージ×3をキューに送信
    response = queue.send_message(MessageBody=json.dumps(data))

    return {
        # multiValueH
        'statusCode': 200,
        "headers": {
            'Content-Type': 'image/gif',
            'Set-Cookie': 'SwitchPlusVID={}; Domain={}; expires={}; Path=/; SameSite=None; Secure'.format(visitor_id, domain, expires.strftime("%a, %d %b %Y %H:%M:%S GMT"))
        },
        "body": "R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7",
        "isBase64Encoded": True
    }
