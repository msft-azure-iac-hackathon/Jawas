param parKeyVaultName string
param parKeyVaultLocation string
param parTenantId string
param parUAMI string

resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: parKeyVaultName
  location: parKeyVaultLocation
  properties: {
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    tenantId: parTenantId
    accessPolicies: [
      {
        tenantId: parTenantId
        objectId: parUAMI
        permissions: {
          keys: [
            'get'
          ]
          secrets: [
            'list'
            'get'
          ]
        }
      }
    ]
    sku: {
      name: 'standard'
      family: 'A'
    }
  }
}
