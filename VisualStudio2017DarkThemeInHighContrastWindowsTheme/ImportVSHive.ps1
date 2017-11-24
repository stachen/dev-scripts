## This script will allow you to still use Visual Studio Dark Theme even in Windows High Contrast Theme 

#modify this 
$VSVersion = '15.0_0202864a'

# load VS private registry 
$binLocation = $env:LOCALAPPDATA + '\Microsoft\VisualStudio\'+ $VSVersion +'\privateregistry.bin'
$HiveKey = 'HKLM\HKEY_TEMPVS\'
$Name = "VS2017PrivateRegistry"
reg load $HiveKey $binLocation

# export Visual Studio dark theme registry key
$ExportKeyFilename = $env:TEMP + '\exportedkey.bak.reg'
$ImportKeyFilename = $env:TEMP + '\importedkey.reg'
reg export 'HKEY_LOCAL_MACHINE\HKEY_TEMPVS\Software\Microsoft\VisualStudio\15.0_0202864a_Config\Themes\{1ded0138-47ce-435e-84ef-9ec1f439b749}' $ExportKeyFilename /y

# replace VS dark theme guid with windows high contrast theme guid and import a dark theme setting for the high contrast theme
(Get-Content $ExportKeyFilename).replace('1ded0138-47ce-435e-84ef-9ec1f439b749', 'a5c004b4-2d4b-494e-bf01-45fc492522c7') | Set-Content $ImportKeyFilename
reg import $ImportKeyFilename

# clean up
[gc]::collect() 
reg unload $HiveKey
Remove-Item $ExportKeyFilename
Remove-Item $ImportKeyFilename