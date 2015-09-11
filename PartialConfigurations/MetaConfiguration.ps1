[DscLocalConfigurationManager()]
configuration MetaConfig
{   
    Settings
    {
        RefreshFrequencyMins = 60
        ActionAfterReboot    = 'StopConfiguration'
        DebugMode            = 'ForceModuleImport'
    }
}
