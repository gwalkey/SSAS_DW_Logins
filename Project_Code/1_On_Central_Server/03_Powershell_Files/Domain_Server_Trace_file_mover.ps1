# Get Day of Week for Yesterday
[string]$Day = ((get-date).AddDays(-1)).DayOfWeek

$SourceFolder='\\domain_server1\d$\traces\'
$FileSpec = $SourceFolder+'XE_Logins_'+$Day+'*.xel'
Write-Output('{0}' -f $Filespec)

# XE Files
Move-Item -Path $FileSpec -Destination d:\traces\domain_server1  -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue



