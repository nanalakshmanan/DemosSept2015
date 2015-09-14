[DscLocalConfigurationManager()]
configuration MetaConfiguration
{   
    param(
        [string]
        $ComputerName = 'localhost'
    )

    node $ComputerName
    {
        Settings
        {
            RefreshFrequencyMins = 60
            ActionAfterReboot    = 'StopConfiguration'
            DebugMode            = 'ForceModuleImport'
        }
    }
}
