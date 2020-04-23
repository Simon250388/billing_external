$appName = 'C:\Program Files\1cv8\8.3.15.1700\bin\1cv8.exe'
$folder = "\\172.29.1.50\Users\Xabarov\GITWorkForBilling"
$bslName = "бест»нструментыЌачисленийЌѕ"
$folderBslName = ("$folder\$bslName")
& $appName "DESIGNER /DumpExternalDataProcessorOrReportToFiles $folderBslName $folderBslName\bin\$bslName.epf" | Out-String
$bslName = "бест–абота—ѕериодомƒействи€Ќѕ"
$folderBslName = ("$folder\$bslName")
& $appName "DESIGNER /DumpExternalDataProcessorOrReportToFiles $folderBslName $folderBslName\bin\$bslName.epf" | Out-String
$bslName = "бест–абота—ѕоследовательност€миЌѕ"
$folderBslName = ("$folder\$bslName")
& $appName "DESIGNER /DumpExternalDataProcessorOrReportToFiles $folderBslName $folderBslName\bin\$bslName.epf" | Out-String
$bslName = "бест–абота—ѕоследовательност€ми—обыти€Ќѕ"
$folderBslName = ("$folder\$bslName")
& $appName "DESIGNER /DumpExternalDataProcessorOrReportToFiles $folderBslName $folderBslName\bin\$bslName.epf" | Out-String
$bslName = "энрг»нструментыЌачислений"
$folderBslName = ("$folder\$bslName")
& $appName "DESIGNER /DumpExternalDataProcessorOrReportToFiles $folderBslName $folderBslName\bin\$bslName.epf" | Out-String
$bslName = "энрг–абота—ѕериодомƒействи€"
$folderBslName = ("$folder\$bslName")
& $appName "DESIGNER /DumpExternalDataProcessorOrReportToFiles $folderBslName $folderBslName\bin\$bslName.epf" | Out-String
$bslName = "энрг–абота—ѕоследовательност€ми"
$folderBslName = ("$folder\$bslName")
& $appName "DESIGNER /DumpExternalDataProcessorOrReportToFiles $folderBslName $folderBslName\bin\$bslName.epf" | Out-String
$bslName = "энрг–абота—ѕоследовательност€ми—обыти€"
$folderBslName = ("$folder\$bslName")
& $appName "DESIGNER /DumpExternalDataProcessorOrReportToFiles $folderBslName $folderBslName\bin\$bslName.epf" | Out-String