$ScriptPath = Split-Path $MyInvocation.MyCommand.Path
. "$ScriptPath\1-CommonInit.ps1"


# Load configuration Settings
Write-Verbose "Loading subscription settings '$ScriptPath\Azure.Subscription.Settings.ps1'"
$Settings = (& "$ScriptPath\Azure.Subscription.Settings.ps1")


# get the registration information for the account
Get-AzureAutomationRegistrationInfo -ResourceGroupName $Settings.ResourceGroup `
                                    -AutomationAccountName $Settings.AutomationAccount `
                                    -Verbose `
                                    -OutVariable RegInfo

# let us use a simple configuration
psedit "$ScriptPath\Features.ps1"

# import the configuration script
Import-AzureAutomationDscConfiguration -SourcePath "$ScriptPath\Features.ps1" `
                                       -Description 'Simple demo' `
                                       -Published `
                                       -Force `
                                       -ResourceGroupName $Settings.ResourceGroup `
                                       -AutomationAccountName $Settings.AutomationAccount `
                                       -Verbose

# view the status of the configuration script
Get-AzureAutomationDscConfiguration -Name 'Features' -ResourceGroupName $Settings.ResourceGroup -AutomationAccountName $Settings.AutomationAccount -Verbose

# compile the configuration script
Start-AzureAutomationDscCompilationJob -ConfigurationName 'Features' `
                                       -ResourceGroupName $Settings.ResourceGroup `
                                       -AutomationAccountName $Settings.AutomationAccount `
                                       -Verbose `
                                       -OutVariable job

# view status of compilation
Get-AzureAutomationDscCompilationJob -Id $job.Id -ResourceGroupName $Settings.ResourceGroup -AutomationAccountName $Settings.AutomationAccount 

# use this in an Azure node
Register-AzureAutomationDscNode -AzureVMName $AzureDemoNode `
                                -ResourceGroupName $Settings.ResourceGroup `
                                -AutomationAccountName $Settings.AutomationAccount `
                                -AzureVMLocation $Settings.StorageLocation `
                                -Verbose
# get list of nodes registered
Get-AzureAutomationDscNode -ResourceGroupName $Settings.ResourceGroup -AutomationAccountName $Settings.AutomationAccount 

# get the required metaconfiguration
Get-AzureAutomationDscOnboardingMetaconfig -OutputFolder "$DemoRoot" `
                                           -ResourceGroupName $Settings.ResourceGroup `
                                           -AutomationAccountName $Settings.AutomationAccount `
                                           -Force

# invoke the meta config from a node in AWS
# registration happens from meta config is set

# get list of nodes registered
Get-AzureAutomationDscNode -ResourceGroupName $Settings.ResourceGroup -AutomationAccountName $Settings.AutomationAccount

# Assign a configuration to node
Set-AzureAutomationDscNode -NodeConfigurationName 'Features.localhost' -ResourceGroupName $Settings.ResourceGroup -AutomationAccountName $Settings.AutomationAccount