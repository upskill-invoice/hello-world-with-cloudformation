import json
import random
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):

    logger.info('Fetching user data')

    if random.random() >= 0.7:
        logger.warning('Example warning')

    obj = {}
    obj["id"] = 1
    obj["first_name"] = "Jan"
    obj["second_name"] = "Kowalski"
    return {
		'headers': {
            'content-type': 'application/json'
        },
		"statusCode": 200,
		"body": json.dumps(obj)
	}
