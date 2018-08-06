#Get parameters of what to block
param (
    $emailaddress = $null, #Email is optional, could specify domain.
    $id = $(throw "You must specify a group Id"),
    $domain = $null #Domain is optional, could specify email.
)

#Check to make sure parameters where supplied correctly
if ($emailaddress -ne $null -and $domain -ne $null) {
    Write-Output $(throw "Only an emailaddress or a domain can be specified, not both.")
}

#Setup required variables
$baseUrl = "https://us-api.mimecast.com"
$uri = "/api/directory/add-group-member"
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
                "Content-Type" = "application/json"
}
 
#Create post body (Diffrent depending on weather a domain or emailaddress is blocked.)
#Domain to block.
if ($domain -ne $null -and $emailaddress -eq $null){
    $postBody = "{
        ""data"": [
            {
                ""id"" : ""$id"",
                ""domain"" : ""$domain""
            }
        ]
    }"
}

#Emailaddress to block.
if ($domain -eq $null -and $emailaddress -ne $null){
    $postBody = "{
                        ""data"": [
                            {
                                ""id"" : ""$id"",
                                ""emailAddress"" : ""$emailAddress""
                            }
                        ]
                    }"
}

#Send Request
$response = Invoke-RestMethod -Method Post -Headers $headers -Body $postBody -Uri $url
	
#Print the response
Out-String -InputObject $response
