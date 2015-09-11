$ScriptPath = Split-Path $MyInvocation.MyCommand.Path

configuration ProcessOwnerCredential
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Script owner
    {
        GetScript = {@{}}
        SetScript = {$p = (Get-Process -id $pid);
                     $info = (D:\Nana\Official\git\DemosSept2015\RunAs\Get-ProcessOwner.ps1 -process $p); 
                     write-verbose -verbose -message "This process runs as $($info.Name.ToString())"}
        TestScript = {$false}
        PsDscRunAsCredential = Get-Credential .\Administrator
    }
}