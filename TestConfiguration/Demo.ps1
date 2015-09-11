$ScriptPath = Split-Path $MyInvocation.MyCommand.Path
. "$ScriptPath\..\0-CommonInit.ps1"

$s = New-CimSession -ComputerName $TestNode -Credential $Credential

# get VM to initial state
# Restore-VMSnapshot -Name 'Initial' -VMName $TestNode -Verbose 

# test the status of a configuration
Test-DscConfiguration -CimSession $s

# when there are no configurations it returns an error

# apply a simple configuration
psedit "$ScriptPath\Configuration.Simple.ps1"
. "$ScriptPath\Configuration.Simple.ps1"
$ConfigData = (& "$ScriptPath\ConfigData.Simple.ps1")
Simple -OutputPath "$OutputPath\Simple" -ConfigurationData $ConfigData
Start-DscConfiguration -Path "$OutputPath\Simple" -Wait -Force -Verbose

# run test configuration again
Test-DscConfiguration -CimSession $s

# returns a boolean so can be used in a script
if (Test-DscConfiguration -CimSession $s){Write-Output 'System is in desired state'}

# to get detailed information, use -Detailed
Test-DscConfiguration -CimSession $s -Detailed -Verbose

Invoke-Command -ComputerName $TestNode -Credential $Credential {del c:\temp\heloworld.txt}

# notice how detailed tells the resource that are in desired state and
# those that aren't
Test-DscConfiguration -CimSession $s -Detailed -Verbose

# Test if system pertains to a configuration without applying it
psedit "$ScriptPath\Configuration.Features.ps1"
. "$ScriptPath\Configuration.Features.ps1"
Features -OutputPath "$OutputPath\Features" -ConfigurationData $ConfigData

Test-DscConfiguration -Path "$OutputPath\Features"  -CimSession $s -Verbose

# it used the mof in the path - but didn't mess with the existing one
Test-DscConfiguration -CimSession $s -Detailed -Verbose

# can compare multiple machines with a reference mof
$s2 = New-CimSession -ComputerName $DomainController -Credential $Credential
Test-DscConfiguration -CimSession ($s, $s2) -ReferenceConfiguration "$OutputPath\Features\$TestNode.mof" -Verbose 