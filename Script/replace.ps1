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


# param (
#     [string]$storageAccount = $env:AZURE_STORAGE_ACCOUNT,
#     [string]$containerName = $env:AZURE_CONTAINER_NAME
# )

# if (-not $containerName) {
#     Write-Host "Error: Missing the container name."
#     exit 1
# }

# # Verifica se il container esiste
# $containerExists = az storage container exists --account-name $storageAccount --name $containerName --query "exists" --output tsv

# if ($containerExists -eq "false") {
#     Write-Host "Il container $containerName non esiste. Creazione del container..."
#     az storage container create --account-name $storageAccount --name $containerName --enable-delete-retention=false
# }

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
# $files = Get-ChildItem -Path "./AppendFiles"
# foreach ($file in $files) {
#     az storage blob upload --account-name $storageAccount --container-name $containerName --file $file.FullName --name $file.Name --overwrite
# }



param (
    [string]$configFile = "./Config/parameters.json"
)

# Read JSON file and extract values
Write-Host "Read configuration JSON file: $configFile"
$config = Get-Content -Raw -Path $configFile | ConvertFrom-Json
$storageAccount = $config.AZURE_STORAGE_ACCOUNT
$containerName = $config.AZURE_CONTAINER_NAME
$softDelete = $config.SOFT_DELETE

# Log of variables
Write-Host "Storage account name: $storageAccount"
Write-Host "Container name: $containerName"

if (-not $containerName) {
    Write-Host "Error: Missing container name."
    exit 1
}

Write-Host "Check if container $containerName exists..."
$containerExists = az storage container exists --account-name $storageAccount --name $containerName --query "exists" --output tsv
Write-Host "Result of check: $containerExists"

if ($containerExists -eq "false") {
    Write-Host "The container $containerName not exists. Container creation..."
    az storage container create --account-name $storageAccount --name $containerName --enable-container-delete-retention $softDelete
}

# if ($containerExists -eq "false") {
#     Write-Host "Il container $containerName non esiste. Creazione del container..."
#     az storage container create --account-name $storageAccount --name $containerName --enable-delete-retention=false
# }


Write-Host "Uploading files into the Container $containerName..."
$files = Get-ChildItem -Path "./AppendFiles"
foreach ($file in $files) {
    Write-Host "Uploading the file: $($file.FullName)"
    az storage blob upload --account-name $storageAccount --container-name $containerName --file $file.FullName --name $file.Name --overwrite
}
Write-Host "Operation completed."
