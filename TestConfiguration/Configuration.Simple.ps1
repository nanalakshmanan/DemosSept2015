configuration Simple
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    node $AllNodes.Where{$_.Role -eq 'Node'}.Nodename
    {
        File Helo
        {
            DestinationPath = 'C:\Temp\HeloWorld.txt'
            Contents        = 'Helo world'
        }
    }
}