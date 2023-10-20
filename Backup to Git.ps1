# Este Script hace una copia, en este caso de las bases de datos
# respaldadas por Mongo o SQL en un servidor Windows. 
# La idea es comprimir cada una de las bases de datos exportadas
# y llevar los .zip a un repositorio.

# Se requiere que el computador donde se ejecute cuente
# con 7zip, Git y conexión a Internet 

# DISCLAIMER
# No se recomienda este proceso en ambientes productivos, ya que
# se requiere que un usuario/token queden expuestos en el script.
# Usar con precaución

# Obtener la fecha del hoy
$CurrentDate = Get-Date
$dateString = $currentDate.ToString("yyyy-dd-MM")

# Definir ruta donde está el backup de Mongo o SQL y 
# la ruta donde se van a comprimir las bases de datos.
# Esta ultima ruta también será la carpeta base de Git 

$root_dir = "M:\MongoDBBackup\mongo-db-backup\$dateString"
$git_dir = "G:\MyGitDir\"


# Borrar carpeta en caso de que exista
# Para crearla de nuevo
Remove-Item -Path $git_dir -Recurse -Force

New-Item -Type Directory -Path $git_dir
cd $git_dir


# Obtener cada una de las carpetas que está dentro
# de la carpeta base de backup, para ejecutar ciclo for
$folders = Get-ChildItem -Path $root_dir -Directory

# Con lo anterior, comprimir cada una de las carpetas y
# poner el .zip en la carpeta Git
foreach ($folder in $folders) {
    $sourceFilePath = $folder.FullName
	$destinationFilePath = Join-Path $git_dir "$($folder.BaseName).zip"
    & "C:\Program Files\7-Zip\7z.exe" a -tzip -mx7 $destinationFilePath $sourceFilePath
}

# Iniciar carpeta y enviar archivos a repositorio
cd $git_dir
git init

git checkout -t -b backup

$filesSend = Get-ChildItem -Path $git_dir -File

foreach ($file in $filesSend) {
	git add $file
	git commit -am "Backup $dateString"
	git remote add MyRepo "https://USER:TOKEN@URLOfYourRepo"
	# Ejemplo: https://RobertoM:qwpoeirkldjfalkdfjaf@dev.azure.com/MyOrganization/MyProject/_git/MyRepo
	git branch --set-upstream-to MyRepo/backup # backup aqui es una rama
	git push --set-upstream MyRepo backup -f
}


cd \

Remove-Item -Path $git_dir -Recurse -Force

Get-Date
exit