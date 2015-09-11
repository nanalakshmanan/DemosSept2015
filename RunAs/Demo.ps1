$ScriptPath = Split-Path $MyInvocation.MyCommand.Path
. "$ScriptPath\..\0-CommonInit.ps1"

# Try to figure out the context in which DSC runs
# Thanks Lee Holmes for the script
psedit "$ScriptPath\Get-ProcessOwner.ps1"
psedit "$ScriptPath\ProcessOwner.ps1"

# compile and invoke the configuration
. "$ScriptPath\ProcessOwner.ps1"

ProcessOwner -OutputPath "$Outputpath\ProcessOwner"
Start-DscConfiguration -Path "$Outputpath\ProcessOwner" -Wait -Force -Verbose

# every resource now comes with an additional property
Get-DscResource -Name File -Syntax

# the PSDscRunAsCredential will take a credential and will run the resource
# in a process with that token
psedit "$ScriptPath\ProcessOwnerCredential.ps1"
. "$ScriptPath\ProcessOwnerCredential.ps1"

$ConfigData = (& "$ScriptPath\ProcessOwnerCredential.ConfigData.ps1")
ProcessOwnerCredential -OutputPath "$Outputpath\ProcessOwnerCredential" -ConfigurationData $ConfigData
Start-DscConfiguration -Path "$Outputpath\ProcessOwnerCredential" -Wait -Force -Verbose

