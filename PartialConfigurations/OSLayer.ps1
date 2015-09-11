Configuration OSLayer
{
    param(
            [string]
            $ComputerName
        )

    Import-DscResource -ModuleName PSDesiredStateConfiguration

    node $ComputerName
    {
        # Install the IIS role
        WindowsFeature IIS
        {
            Ensure          = "Present"
            Name            = "Web-Server"
        }

        # Install the ASP .NET 4.5 role
        WindowsFeature AspNet45
        {
            Ensure          = "Present"
            Name            = "Web-Asp-Net45"
        }
    }
}

