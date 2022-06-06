import json
import os
import datetime
import time
import boto3
import uuid
from datetime import timedelta
import urllib.parse as urlparse
from urllib.parse import urlencode


client = boto3.client('events')
eventSource = os.environ['eventSource']

def lambda_handler(event, context):
    print(event)
    url = event['queryStringParameters']['url']
    
    leadUuid = None
    clientKey = None
    # DetailTypeを動的にしたい場合の検討
    # if 'type' in event['queryStringParameters']:
    #    detailType = event['queryStringParameters']['type']
    if 'lid' in event['queryStringParameters']:
        leadUuid = event['queryStringParameters']['lid']
    # vidは不要
    # if 'vid' in event['queryStringParameters']:
    #    visitorUuid = event['queryStringParameters']['vid']
    if 'client_key' in event['queryStringParameters']:
        clientKey = event['queryStringParameters']['client_key']
        
    url_parts = list(urlparse.urlparse(url))
    query = dict(urlparse.parse_qsl(url_parts[4]))
    query.update({'spl': leadUuid})
    url_parts[4] = urlencode(query)
    print(urlparse.urlunparse(url_parts))

    if leadUuid and clientKey:
        # print(putItem)
        putItem = {}
        putItem['leadId'] = leadUuid
        putItem['ClientSubDomain'] = clientKey
        putItem['CookieID'] = 'null'
        putItem['parameter'] = url
        dt_now = datetime.datetime.now()
        putItem['firstTime'] = dt_now.strftime('%Y-%m-%d')
        putItem['UserAgent'] = 'null'
        putItem['refererUrl'] = 'null'
    
        putEventResponse = client.put_events(
            Entries=[
                {
                    # 'Time': '2022-01-14T01:02:03Z',
                    'Source': eventSource,
                    'DetailType': 'mail:click',
                    'Detail': json.dumps(putItem),
                },
            ]
        )


    response = {}
    response["statusCode"] = 302
    response["headers"] = {
        'Location': urlparse.urlunparse(url_parts),
    }
    return response

