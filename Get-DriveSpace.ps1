##################################################
## Author: Leandro Matos
## Copyright: Copyright 2020.
##################################################

#Machine hostname
$strComputer = hostname

$LogDate = ((get-date).ToLocalTime()).ToString("yyyy-MM-ddTHH:mm:ss.fff")

#Does the server responds to a ping (otherwise the WMI queries will fail)
$query = "select * from win32_pingstatus where address = '$strComputer'"
$result = Get-WmiObject -query $query

if ($result.protocoladdress) {

    # Get the Disks for this computer
    $colDisks = get-wmiobject Win32_LogicalDisk -computername $strComputer -Filter "DriveType = 3"

    # For each disk calculate the free space
    foreach ($disk in $colDisks) {
       if ($disk.size -gt 0) {$PercentFree = [Math]::round((($disk.freespace/$disk.size) * 100))}
       else {$PercentFree = 0}

       $Drive = $disk.DeviceID
       "$LogDate - Hostname: $strComputer - Unidade: $Drive - Porcentagem livre: $PercentFree"

       # if  < 20% free space, log to a file
       if ($PercentFree -le 80) {"$LogDate - Hostname: $strComputer - Unidade: $Drive - Porcentagem Livre: $PercentFree" | out-file -append -filepath "D:\projetos\get-drive-space\Drive Space.txt"}
    }
}


