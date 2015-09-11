configuration AddToDomain
{
    Import-DscResource -ModuleName xActiveDirectory, xComputerManagement, xNetworking, PSDesiredStateConfiguration

    node $AllNodes.Where{$_.Role -eq 'Node'}.Nodename
    {
        xDNSServerAddress DNS
        {
            InterfaceAlias = 'Ethernet'
            Address        = $Node.DNSServer
            AddressFamily  =  'IPv4'
        }

        xComputer Computer
        {
            Name       = $Node.NodeName
            DomainName = $Node.DomainName
            Credential = $Node.DomainAdminCredential
            DependsOn  = '[xDNSServerAddress]DNS'
        }

        WaitForAll WaitForDomainUser
        {
            NodeName         = $Node.DomainController
            ResourceName     = '[xADUser]FirstUser'
            RetryIntervalSec = 10
            RetryCount       = 10
        }

        Group Administrators
        {
            GroupName = 'Administrators'
            Ensure = 'Present'
            Members = $Node.DomainUser 
            DependsOn = @('[xComputer]Computer', '[WaitForAll]WaitForDomainUser')
        }
    }

}