## This script will allow you to still use Visual Studio Dark Theme even in Windows High Contrast Theme 
## Needs to be run in administrator mode

function CheckExitCode
{
    if($LASTEXITCODE -ne 0)
    {
        write-error 'Operation failed'
    }
}

$ErrorActionPreference = "Stop"

#modify this 
$VSVersion = '15.0_0202864a'

write-host 'Loading VS private registry into hive...'
$binLocation = $env:LOCALAPPDATA + '\Microsoft\VisualStudio\'+ $VSVersion +'\privateregistry.bin'
$HiveKey = 'HKLM\HKEY_TEMPVS\'
reg load $HiveKey $binLocation
CheckExitCode


write-host 'Exporting Visual Studio dark theme registry key...'
$ExportKeyPath = 'HKEY_LOCAL_MACHINE\HKEY_TEMPVS\Software\Microsoft\VisualStudio\' + $VSVersion + '_Config\Themes\{1ded0138-47ce-435e-84ef-9ec1f439b749}' 
$ExportKeyFilename = $env:TEMP + '\exportedkey.bak.reg'
$ImportKeyFilename = $env:TEMP + '\importedkey.reg'
reg export $ExportKeyPath $ExportKeyFilename /y
CheckExitCode

write-host 'Replacing VS dark theme guid with windows high contrast theme guid...'
(Get-Content $ExportKeyFilename).replace('1ded0138-47ce-435e-84ef-9ec1f439b749', 'a5c004b4-2d4b-494e-bf01-45fc492522c7') | Set-Content $ImportKeyFilename

write-host 'Importing a dark theme setting for the high contrast theme...'
reg import $ImportKeyFilename
CheckExitCode

write-host 'Cleaning up...'
[gc]::collect() 
Remove-Item $ExportKeyFilename
Remove-Item $ImportKeyFilename
reg unload $HiveKey
CheckExitCode