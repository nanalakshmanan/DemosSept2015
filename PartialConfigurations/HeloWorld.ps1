configuration HeloWorld
{
    param(
        [string]
        $ComputerName
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration

    node $ComputerName
    {
        File f
        {
            Contents        = 'Helo World'
            DestinationPath = 'c:\temp\heloworld.txt'        
        }
    }    
}