configuration Features
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    node localhost
    {
        WindowsFeature IIS
        {
            Name   = 'Web-Server'
            Ensure = 'Present'
        }
    }
}