$ScriptPath = Split-Path $MyInvocation.MyCommand.Path
. "$ScriptPath\..\0-CommonInit.ps1"
$ConfigData = (& "$ScriptPath\ConfigData.DomainSetup.ps1")

. "$ScriptPath\Configuration.DomainSetup.ps1"

Remove-Item -Recurse -Force "$OutputPath\DomainSetup" 2> $null
DomainSetup -OutputPath "$OutputPath\DomainSetup" -ConfigurationData $ConfigData

. "$ScriptPath\Assert-MetaConfig.ps1"

Start-DscConfiguration -Wait -Force -Path "$OutputPath\DomainSetup" -Verbose -Credential $Credential

# restart VM
#Restart-Computer -Force -Wait -Protocol WSMan -ComputerName $DomainController -Verbose

Start-DscConfiguration -Wait -Force -ComputerName $DomainController -Credential $Credential -UseExisting -Verbose

