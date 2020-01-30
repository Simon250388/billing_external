$parentPath = ((Get-Item -Path '.\' -Verbose).Parent).FullName
Get-ChildItem -Path $parentPath | ?{ $_.PSIsContainer } | Select-Object Name |Where-Object  {$_.Name -ne "script"} | foreach {$parentPath +"\"+ $_.Name}
