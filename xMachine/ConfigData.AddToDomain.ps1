$ScriptPath = Split-Path $MyInvocation.MyCommand.Path
. "$ScriptPath\..\0-CommonInit.ps1"

if ($Credential -eq $null)
{
    $Credential = Get-Credential Administrator -Message 'Enter domain admin credential'
}

@{
    AllNodes = @(
        @{
            NodeName                    = 'Nana-XM-Node'
            Role                        = 'Node'
            DomainName                  = 'NanaTestDomain'
            DomainAdminCredential       = (new-object System.Management.Automation.PSCredential 'NanaTestDomain\Administrator', $Credential.Password)
            DomainUser                  = 'NanaTestDomain\Nana'
            DomainController            = $DomainController
            DNSServer                   = $DNSServer
            # allow plain text passwords in a mof file is a security hole
            # it is being used here purely for the demo
            # Do not use this in any script in your environment
            PSDscAllowPlainTextPassword = $true
         }
    )
}