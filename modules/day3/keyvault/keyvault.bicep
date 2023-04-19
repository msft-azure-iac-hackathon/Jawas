param parKeyVaultName string
param parKeyVaultLocation string
param parTenantId string
param parPrivateEndpointConnections string

resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: parKeyVaultName
  location: parKeyVaultLocation
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: parTenantId
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    enableSoftDelete: true
    enableRbacAuthorization: true
  }
}

resource privateEndpointConnections 'Microsoft.KeyVault/vaults/privateEndpointConnections@2023-02-01' = {
  parent: keyVault
  name: parPrivateEndpointConnections
}
