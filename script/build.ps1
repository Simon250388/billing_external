$appName = 'C:\Program Files\1cv8\8.3.15.1700\bin\1cv8.exe'
$parentPath = (Split-Path (Split-Path $MyInvocation.MyCommand.Path -Parent) -Parent)
Get-ChildItem -Path $parentPath | ?{ $_.PSIsContainer } | Select-Object Name |Where-Object  {$_.Name -ne "script"} | foreach {
    $bslName = $_.Name
    $epfPath = ("$parentPath\$bslName\bin\$bslName.epf") 
    write-host  $epfPath 
    if ((Test-Path  $epfPath  ) -eq "True"){
	Remove-Item -Path $epfPath}  
    $folderBslName = ("$parentPath\$bslName")
    & $appName "DESIGNER /LoadExternalDataProcessorOrReportFromFiles $folderBslName\$bslName.xml $folderBslName\bin\$bslName.epf"| Write-Host -NoNewline
    }
