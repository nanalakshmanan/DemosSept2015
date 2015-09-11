[DscLocalConfigurationManager()]
configuration DCMetaConfig
{
    node $AllNodes.Where{$_.Role -eq 'DomainController'}.Nodename
    {
        Settings
        {
            ActionAfterReboot = 'StopConfiguration'
        }
    }
}