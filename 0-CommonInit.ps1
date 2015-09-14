$MyPath = Split-Path $MyInvocation.MyCommand.Path
$DemoRoot    = 'D:\Nana\Test'
$OutputPath  = "$DemoRoot\CompiledConfigurations"
$TraceFolder = "$DemoRoot\Traces"
$AzureDemoNode = 'Nana-AADemo-10'

Import-Module -Force "$MyPath\HelperMethods.psm1"

$DomainController    = 'Nana-XM-DC' 
$DNSServer           = '192.168.1.100'
$TestNode            = 'Nana-XM-Node'
$PCTestNode          = 'Nana-PC-Node'

if ($null -eq $Credential)
{
  $Credential = Get-Credential administrator
}
#endregion Initialization