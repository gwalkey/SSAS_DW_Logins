
# Delete all Imported XEL Files

 $Files = gci -path "d:\traces\*.xel" -Recurse | select fullname 
 
 foreach($file in $files)
 {
    [string]$Item = $file.FullName
    remove-item $item -Force
 }


 