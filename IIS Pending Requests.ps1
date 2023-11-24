while (1) {

    clear
    Import-Module WebAdministration

    Get-Website | where {$_.name -eq 'YOUR_IIS_WEB_SITE_NAME'} | Get-WebRequest | ` 
    # Where-Object {($_.url -notlike '/api_you_want_to_filter*') -and ($_.url -notlike '/another_api_you_want_to_filter*')} | ` 
    select-object url
    sleep 5
}
