Configuration Features
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    node $AllNodes.Where{$_.Role -eq 'Node'}.Nodename
    {
        WindowsFeature IIS
        {
            Name = 'Web-Server'
            Ensure = 'Present'
        }
    }
}