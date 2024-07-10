param (
    [string]$configFile = "./Config/parameters.json"
)

# Read JSON file and extract values
Write-Host "Read configuration JSON file: $configFile"
$config = Get-Content -Raw -Path $configFile | ConvertFrom-Json
$storageAccount = $config.AZURE_STORAGE_ACCOUNT
$containerName = $config.AZURE_CONTAINER_NAME

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
    az storage container create --account-name $storageAccount --name $containerName
}

Write-Host "Uploading files into the Container $containerName..."
$files = Get-ChildItem -Path "./AppendFiles"
foreach ($file in $files) {
    Write-Host "Uploading the file: $($file.FullName)"
    az storage blob upload --account-name $storageAccount --container-name $containerName --file $file.FullName --name $file.Name --overwrite
}
Write-Host "Operation completed."
