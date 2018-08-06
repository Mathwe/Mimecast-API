#!/usr/bin/python

import base64
	
import hashlib
	
import hmac
	
import uuid
	
import datetime
	
import requests

import sys

import json

from optparse import OptionParser


#Process/Check supplied arguments

parser = OptionParser()
parser.add_option("-i", "--id", dest="group_id", default=None,
		help="Specify the mimecast group ID to add the member to.", metavar="ID")
parser.add_option("-a", "--email_address", dest="email_address", default=None,
		help="Specify the email address to add to the group, can only be used if domain is blank.", metavar="EMAIL")
parser.add_option("-d", "--domain", dest="domain", default=None,
		help="Specify a domain to add to group, can only be used if email is blank.", metavar="DOMAIN")
(options, args) = parser.parse_args()

if options.group_id is None:
	print('You must specify a group ID')
	exit()
if options.email_address is not None and options.domain is not None:
	print('You can only specify an email address or domain.  Not both')
	exit()
if options.email_address is None and options.domain is None:
	print('You must specify an email address or domain.')
	exit()

group_id = options.group_id

email_address = options.email_address

domain = options.domain

# Setup required variables
	
base_url = "https://us-api.mimecast.com"
	
uri = "/api/directory/add-group-member"
	
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
	
        'data': [
	
            {
	
                'id': group_id,
	
                'emailAddress': email_address,

		'domain' : domain
	
            }
	
        ]

    }

payload = json.dumps(payload)

r = requests.post(url=url, headers=headers, data=str(payload))

output_date = datetime.datetime.utcnow().strftime("%a, %d %b %Y %H:%M:%S") + " UTC"
output = "%s %r\n" %(hdr_date, r.text)
f = open ('/opt/logs/mimecast/addGroupMembers.log','a')
f.write(output)
f.close()

print r.text
