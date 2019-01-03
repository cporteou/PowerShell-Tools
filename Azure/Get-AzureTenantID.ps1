<#
.SYNOPSIS
Retrieve a domain's Azure tenant ID anonymously

.DESCRIPTION
This function will anonymously retrieve a domain's Azure tenant ID using a provided email containing the target domain or a domain itself.

.PARAMETER Domain
The full domain of the Azure tenant.

.PARAMETER Email
An email or user account that contains the domain of the Azure tenant

.EXAMPLE
Get-AzureTenantID -Domain craigporteous.com

Get-AzureTenantID -Email craig@craigporteous.com

.NOTES
General notes
#>

function Get-AzureTenantId{

    [CmdletBinding()]
    param
    (
        [ValidateScript({$_ -notmatch "@"})]
        [string]
        $domain,

        [ValidateScript({$_ -match "@"})]
        [string]
        $email
    )

    Process{
        if($domain){
            Write-Verbose 'Domain provided.'
        }
        elseif ($email) {
            Write-Verbose 'Split the string on the username to get the Domain.'
            $domain = $email.Split("@")[1]
        }
        else{
            throw
            Write-Warning 'You must provide a valid Domain or User email to proceed.'
        }

        Write-Verbose 'Query Azure anonymously.'
        $tenantId = (Invoke-WebRequest -UseBasicParsing https://login.windows.net/$($Domain)/.well-known/openid-configuration|ConvertFrom-Json).token_endpoint.Split('/')[3]

        return $tenantId
    }

}