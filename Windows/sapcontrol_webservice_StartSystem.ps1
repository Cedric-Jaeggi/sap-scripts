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

$pwdfile = "D:\"+$sid+"adm.txt"
$passwd = (Get-Content $pwdfile) | ConvertTo-SecureString
$passwd = [System.Net.NetworkCredential]::new("", $passwd).Password
$sidadm = $sid+"adm"

if (Test-Path $path)
{

cd $path

do
{
$instcount--

try{
$sapctrlresult = .\sapcontrol.exe -nr $instcount -user $sidadm $passwd -function StartWait 300 1 #StopSystem #-format script
}

catch{
$error[0].exception
}

$sapctrlresultcount = $sapctrlresult.Count / 4
$iter = 0
$sapctrlresults = @{}
$result = ""

do{
$sapctrlresultcount--
$sapctrlresults.add($sapctrlresultcount, ($sapctrlresult | Select-Object -First 4 -Skip $iter))
$iter = $iter + 4
}while ($sapctrlresultcount -gt 0)

foreach ($result in $sapctrlresults.Values)
{

if(($result | Select-Object -Skip 3) -eq "OK"){

switch ($p.dispstatus)
{
    "GREEN" {$errorLevel = "OK"}
    "GRAY" {$errorLevel = "STOPPED"}
    "YELLOW" {$errorLevel = "WARNING"}
    "RED" {$errorLevel = "ERROR"}
}

Write-Host "Instance" $instcount ":" $result
}

else {Write-Host "SAPControl request failed:" $result}
}
}until ($instcount -eq 0)
} 

else {Write-Host "Path to SID $sid not found"}
