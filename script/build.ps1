$curentPath = (Split-Path $MyInvocation.MyCommand.Path -Parent)
[xml]$configFile = get-content $curentPath\Config.xml
$PlatformPath = $configFile.configuration.Platform1c.add | Where-Object { $_.Key -eq 'path' } | ForEach-Object { $_.value }
$appName = "$PlatformPath\bin\1cv8.exe"
$parentPath = (Split-Path (Split-Path $MyInvocation.MyCommand.Path -Parent) -Parent)
$ObjectNames = Get-ChildItem -Path $parentPath | Where-Object { $_.PSIsContainer } | Select-Object Name | Where-Object { $_.Name -ne "script" };
$ObjectNames | ForEach-Object {
   $bslName = $_.Name
   $epfPath = ("$parentPath\$bslName\bin\$bslName.epf")
   if ((Test-Path  $epfPath  ) -eq "True") {
      Remove-Item -Path $epfPath | write-host -NoNewline
   } }
$ObjectNames | ForEach-Object {   
   $bslName = $_.Name
   $epfPath = ("$parentPath\$bslName\bin\$bslName.epf")
   $folderBslName = ("$parentPath\$bslName")
   [string[]]$argList = "DESIGNER", "/LoadExternalDataProcessorOrReportFromFiles", """$folderBslName\$bslName.xml""", """$folderBslName\bin\$bslName.epf"""
   Start-Process -FilePath $appName -ArgumentList $argList -NoNewWindow -Wait
   while ($true) {
      if ((Test-Path  $epfPath  ) -eq "True") {
         break;
      }
      Start-Process -FilePath $appName -ArgumentList $argList -NoNewWindow -Wait
   }
   write-host  $epfPath          
} 