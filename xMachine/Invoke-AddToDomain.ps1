$ScriptPath = Split-Path $MyInvocation.MyCommand.Path
. "$ScriptPath\..\0-CommonInit.ps1"
$ConfigData = (& "$ScriptPath\ConfigData.AddToDomain.ps1")

. "$ScriptPath\Configuration.AddToDomain.ps1"

Remove-Item -Recurse -Force "$OutputPath\AddToDomain" 2> $null
AddToDomain -OutputPath "$OutputPath\AddToDomain" -ConfigurationData $ConfigData

Start-DscConfiguration -Wait -Force -Path "$OutputPath\AddToDomain" -Verbose -Credential $Credential

#Restart-Computer -Force -Wait -Protocol WSMan -ComputerName $DomainController -Verbose