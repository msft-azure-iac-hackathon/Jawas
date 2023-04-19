param parStorageAccountName string
param parLocation string = 'westeurope'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: parStorageAccountName
  location: parLocation
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}
