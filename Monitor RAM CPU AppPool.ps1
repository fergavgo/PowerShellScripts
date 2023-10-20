# Este script captura cual es el uso de RAM y
# CPU de las AppPool de IIS. 
# Puede ejecutarse desde el Programador de Tareas de Windows
# cada X minutos o a discreción


$file = (Get-Date).hour
$appCmd = "C:\windows\system32\inetsrv\appcmd.exe"

echo "" >> D:\Scripts\RAM\$file.txt
echo "" >> D:\Scripts\RAM\$file.txt
echo "" >> D:\Scripts\RAM\$file.txt
echo "================================================================================================" >> D:\Scripts\RAM\$file.txt
Get-Date -UFormat %R >> D:\Scripts\RAM\$file.txt
echo "" >> D:\Scripts\RAM\$file.txt
echo "" >> D:\Scripts\RAM\$file.txt
echo "" >> D:\Scripts\RAM\$file.txt

# Listado de aplicaciones de IIS con sus respectivos PID
& $appCmd list wp >> D:\Scripts\RAM\$file.txt
tasklist /FI "IMAGENAME eq w3wp.exe" | ForEach-Object { $_ -replace "=",""} >> D:\Scripts\RAM\$file.txt 



# USO DE CPU

Import-Module WebAdministration
$cpu_cores = (Get-WMIObject Win32_ComputerSystem).NumberOfLogicalProcessors
$proc_pid = dir IIS:\AppPools\APIYOUWANTTOMONITOR\WorkerProcesses\ | Select-Object -expand processId
$proc_path = ((Get-Counter "\Process(*)\ID Process").CounterSamples | ? {$_.RawValue -eq $proc_pid}).Path
$prod_percentage_cpu = [Math]::Round(((Get-Counter ($proc_path -replace "\\id process$","\% Processor Time")).CounterSamples.CookedValue) / $cpu_cores)
echo "" >> E:\Scripts\RAM\CPU_${file}.txt
echo "================================================================================================" >> E:\Scripts\RAM\$file.txt
Get-Date -UFormat %R >> E:\Scripts\RAM\CPU_${file}.txt
echo "APIYOUWANTTOMONITOR" >> E:\Scripts\RAM\CPU_${file}.txt
$prod_percentage_cpu >> E:\Scripts\RAM\CPU_${file}.txt
$proc_pid >> E:\Scripts\RAM\CPU_${file}.txt