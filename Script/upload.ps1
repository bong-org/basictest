param (
    [string]$configFile = "./Config/parameters.json"
)

# Read JSON file and extract values
Write-Host "Read configuration JSON file: $configFile"
$config = Get-Content -Raw -Path $configFile | ConvertFrom-Json
$storageAccount = $config.AZURE_STORAGE_ACCOUNT
$containerName = $config.AZURE_CONTAINER_NAME
$createContainerIfNotExists = $config.CREATE_CONTAINER_IF_NOT_EXISTS

# Log of variables
Write-Host "Storage account name: $storageAccount"
Write-Host "Container name: $containerName"
Write-Host "Create container if it does not exist: $createContainerIfNotExists"

if (-not $containerName) {
    Write-Host "Error: Missing container name."
    exit 1
}

Write-Host "Check if container $containerName exists..."
$containerExists = az storage container exists --account-name $storageAccount --name $containerName --query "exists" --output tsv
Write-Host "Result of check: $containerExists"

if ($containerExists -eq "false") {
    if ($createContainerIfNotExists -eq $true) {
        Write-Host "The container $containerName not exists. Container creation..."
        az storage container create --account-name $storageAccount --name $containerName
    } else {
        Write-Host "Error: The container $containerName not exists and the automatic creation is disabled."
        exit 1
    }
}


Write-Host "Uploading files into the Container $containerName..."
$files = Get-ChildItem -Path $inputFolder
foreach ($file in $files) {
    Write-Host "Uploading the file: $($file.FullName)"
    az storage blob upload --account-name $storageAccount --container-name $containerName --file $file.FullName --name $file.Name --overwrite
}
Write-Host "Operation completed."
