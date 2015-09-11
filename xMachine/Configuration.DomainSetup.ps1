configuration DomainSetup
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration, xActiveDirectory

    node $AllNodes.Where{$_.Role -eq 'DomainController'}.Nodename
    {
        WindowsFeature ADDSInstall
        {
            Ensure = 'Present'
            Name   = 'AD-Domain-Services'
        }

        xADDomain DC
        {
            DomainName                    = $Node.DomainName
            DomainAdministratorCredential = $Node.DomainAdminCredential
            SafemodeAdministratorPassword = $Node.SafeModeAdminCredential
            DependsOn                     = '[WindowsFeature]ADDSInstall'
        }

        xWaitForADDomain WaitForDC
        {
            DomainName           = $Node.DomainName
            DomainUserCredential = $Node.DomainAdminCredential
            RetryCount           = 10
            RetryIntervalSec     = 100
            DependsOn            = '[xADDomain]DC'
        }

        xADUser FirstUser
        {
            DomainName                    = $Node.DomainName
            DomainAdministratorCredential = $Node.DomainAdminCredential
            UserName                      = $Node.AnotherAdminCredential.UserName
            Password                      = $Node.AnotherAdminCredential
            Ensure                        = 'Present'
            DependsOn                     = '[xWaitForADDomain]WaitForDC'
        }
    }
}