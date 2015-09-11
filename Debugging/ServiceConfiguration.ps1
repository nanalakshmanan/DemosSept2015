configuration ServiceConfiguration
{
    Import-DscResource -ModuleName nPSDesiredStateConfiguration

    nService Wecsvc
    {
        Name        = 'Wecsvc'
        StartupType = 'Automatic'
        State       = 'Running'
    }
}