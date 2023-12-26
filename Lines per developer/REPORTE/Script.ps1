$ROOT_PATH = "D:\Lines_Report"
$REPOSITORIES = Import-Csv -Path "$ROOT_PATH/REPORTE/REPOS_URL.csv"
$BRANCHES = Import-Csv -Path "$ROOT_PATH/REPORTE/BRANCHES.csv"
$DEVELOPERS = Import-Csv -Path "$ROOT_PATH/REPORTE/DEVELOPERS.csv"

# Crear encabezado en archivo de resultados
Write-Output "name,project,branch,user,lines_add,lines_del,total_lines" | Out-File -FilePath $ROOT_PATH/REPORTE/resultados.csv

foreach ($URL in $REPOSITORIES) {
    $REPO = $URL.name
    $REPO = $REPO.TrimEnd(" ")

    Set-Location $ROOT_PATH
    
    git clone --mirror $URL.url "$ROOT_PATH/$REPO/.git"
    Set-Location "$ROOT_PATH/$REPO/"
    git config --bool core.bare false

    foreach ($BRANCH in $BRANCHES) {
        git checkout $BRANCH.branch_name
        if ($?){
            foreach ($DEV in $DEVELOPERS){
                $DEVNAME = $DEV.name
                $DEVNAME = $DEVNAME.TrimEnd(" ")
                $DEVEMAIL = $DEV.email
                $DEVEMAIL = $DEVEMAIL.TrimEnd(" ")
                $DEVEMAIL = $DEVEMAIL.Replace("@myorganization.com","")
                Write-Output "$($DEVNAME),$($URL.name),$($BRANCH.branch_name),$($DEVEMAIL),"| Out-File -FilePath $ROOT_PATH/REPORTE/resultados.csv -Append -NoNewline
                git log -i --author=$DEVEMAIL --author=$DEVNAME --pretty=tformat: --numstat --since="11 months 21 days" | ..\REPORTE\gawk\bin\awk.exe '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "%s,%s,%s,\n", add, subs, loc }' >> $ROOT_PATH/REPORTE/results.csv
            }
        }
        else {
            Write-Host "The branch doesn't exist"
        }
    }
    Set-Location $ROOT_PATH
}