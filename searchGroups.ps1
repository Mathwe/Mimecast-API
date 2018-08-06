#Get parameters of what to block
param (
    $query = $(throw "A string to query on is required")
)

#Setup required variables
$baseUrl = "https://us-api.mimecast.com"
$uri = "/api/directory/find-groups"
$url = $baseUrl + $uri
$accessKey = "String"
$secretKey = "String"
$appId = "String"
$appKey = "String"
	
#Generate request header values	
$hdrDate = (Get-Date).ToUniversalTime().ToString("ddd, dd MMM yyyy HH:mm:ss UTC")
$requestId = [guid]::NewGuid().guid
	
#Create the HMAC SHA1 of the Base64 decoded secret key for the Authorization header
$sha = New-Object System.Security.Cryptography.HMACSHA1
$sha.key = [Convert]::FromBase64String($secretKey)
$sig = $sha.ComputeHash([Text.Encoding]::UTF8.GetBytes($hdrDate + ":" + $requestId + ":" + $uri + ":" + $appKey))
$sig = [Convert]::ToBase64String($sig)
	
#Create Headers
$headers = @{"Authorization" = "MC " + $accessKey + ":" + $sig;
                "x-mc-date" = $hdrDate;
                "x-mc-app-id" = $appId;
                "x-mc-req-id" = $requestId;
                "Content-Type" = "application/json"}
 
#Create post body	
$postBody = "{
                    ""meta"": {
                        ""pagination"": {
                            ""pageSize"": 25
                        }
                    },
                    ""data"": [
                        {
                            ""query"": ""$query""
                        }
                    ]
                }"
	
#Send Request	
Invoke-RestMethod -Method Post -Headers $headers -Body $postBody -Uri $url | Write-Host -Verbose

#Print the response	
$response