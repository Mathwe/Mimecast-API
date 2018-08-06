#!/usr/bin/python

import base64
	
import hashlib
	
import hmac
	
import uuid
	
import datetime
	
import requests

from optparse import OptionParser
	
#Process/Check supplied arguments

parser = OptionParser()
parser.add_option("-q", "--query", dest="query", default=None,
		help="Specify the value to query groups on.", metavar="QUERY")
(options, args) = parser.parse_args()

if options.query is None:
    print ("You must supply a value to query groups on")
    exit()

query = options.query
	
# Setup required variables
	
base_url = "https://us-api.mimecast.com"
	
uri = "/api/directory/find-groups"
	
url = base_url + uri
	
access_key = "String"

secret_key = "String"

app_id = "String"

app_key = "String"
	
 
	
# Generate request header values
	
request_id = str(uuid.uuid4())
	
hdr_date = datetime.datetime.utcnow().strftime("%a, %d %b %Y %H:%M:%S") + " UTC"
	
 
	
# Create the HMAC SHA1 of the Base64 decoded secret key for the Authorization header
	
hmac_sha1 = hmac.new(secret_key.decode("base64"), ':'.join([hdr_date, request_id, uri, app_key]),
	
                  digestmod=hashlib.sha1).digest()
	
 
	
# Use the HMAC SHA1 value to sign the hdrDate + ":" requestId + ":" + URI + ":" + appkey
	
sig = base64.encodestring(hmac_sha1).rstrip()
	
 
	
# Create request headers
	
headers = {
	
    'Authorization': 'MC ' + access_key + ':' + sig,
	
    'x-mc-app-id': app_id,
	
    'x-mc-date': hdr_date,
	
    'x-mc-req-id': request_id,
	
    'Content-Type': 'application/json'
	
}
	
 
	
payload = {
	
        'meta': {
	
            'pagination': {
	
                'pageSize': 25
	
	
            }
	
        },
	
        'data': [
	
            {
	
                'query': query
	
            }
	
        ]
	
    }
	
 
	
r = requests.post(url=url, headers=headers, data=str(payload))
	
 
	
print r.text
