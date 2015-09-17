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

MetaConfigForPartialConfigs -ComputerName $PCTestNode -OutputPath "$OutputPath\MetaConfigurationForPartialConfigs"
Set-DscLocalConfigurationManager -Path "$OutputPath\MetaConfigurationForPartialConfigs" -ComputerName $PCTestNode `
                                    -Verbose -Credential $Credential

# Once set start will not work
psedit "$ScriptPath\HeloWorld.ps1"
. "$ScriptPath\HeloWorld.ps1"
HeloWorld -ComputerName $PCTestNode -OutputPath "$OutputPath\HeloWorld"
Start-DscConfiguration -Path "$OutputPath\HeloWorld" -Wait -Force -ComputerName $PCTestNode -Credential $Credential -Verbose
 
psedit "$ScriptPath\OSLayer.ps1"
psedit "$ScriptPath\AppLayer.ps1"

. "$ScriptPath\OSLayer.ps1"
. "$ScriptPath\AppLayer.ps1"

OSLayer -ComputerName $PCTestNode -OutputPath "$OutputPath\OSLayer"
AppLayer -ComputerName $PCTestNode -OutputPath "$OutputPath\AppLayer"

Publish-DscConfiguration -Path "$OutputPath\OSLayer" -ComputerName $PCTestNode -verbose -Credential $Credential

Publish-DscConfiguration -Path "$OutputPath\AppLayer" -ComputerName $PCTestNode -verbose -Credential $Credential

# the file is only published and during invocation is merged
Invoke-Command $PCTestNode -Credential $Credential { dir "$env:windir\system32\configuration\PartialConfigurations"}

# convergence happens automatically on the next consistency check
Invoke-ConsistencyCheck -ComputerName $PCTestNode -Credential $Credential

# you can also force one using Start-DscConfiguration
Start-DscConfiguration -UseExisting -ComputerName $PCTestNode -Wait -Verbose -Credential $Credential

# correct the exclusiv error and republish
psedit "$ScriptPath\OSLayer.ps1"
. "$ScriptPath\OSLayer.ps1"
OSLayer -ComputerName $PCTestNode -OutputPath "$OutputPath\OSLayer"
Publish-DscConfiguration -Path "$OutputPath\OSLayer" -ComputerName $PCTestNode -verbose -Credential $Credential
Invoke-ConsistencyCheck -ComputerName $PCTestNode -Credential $Credential

# reset the metaconfiguration 
. "$ScriptPath\MetaConfiguration.ps1"
MetaConfiguration -ComputerName $PCTestNode -OutputPath "$OutputPath\MetaConfiguration"
Set-DscLocalConfigurationManager -Path "$OutputPath\MetaConfiguration" -ComputerName $PCTestNode -Credential $Credential -Verbose

