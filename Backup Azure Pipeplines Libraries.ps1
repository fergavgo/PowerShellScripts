<# 
Antes de ejecutar este script, tener en cuenta:
        
        1. Este Script requiere que se tenga Instalado Azure CLI
        https://learn.microsoft.com/en-us/cli/azure/install-azure-cli
        
        2. Despues de estar instalado, iniciar sesión en PowerShell usando:
        az devops login --org https://dev.azure.com/MiOrganizacion
        (Aqui va a solicitarse un PAT de Azure. Puede ser de sólo lectura si 
        van a hacerse unicamente tareas como backups)
        
        3. Se requiere configurar, idealmente, la organización y
        el proyecto de Azure DevOps con los que se va a trabajar:

        az devops configure --defaults project="NOMBRE DEL PROYECTO"
        az devops configure --defaults organization=https://dev.azure.com/MiOrganizacion        
        
        Hacer esta configuración facilita la ejecución de los comandos 
        que se muestran más adelante. De no hacerlo, habrá que especificar
        la organización y el proyecto en cada linea de comando que usa az
        
        Para limpiar los valores por defecto, se pueden usar ''
        Por ejemplo: az devops configure --defaults project=''

        4. Finalmente, deberan definirse las rutas en las cuales se dejará cada tipo de archivo
        usando las siguientes variables:
#>
az devops configure --defaults organization=https://dev.azure.com/MyOrganization
az devops configure --defaults project="My Project"
$BACKUPBUILDS='B:\Azure DevOps\backup_pipelines\build'
$BACKUPRELEASES='B:\Azure DevOps\backup_pipelines\release'
$BACKUPVARIABLES='B:\Azure DevOps\backup_pipelines\variable_groups'

<#
       BACKUP DE BUILD PIPELINES
       Se guarda en $pipelines el listado de los pipelines del proyecto
#>
$pipelinesbuild = az pipelines list | ConvertFrom-Json

<#
       Se puede filtrar solo los pipelines que interesan (se quitan los de SonarQube
       y uno de Prueba por ejemplo).
       Se comenta el filtro porque no se requiere hacer filtrado, sino respaldar 
       todos los Pipelines.
#>
$aexportar = $pipelinesbuild | Select-Object id,name # |Where-Object name -NotLike "Sonar*" |Where-Object name -NotLike "Prueba"|Select-Object id,name # |Out-File -FilePath D:\archivo.txt

foreach ($loop_pipeline in $aexportar.name)
{
    Write-Output "Respaldando $loop_pipeline"
    az pipelines show --name $loop_pipeline | Out-File $BACKUPBUILDS\$loop_pipeline.json
}



<#       BACKUP DE VARIABLE GROUPS

 Se captura los actuales grupos de variables en Azure dentro de la variable $variable_groups 
 #>
$variable_groups = az pipelines variable-group list | ConvertFrom-Json
$variable_groups = $variable_groups |Select-Object id,name

foreach($id in $variable_groups.id)
{
    $variable_groups |Where-Object id -eq $id |Select-Object name -First 1 | Format-Table -HideTableHeaders |Out-File -FilePath C:\Users\Public\variable_group
    $variable_group_name = (Get-Content -Path C:\Users\Public\variable_group | Select-Object -Skip 1 | Out-String).trim()
    Write-Output "Respaldando $variable_group_name"
    az pipelines variable-group show --id $id |  Out-File $BACKUPVARIABLES\$variable_group_name.json
}

<#
    Nota:
    A la fecha de creación de este script, Microsoft no dispone de una forma 
    directa de importar las variables directamente a Azure
    Se deja enlace con posible forma de importacion:
    https://stackoverflow.com/questions/65710256/how-to-create-azure-devops-library-variable-group-using-the-data-from-json-csv-f
#>



<#
        BACKUP DE RELEASE PIPELINES
        Se guarda en $pipelines el listado de los pipelines del proyecto
#>
$pipelinesrelease = az pipelines release definition list | ConvertFrom-Json
$pipelinesrelease = $pipelinesrelease |Select-Object id,name

foreach($id in $pipelinesrelease.id)
{
    $pipelinesrelease |Where-Object id -eq $id |Select-Object name -First 1 | Format-Table -HideTableHeaders |Out-File -FilePath C:\Users\Public\variable_group
    $pipelinesrelease_name = (Get-Content -Path C:\Users\Public\variable_group | Select-Object -Skip 1 | Out-String).trim()
    Write-Output "Respaldando $pipelinesrelease_name"
    az pipelines release definition show --id $id |  Out-File $BACKUPRELEASES\$pipelinesrelease_name.json
}
