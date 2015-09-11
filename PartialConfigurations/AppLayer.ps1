Configuration AppLayer
{
    param(
            [string]
            $ComputerName
        )

    # Import the module that defines custom resources
    Import-DscResource -Module xWebAdministration, PSDesiredStateConfiguration
        
    node $ComputerName
    {
        # Stop the default website
        xWebsite DefaultSite 
        {
            Ensure          = "Present"
            Name            = "Default Web Site"
            State           = "Stopped"
            PhysicalPath    = "C:\inetpub\wwwroot"
        }
        
        # Copy the website content
        File WebContent
        {
            Ensure          = "Present"
            SourcePath      = 'C:\Content\Nana\Content\BakeryWebsite'
            DestinationPath = 'C:\inetpub\FourthCoffee'
            Recurse         = $true
            Type            = "Directory"
        }       

        # Create the new Website
        xWebsite BakeryWebSite 
        {
            Ensure          = "Present"
            Name            = 'FourthCoffee'
            State           = "Started"
            PhysicalPath    = 'C:\inetpub\FourthCoffee'
            DependsOn       = "[File]WebContent"
        }
    }
}
