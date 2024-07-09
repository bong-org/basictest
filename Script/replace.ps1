param (
    [string]$storageAccount = $env:AZURE_STORAGE_ACCOUNT,
    [string]$containerName = $env:AZURE_CONTAINER_NAME
)

# Verifica se il container esiste
$containerExists = az storage container exists --account-name $storageAccount --name $containerName --query exists

if ($containerExists -eq $false) {
    $createContainer = Read-Host "This container $containerName not exists. Do you want create? (y/n)"
    if ($createContainer -eq "y") {
        az storage container create --account-name $storageAccount --name $containerName
    } else {
        Write-Host "Operation aborted."
        exit
    }
}

# Append file al container
$files = Get-ChildItem -Path "./AppendFiles"
foreach ($file in $files) {
    az storage blob upload --account-name $storageAccount --container-name $containerName --file $file.FullName --name $file.Name
}
