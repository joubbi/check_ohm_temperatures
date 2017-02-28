<#
.SYNOPSIS
This is a PowerShell script used by NSClient++ to check the temperatures on a host running Windows.
NSClient++ can then be called by Nagios (Op5 Monitor, Icinga or similar) to run this script.

.DESCRIPTION
Open Hardware Monitor (openhardwaremonitor.org) is used as a driver for the temperature sensors.
Open Hardware monitor creates WMI objects of all the found sensors.
This script retrieves the temperatures from those WMI objects.
This means that you have to download and run OpenHardwareMonitor.exe before running this check.

All the found temperatures will be output as performance data so that they can be graphed.

Define the command in nsclient++:
cmd /c echo scripts\custom\check_temperatures.ps1 -warning $ARG1$ -critical $ARG2$; exit($lastexitcode) | powershell.exe -command -
or you can omit or hard code the warning and critical arguments in case you do not permit sending arguments to nsclient.

.EXAMPLE
.\check_ohm_temperatures.ps1 -warning 80 -critical 90

.NOTES
Licensed under the Apache License Version 2.0
Written by farid@joubbi.se

1.1 2016-03-24 Minor cleanup of variables and documentation.
1.0 2016-03-11 Initial release.


.LINK
http://www.joubbi.se/monitoring.html
http://nsclient.org/
http://openhardwaremonitor.org/

#>

param (
    [ValidateRange(0,200)]
    [Int]
    [string]$warning = 70,
    [ValidateRange(0,200)]
    [Int]
    [string]$critical = 80
)

$status='OK'


# Check if Open Hardware Monitor is running.
if ((Get-Process -Name OpenHardwareMonitor -ErrorAction SilentlyContinue) -eq $null) {
    write-host 'OpenHardwareMonitor.exe not running!'
    exit 3
}

# Check that critical is set to higher than warning
if ($warning -gt $critical) {
    write-host 'warning set to higher than critical temperature!'
    exit 3
}

# Get the temperatures from all the found sensors and check them
$temperatures = Get-WmiObject -Namespace "Root\OpenHardwareMonitor" -Query "SELECT * FROM Sensor WHERE Sensortype='Temperature'" | sort-object Identifier

$temperature_string = foreach ($result in $temperatures){
    $result.Identifier = $result.Identifier -replace '^/','' -replace 'temperature/',''
    '{0}={1};{2};{3};{4};{5}' -f $result.Identifier, $result.Value, $warning, $critical, $result.Min, $result.Max
    if ($result.value -gt $warning) { $status = 'WARNING'}
    if ($result.value -gt $critical) { $status = 'CRITICAL'}
}
 
write-host "temperatures $status | $temperature_string"
if ($status -eq 'WARNING') { exit 1 }
if ($status -eq 'CRITICAL') { exit 2 }
exit 0
