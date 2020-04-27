try {
$appName = 'C:\Program Files\1cv8\8.3.15.1700\bin\1cv8.exe'
$folder = "F:\Кирилл\GitBill2"
$bslNameExecuter = "энргИнструментыНачислений"
$folderBslNameExecuter = ("$folder\$bslNameExecuter")
& $appName "DESIGNER /LoadExternalDataProcessorOrReportFromFiles $folderBslNameExecuter\$bslNameExecuter.xml $folderBslNameExecuter\bin\$bslNameExecuter.epf"| Out-String
$bslNameEvents = "энргРаботаСПериодомДействия"
$folderBslNameEvents = ("$folder\$bslNameEvents")
& $appName "DESIGNER /LoadExternalDataProcessorOrReportFromFiles $folderBslNameEvents\$bslNameEvents.xml $folderBslNameEvents\bin\$bslNameEvents.epf"| Out-String
$bslNameSequence = "энргРаботаСПоследовательностями"
$folderBslNameSequence = ("$folder\$bslNameSequence")
& $appName "DESIGNER /LoadExternalDataProcessorOrReportFromFiles $folderBslNameSequence\$bslNameSequence.xml $folderBslNameSequence\bin\$bslNameSequence.epf"| Out-String
$bslNameSequenceEvent = "энргРаботаСПоследовательностямиСобытия"
$folderBslNameSequenceEvent = ("$folder\$bslNameSequenceEvent")
& $appName "DESIGNER /LoadExternalDataProcessorOrReportFromFiles $folderBslNameSequenceEvent\$bslNameSequenceEvent.xml $folderBslNameSequenceEvent\bin\$bslNameSequenceEvent.epf"| Out-String
$bslNameSequenceEvent = "бестИнструментыНачисленийНП"
$folderBslNameSequenceEvent = ("$folder\$bslNameSequenceEvent")
& $appName "DESIGNER /LoadExternalDataProcessorOrReportFromFiles $folderBslNameSequenceEvent\$bslNameSequenceEvent.xml $folderBslNameSequenceEvent\bin\$bslNameSequenceEvent.epf"| Out-String
$bslNameSequenceEvent = "бестРаботаСПериодомДействияНП"
$folderBslNameSequenceEvent = ("$folder\$bslNameSequenceEvent")
$folderBslNameSequenceEvent = ("$folder\$bslNameSequenceEvent")
& $appName "DESIGNER /LoadExternalDataProcessorOrReportFromFiles $folderBslNameSequenceEvent\$bslNameSequenceEvent.xml $folderBslNameSequenceEvent\bin\$bslNameSequenceEvent.epf"| Out-String
$bslNameSequenceEvent = "бестРаботаСПоследовательностямиНП"
$folderBslNameSequenceEvent = ("$folder\$bslNameSequenceEvent")
& $appName "DESIGNER /LoadExternalDataProcessorOrReportFromFiles $folderBslNameSequenceEvent\$bslNameSequenceEvent.xml $folderBslNameSequenceEvent\bin\$bslNameSequenceEvent.epf"| Out-String
$bslNameSequenceEvent = "бестРаботаСПоследовательностямиСобытияНП"
$folderBslNameSequenceEvent = ("$folder\$bslNameSequenceEvent")
& $appName "DESIGNER /LoadExternalDataProcessorOrReportFromFiles $folderBslNameSequenceEvent\$bslNameSequenceEvent.xml $folderBslNameSequenceEvent\bin\$bslNameSequenceEvent.epf"| Out-String
Write-Host "успешно"
}
Catch {
Write-Host "ошибка"
}
