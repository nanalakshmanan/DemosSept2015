$ScriptPath = Split-Path $MyInvocation.MyCommand.Path
. "$ScriptPath\..\0-CommonInit.ps1"

# get configuration status from a node
$s = New-CimSession -ComputerName $DomainController -Credential $Credential
Get-DscConfigurationStatus -CimSession $s

# get all configuration status
Get-DscConfigurationStatus -CimSession $s -All -OutVariable Status

# Properties of interest - Status, Type, Mode, RebootRequested

# information available in status
$Status[0] | Format-List * -Force

# job id filtering
$Status | Group-Object -Property JobId

# post reboot will have same job id

# resources in desired state
$Status[-3].ResourcesInDesiredState | Format-Table ResourceId, ModuleName, ModuleVersion, REbootRequested -AutoSize

# mess around with something
Invoke-Command -ComputerName $DomainController -Credential $Credential {net user nana /delete }

# invoke consistency check
Invoke-ConsistencyCheck -ComputerName $DomainController -Credential $Credential 

# show resources not in desired state
Get-DscConfigurationStatus -CimSession $s -All -OutVariable Status
$Status[0].ResourcesNotInDesiredState

# check when there was a deviation
$status | ?{$_.ResourcesNotInDesiredSTate -ne $Null}

# fix the mess up
Start-DscConfiguration -ComputerName $DomainController -Credential $Credential -UseExisting -Force -Verbose -Wait