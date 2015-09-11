configuration ServiceConfigurationClasses
{
    Import-DscResource -ModuleName nServiceManager

    nService Wecsvc
    {
        Name        = 'Wecsvc'
        StartupType = 'Automatic'
        State       = 'Running'
    }
}