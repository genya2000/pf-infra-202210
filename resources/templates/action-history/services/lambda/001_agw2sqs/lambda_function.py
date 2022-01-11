import json
import os
import boto3

#name = 'imedia-sample-lead-action-log'
name = os.environ['queueName']
sqs = boto3.resource('sqs')

def lambda_handler(event, context):
    queue = sqs.get_queue_by_name(QueueName=name)
    # メッセージ×3をキューに送信
    response = queue.send_message(MessageBody=json.dumps(event))

    return {
        'statusCode': 200,
        "headers": {
            'Content-Type': 'image/gif'
        },
        "body": "R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7",
        "isBase64Encoded": True
    }
