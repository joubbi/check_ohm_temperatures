# check_ohm_temperatures

This is a PowerShell script used by NSClient++ to check the temperatures on a host running Windows. NSClient++ can then be called by Nagios (Op5 Monitor, Icinga or similar) to run this script.

Open Hardware Monitor (openhardwaremonitor.org) is used as a driver for the temperature sensors. Open Hardware monitor creates WMI objects of all the found sensors. This script retrieves the temperatures from those WMI objects. This means that you have to download and run OpenHardwareMonitor.exe before running this check.

All the found temperatures will be output as performance data so that they can be graphed.

Define the command in nsclient++:
```sh
cmd /c echo scripts\custom\check_temperatures.ps1 -warning $ARG1$ -critical $ARG2$; exit($lastexitcode) | powershell.exe -command -
```
or you can omit or hard code the warning and critical arguments in case you do not permit sending arguments to nsclient.

### Example
```sh
.\check_ohm_temperatures.ps1 -warning 80 -critical 90
```

Licensed under the Apache license version 2. Written by farid.joubbi@consign.se