$ScriptPath = Split-Path $MyInvocation.MyCommand.Path

if ($Credential -eq $null)
{
    $Credential = Get-Credential Administrator -Message 'Enter domain admin credential (will also be used as Safemode Admin Credentials)'
}

@{
    AllNodes = @(
        @{
            NodeName                    = 'Nana-XM-DC'
            Role                        = 'DomainController'
            DomainName                  = 'NanaTestDomain.com'
            DomainAdminCredential       = $Credential
            SafemodeAdminCredential     = $Credential
            AnotherAdminCredential      = (New-Object System.Management.Automation.PSCredential "Nana", $Credential.Password)
            # allow plain text passwords in a mof file is a security hole
            # it is being used here purely for the demo
            # Do not use this in any script in your environment
            PSDscAllowPlainTextPassword = $true
         }
    )
}