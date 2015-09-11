#region Declarations

$ScriptPath = Split-Path $MyInvocation.MyCommand.Path
. "$ScriptPath\..\0-CommonInit.ps1"

#endregion Declarations

# In PowerShell 5.0, there is a new syntax for partial configurations
psedit "$ScriptPath\MetaConfiguration.ps1"

# for partial configurations, meta configuration must first declare the individual 
# pieces and dependencies

psedit "$ScriptPath\MetaConfigurationForPartialConfigs.ps1"
. "$ScriptPath\MetaConfigurationForPartialConfigs.ps1"

MetaConfigForPartialConfigs -ComputerName $TestNode -OutputPath "$OutputPath\MetaConfigurationForPartialConfigs"
Set-DscLocalConfigurationManager -Path "$OutputPath\MetaConfigurationForPartialConfigs" -ComputerName $TestNode `
                                    -Verbose -Credential $Credential

# Once set start will not work
psedit "$ScriptPath\HeloWorld.ps1"
. "$ScriptPath\HeloWorld.ps1"
HeloWorld -ComputerName $TestNode -OutputPath "$OutputPath\HeloWorld"
Start-DscConfiguration -Path "$OutputPath\HeloWorld" -Wait -Force -ComputerName $TestNode -Credential $Credential -Verbose
 
psedit "$ScriptPath\OSLayer.ps1"
psedit "$ScriptPath\AppLayer.ps1"

. "$ScriptPath\OSLayer.ps1"
. "$ScriptPath\AppLayer.ps1"

OSLayer -ComputerName $TestNode -OutputPath "$OutputPath\OSLayer"
AppLayer -ComputerName $TestNode -OutputPath "$OutputPath\AppLayer"

Publish-DscConfiguration -Path "$OutputPath\OSLayer" -ComputerName $TestNode -verbose -Credential $Credential

Publish-DscConfiguration -Path "$OutputPath\AppLayer" -ComputerName $TestNode -verbose -Credential $Credential

# the file is only published and during invocation is merged
Invoke-Command $TestNode -Credential $Credential { dir "$env:windir\system32\configuration\PartialConfigurations"}
Invoke-ConsistencyCheck -ComputerName $TestNode -Credential $Credential

# reset the metaconfiguration 
Set-DscLocalConfigurationManager -Path "$OutputPath\MetaConfiguration" -ComputerName $TestNode -Credential $Credential -Verbose

