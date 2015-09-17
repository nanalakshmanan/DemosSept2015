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

        PartialConfiguration AppLayer
        {
            Description = 'Web application deployment'
            ExclusiveResources = @('xWebAdministration\xWebsite')
            DependsOn  = "[PartialConfiguration]OSLayer"
        }
    }
}
