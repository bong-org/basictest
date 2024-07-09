# param (
#     [string]$storageAccount = $env:AZURE_STORAGE_ACCOUNT,
#     [string]$containerName = $env:AZURE_CONTAINER_NAME
# )

# # Verifica se il container esiste
# $containerExists = az storage container exists --account-name $storageAccount --name $containerName --query exists

# if ($containerExists -eq $false) {
#     $createContainer = Read-Host "This container $containerName not exists. Do you want create? (y/n)"
#     if ($createContainer -eq "y") {
#         az storage container create --account-name $storageAccount --name $containerName
#     } else {
#         Write-Host "Operation aborted."
#         exit
#     }
# }

# # Append file al container
# $files = Get-ChildItem -Path "./AppendFiles"
# foreach ($file in $files) {
#     az storage blob upload --account-name $storageAccount --container-name $containerName --file $file.FullName --name $file.Name --overwrite
# }


param (
    [string]$storageAccount = $env:AZURE_STORAGE_ACCOUNT,
    [string]$containerName = $env:AZURE_CONTAINER_NAME
)

if (-not $containerName) {
    Write-Host "Error: Missing the container name."
    exit 1
}

# Verifica se il container esiste
$containerExists = az storage container exists --account-name $storageAccount --name $containerName --query "exists" --output tsv

if ($containerExists -eq "false") {
    Write-Host "Il container $containerName non esiste. Creazione del container..."
    az storage container create --account-name $storageAccount --name $containerName
}

# if ($containerExists -eq "false") {
#     $createContainer = Read-Host "Il container $containerName non esiste. Vuoi crearlo? (s/n)"
#     if ($createContainer -eq "s") {
#         az storage container create --account-name $storageAccount --name $containerName
#     } else {
#         Write-Host "Operazione annullata."
#         exit
#     }
# }

# Append file al container con sovrascrittura
$files = Get-ChildItem -Path "./AppendFiles"
foreach ($file in $files) {
    az storage blob upload --account-name $storageAccount --container-name $containerName --file $file.FullName --name $file.Name --overwrite
}
