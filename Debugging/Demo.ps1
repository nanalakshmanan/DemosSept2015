$ScriptPath = Split-Path $MyInvocation.MyCommand.Path
. "$ScriptPath\..\0-CommonInit.ps1"

# here is a sample resource - nService
psedit "$env:ProgramFiles\windowspowershell\modules\nPSDesiredStateConfiguration\DSCResources\Nana_nService\Nana_nService.psm1"

# copy a buggy resource to demo debugging
copy "$env:ProgramFiles\windowspowershell\modules\nPSDesiredStateConfiguration\DSCResources\Nana_nService\Nana_nService.psm1" "$env:ProgramFiles\windowspowershell\modules\nPSDesiredStateConfiguration\DSCResources\Nana_nService\Nana_nService.Original.psm1"
copy "$ScriptPath\Nana_nService_Buggy.psm1" "$env:ProgramFiles\windowspowershell\modules\nPSDesiredStateConfiguration\DSCResources\Nana_nService\Nana_nService.psm1"

# here is a sample configuration
psedit "$ScriptPath\ServiceConfiguration.ps1"

# invoke the configuration

. "$ScriptPath\ServiceConfiguration.ps1"
ServiceConfiguration -OutputPath "$Outputpath\ServiceConfiguration"
Start-DscConfiguration -Path "$Outputpath\ServiceConfiguration" -ComputerName localhost -Verbose -force -Wait

# enable debugging for DSC Resources
Enable-DscDebug -BreakAll

# apply the configuration again
Start-DscConfiguration -Path "$Outputpath\ServiceConfiguration" -ComputerName localhost -Verbose -force -Wait

# disable debugging
Disable-DscDebug

# restore the correct file
copy "$env:ProgramFiles\windowspowershell\modules\nPSDesiredStateConfiguration\DSCResources\Nana_nService\Nana_nService.original.psm1" `
        "$env:ProgramFiles\windowspowershell\modules\nPSDesiredStateConfiguration\DSCResources\Nana_nService\Nana_nService.psm1"

# DSC debugging uses the PowerShell debugging enhancements introduced in v5

# Get a list of Processes hosting PowerShell that can be debugged
Get-PSHostProcessInfo

# can attach to any process using
#Enter-PSHostProcess -Id -AppDomainName

# can get list of runspaces to debug
Get-Runspace

# debug using Debug-Runspace
# Debug-Runspace -id 

# debugging class based resources is similar

copy "$env:ProgramFiles\windowspowershell\modules\nServiceManager\nService.psm1" "$env:ProgramFiles\windowspowershell\modules\nServiceManager\nService.Original.psm1"
copy "$ScriptPath\nService_Buggy.psm1" "$env:ProgramFiles\windowspowershell\modules\nServiceManager\nService.psm1"

psedit "$ScriptPath\ServiceConfigurationClasses.ps1"
. "$ScriptPath\ServiceConfigurationClasses.ps1"
ServiceConfigurationClasses -OutputPath "$Outputpath\ServiceConfigurationClasses"
Start-DscConfiguration -Path "$Outputpath\ServiceConfigurationClasses" -ComputerName localhost -Verbose -force -Wait

# enable debugging for DSC resources
Enable-DscDebug -BreakAll

# apply the configuration again
# note the 2 step over and 1 Step into for the class based resource

Start-DscConfiguration -Path "$Outputpath\ServiceConfigurationClasses" -ComputerName localhost -Verbose -force -Wait

# disable debugging
Disable-DscDebug 

# restore contents back
copy "$env:ProgramFiles\windowspowershell\modules\nServiceManager\nService.original.psm1" "$env:ProgramFiles\windowspowershell\modules\nServiceManager\nService.psm1"
