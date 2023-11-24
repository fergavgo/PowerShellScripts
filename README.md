# PowerShell Scripts <a href="https://learn.microsoft.com/es-es/powershell/?view=powershell-7.3" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/gist/Xainey/d5bde7d01dcbac51ac951810e94313aa/raw/6c858c46726541b48ddaaebab29c41c07a196394/PowerShell.svg" alt="PowerShell" width="25" height="25"/></a>
Useful PowerShell Scripts for several scenarios


# Backup to Git
This script compress several folders (backup folders in this case, with database backups in the inside) and send the zip files to a Git repository.
I don't recommend to use this in production, since it requires a token and could be exposed. Use with caution.


# Monitor RAM CPU AppPool
This script get the IIS's AppPools status (memory and CPU) and take it to a log file.


# Backup Azure Pipelines and Libraries
This one, generates a backup to yaml files or json files from every Azure's Pipeline you created with the classic assistant. Addicionally, it creates a backup for each library (variable group) you select.


# IIS Pending Requests
This is just a While loop that shows you the pending requests the APIs have to attend right now. It refreshes every 5 seconds.