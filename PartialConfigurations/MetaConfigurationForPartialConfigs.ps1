[DscLocalConfigurationManager()]
configuration MetaConfigForPartialConfigs
{   
    param(
        [string]
        $ComputerName
    )

    node $ComputerName
    {
        Settings
        {
            RefreshFrequencyMins = 60
        }

        PartialConfiguration OSLayer
        {
            Description = "Everything at the OS level"
            ExclusiveResources = @("xComputerManagement\xComputer")
        }

        PartialConfiguration Website
        {
            Description = 'Web application deployment'
            ExclusiveResources = @('xWebAdministrator\xWebsite')
            DependsOn  = "[PartialConfiguration]OSLayer"
        }
    }
}
