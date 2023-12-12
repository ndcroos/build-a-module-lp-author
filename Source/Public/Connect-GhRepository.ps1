function Connect-GhRepository
{
    <#
    .SYNOPSIS
    Connect to GitHub API 
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [securestring]$Token,

        [string]$ServerUrl = "https://api.github.com",

        [ValidateSet("2022-11-28")]
        [string]$ApiVersion = "2022-11-28"
    )
    
    $headers = @{
        "X-GitHub-Api-Version" = $ApiVersion
        "Authorization"        = "Bearer $($Token | ConvertFrom-SecureString -AsPlainText)"
    }
    
    $params = @{
        Uri     = $ServerUrl
        Headers = $headers
        Method  = "Get"
    }

    $result = Invoke-RestMethod @params 
    $currentUser = Invoke-RestMethod -Uri $result."current_user_url" -Headers $headers

    # Script scoped variable
    # Holds all authentication details required for connection
    # for the remaining functions in the module
    $Script:Connection = @{
        Headers    = $headers
        ApiVersion = $ApiVersion
        Server     = $ServerUrl
        Token      = $Token
    }

    Write-Verbose "Logged in as:[$($currentUser.login)]"
}