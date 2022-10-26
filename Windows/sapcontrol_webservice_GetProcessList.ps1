$sid = ""
$path = ""
$sapctrlresult = ""
$error.Clear()
$inst = ""
$i = ""
$n = ""
$proc = ""
$errorLevel = ""
$instcount = 2

$sid = "SFT"
$path = "D:\usr\sap\$sid\sys\exe\uc\NTAMD64\"

if (Test-Path $path)
{

cd $path

do
{
$instcount--

try{
$sapctrlresult = .\sapcontrol.exe -nr $instcount -function GetProcessList #-format script
}

catch{
$error[0].exception
}

if($sapctrlresult -match "OK"){

#$proc = (($sapctrlresult | Select-Object -skip 4).substring(0,1) | Group-Object).Name
$proc = $sapctrlresult | Select-Object -Skip 4 | ConvertFrom-Csv


foreach ($p in $proc){
#$inst = $sapctrlresult | Where-Object {$_ -like "$p*"}
#$inst = ($inst.replace(":","") | convertfrom-csv -Delimiter " " -Header "ID","Item","Value")
#$i = $inst | Where-Object {$_.Item -eq "dispstatus"}
#$n = $inst | Where-Object {$_.Item -eq "name"}

switch ($p.dispstatus)
{
    "GREEN" {$errorLevel = "OK"}
    "GRAY" {$errorLevel = "STOPPED"}
    "YELLOW" {$errorLevel = "WARNING"}
    "RED" {$errorLevel = "ERROR"}
}

Write-Host "Instance" $instcount ":" $p.description": Status is $errorLevel"
}
}

else {Write-Host "SAPControl request failed:" ($sapctrlresult | Select-Object -Skip 3)}
}until ($instcount -eq 0)
} 

else {Write-Host "Path to SID $sid not found"}