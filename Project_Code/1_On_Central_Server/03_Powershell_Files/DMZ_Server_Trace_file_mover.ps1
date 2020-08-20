# Get Day of Week for Yesterday
[string]$Day = ((get-date).AddDays(-1)).DayOfWeek

$SourceFolder='K:\traces\'
$FileSpec = $SourceFolder+'XE_Logins_'+$Day+'*.xel'
Write-Output('{0}' -f $Filespec)

# Create PShell Credential
$pass="NotaGreatPassword"|ConvertTo-SecureString -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PsCredential("DMZSERVER1\dba",$pass)

# Create PShell Drive to point to dmz server share
New-PSDrive -name K  -PSProvider FileSystem -Credential $Cred -scope Script -root \\dmzserver1\traces

# Move Sql Trace Files from DMZ machine for import
Move-Item -Path $filespec -Destination d:\traces\DMZSERVER1 -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

set-location c:

Remove-PSDrive -name K


