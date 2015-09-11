$ScriptPath = Split-Path $MyInvocation.MyCommand.Path
. "$ScriptPath\..\0-CommonInit.ps1"
$ConfigData = (& "$ScriptPath\ConfigData.DomainSetup.ps1")

. "$ScriptPath\MetaConfig.DomainSetup.ps1"

Remove-Item -Recurse -Force "$OutputPath\DCMetaConfig" 2> $null
DCMetaConfig -OutputPath "$OutputPath\DCMetaConfig" -ConfigurationData $ConfigData

Set-DscLocalConfigurationManager -Path "$OutputPath\DCMetaConfig" -Verbose -Credential $Credential