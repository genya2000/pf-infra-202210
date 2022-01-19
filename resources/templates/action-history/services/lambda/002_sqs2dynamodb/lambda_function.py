import json
import os
import boto3
import time
import uuid
from boto3.dynamodb.conditions import Key
from botocore.exceptions import ClientError
import logging
 
logger = logging.getLogger()
logger.setLevel(logging.INFO)

queueName = os.environ['queueName']
dynamodbTableName = os.environ['dynamodbTableName']
sqs = boto3.resource("sqs")
dynamodb = boto3.resource("dynamodb")

def lambda_handler(event, context):
    queue = sqs.get_queue_by_name(QueueName=queueName)
    messages = queue.receive_messages(
        MaxNumberOfMessages = 10
    )
    
    entries = []
    for message in messages:
        entries.append({
            "Id": message.message_id,
            "ReceiptHandle": message.receipt_handle
        })
 
    table = dynamodb.Table(dynamodbTableName)
    with table.batch_writer() as batch:
        for item in event['Records']:
            item['CookieID'] = str(uuid.uuid4())
            item['Timestamp'] = int(time.time())
            batch.put_item(Item = item)

    response = {}
    if len(entries) != 0:
        response = queue.delete_messages(
            Entries = entries
    )
 
    logger.info(response)
    return response
