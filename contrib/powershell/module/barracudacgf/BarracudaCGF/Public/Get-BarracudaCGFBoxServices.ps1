<#
.Synopsis
    Collects the names of the Services or if provided with a service name provides info on the service status
.Description
    This will return a list of Services running on the queried firewall under the Server provided or will return status information about specific service
.Example
	Get-BarracudaCGFBoxServices -deviceName <hostname or ip> -token <token> -ServerName S1
    Get-BarracudaCGFBoxServices -deviceName <hostname or ip> -token <token> -ServiceName "NGFW"
.Notes
v1.1 - updated for 8.0.1
#>
Function Get-BarracudaCGFBoxServices {
	    [cmdletbinding()]
param(
[Parameter(Mandatory=$true,ValueFromPipeline=$true)]
[string]$deviceName,
[Parameter(Mandatory=$false,ValueFromPipeline=$true)]
[string] $devicePort="8443",
[Parameter(Mandatory=$false,ValueFromPipeline=$true)]
[string]$ServiceName,
[Parameter(Mandatory=$true,ValueFromPipeline=$true)]
[string] $token,
[switch]$notHTTPs
)

    #makes the connection HTTPS
    if(!$notHTTPS){
        $s = "s"
    }

    #Sets the token header
    $header = @{"X-API-Token" = "$token"}
	
    if($PSBoundParameters.ContainsKey("Debug")){
    #Note - the function will return any values in the pipeline, so always use Write-Host 
        Write-Output $PSBoundParameters
    }
    try{
        $results = Invoke-WebRequest -Uri "http$($s)://$($deviceName):$($devicePort)/rest/control/v1/box/services/$($ServiceName)" -ContentType 'application/json' -Method Get -Headers $header -UseBasicParsing -SkipCertificateCheck
        if((ConvertFrom-Json $results.Content).services){
		    return (ConvertFrom-Json $results.Content).services
        }else{
            return ConvertFrom-Json $results.Content
        }
	}catch{
        Write-Output $_.Exception.Message
		Write-Output $PSBoundParameters
		Write-Output $url
	
    }

}
