$appId = Read-Host -Prompt 'Input your registered application id:'
$creds = Get-Credential
$discoverPostBody = @{"data" = ,@{"emailAddress" = $creds.UserName}}
$discoverPostBodyJson = ConvertTo-Json $discoverPostBody
$discoverRequestId = [guid]::NewGuid().guid
$discoverRequestHeaders = @{"x-mc-app-id" = $appId; "x-mc-req-id" = $discoverRequestId; "Content-Type" = "application/json"}
$discoveryData = Invoke-RestMethod -Method Post -Headers $discoverRequestHeaders -Body $discoverPostBodyJson -Uri "https://api.mimecast.com/api/login/discover-authentication"
$baseUrl = $discoveryData.data.region.api
$keys = @{}
$uri = $baseUrl + "/api/login/login"
$requestId = [guid]::NewGuid().guid
$netCred = $creds.GetNetworkCredential()
$PlainPassword = $netCred.Password
$credsBytes = [System.Text.Encoding]::ASCII.GetBytes($creds.UserName + ":" + $PlainPassword)
$creds64 = [System.Convert]::ToBase64String($credsBytes)
$headers = @{"Authorization" = "Basic-Cloud " + $creds64; "x-mc-app-id" = "1f3287ec-4e7c-11e6-beb8-9e71128cae77"; "x-mc-req-id" = $requestId; "Content-Type" = "application/json"}
$postBody = @{"data" = ,@{"username" = $creds.UserName}}
$postBodyJson = ConvertTo-Json $postBody
$data = Invoke-RestMethod -Method Post -Headers $headers -Body $postBodyJson -Uri $uri
"Access key: " + $data.data.accessKey
"Secret key: " + $data.data.secretKey