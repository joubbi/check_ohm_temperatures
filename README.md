# check_ohm_temperatures

This is a PowerShell script used by NSClient++ to check the temperatures on a host running Microsoft Windows.
NSClient++ can then be called by Nagios (Op5 Monitor, Icinga or similar) to run this script.


[__Open Hardware Monitor__] (http://openhardwaremonitor.org) is used as a driver for the temperature sensors.
Open Hardware monitor creates WMI objects of all the found sensors. This script retrieves the temperatures from those WMI objects.
This means that you have to download and run OpenHardwareMonitor.exe before running this check.

There is no standardized way to retrieve the temperatures in Windows even if the hardware has a temperature sensor.
Open Hardware monitor supports many sensors and is open source.


All the found temperatures will be output as performance data so that they can be graphed.


Tested with Windows 7 and Windows 2003.


Define the command in __nsclient++__:
```
cmd /c echo scripts\custom\check_temperatures.ps1 -warning $ARG1$ -critical $ARG2$; exit($lastexitcode) | powershell.exe -command -
```
or you can omit or hard code the warning and critical arguments in case you do not permit sending arguments to nsclient.


### Example
```
.\check_ohm_temperatures.ps1 -warning 80 -critical 90
```

## Version history
* 1.1 2016-03-24 Minor cleanup of variables and documentation.
* 1.0 2016-03-11 Initial release.


___

Licensed under the [__Apache License Version 2.0__](https://www.apache.org/licenses/LICENSE-2.0)

Written by __farid@joubbi.se__

http://www.joubbi.se/monitoring.html

