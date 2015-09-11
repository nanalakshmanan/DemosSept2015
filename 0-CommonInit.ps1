
$MyPath = Split-Path $MyInvocation.MyCommand.Path
$DemoRoot    = 'D:\Nana\Test'
$OutputPath  = "$DemoRoot\CompiledsConfigurations"
$TraceFolder = "$DemoRoot\Traces"
$AzureDemoNode = 'Nana-AADemo3'

Import-Module -Force "$MyPath\HelperMethods.psm1"

#region Initialization
<#$PSDefaultParameterValues = @{'Find-Module:Repository'='NanaGallery'}
$PSDefaultParameterValues += @{'Install-Module:Repository'='NanaGallery'}
$PSDefaultParameterValues += @{'Publish-Module:Repository'='NanaGallery'}
$PSDefaultParameterValues += @{'Find-DscResource:Repository'='NanaGallery'}
#>

$DomainController    = 'Nana-XM-DC' 
$DNSServer           = '192.168.1.100'
$TestNode            = 'Nana-XM-Node'

<#$SourcePath          = 'C:\Content\content\BakeryWebsite'
$ResourcePath        = "$($env:TEMP)\Modules"
#>

if ($null -eq $Credential)
{
  $Credential = Get-Credential administrator
}
#endregion Initialization