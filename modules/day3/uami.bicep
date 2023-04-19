param parUAMI string
param parUAMILocation string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: parUAMI
  location: parUAMILocation
}
