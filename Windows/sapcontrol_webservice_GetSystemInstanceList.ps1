$sid = ""
$path = ""
$sapctrlresult = ""
$error.Clear()
$inst = ""
$i = ""
$errorLevel = ""

$sid = "SFT"
$path = "D:\usr\sap\$sid\sys\exe\uc\NTAMD64\"

if (Test-Path $path)
{

cd $path

try{
$sapctrlresult = .\sapcontrol.exe -nr 0 -function GetSystemInstanceList -format script
}

catch{
$error[0].exception
}

if($sapctrlresult -match "OK"){

$inst = $sapctrlresult | Select-Object -Skip 4 | ConvertFrom-Csv

foreach ($i in $inst){
switch ($i.dispstatus)
{
    "GREEN" {$errorLevel = "OK"}
    "GRAY" {$errorLevel = "STOPPED"}
    "YELLOW" {$errorLevel = "WARNING"}
    "RED" {$errorLevel = "ERROR"}
}

Write-Host $i.features": Status is $errorLevel"
}
}

else {Write-Host "SAPControl request failed:" ($sapctrlresult | Select-Object -Skip 3)}
}

else {Write-Host "Path to SID $sid not found"}

$instcount = ($inst.instancenr).Count