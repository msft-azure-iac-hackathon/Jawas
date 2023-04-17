[CmdletBinding()]
Param (
    [Parameter(Mandatory = $true)]
    [string]$ParameterFile,

    [Parameter(Mandatory = $true)]
    [string]$TemplateParameterFile,

    [Parameter(Mandatory = $true)]
    [string]$TemplateFile,

    [Parameter(ParameterSetName = 'Lint')]
    [switch] $Lint,

    [Parameter(ParameterSetName = 'Preview')]
    [switch] $Preview,

    [Parameter(ParameterSetName = 'WhatIf')]
    [switch] $WhatIf,

    [Parameter(ParameterSetName = 'Deploy')]
    [switch] $Deploy,

    [Parameter(Mandatory = $true)]
    [ValidateSet('Prod', 'Dev')][string]$Environment
)

# Get parameters for the current environment (Prod/Dev) from the parameter file
$envParameters = (Get-Content $ParameterFile -Raw | ConvertFrom-Json -Depth 10).$Environment

Write-Host 'Connect using EA SPN'
$secureEaSpnPassword = (Get-AzKeyVaultSecret -VaultName $envParameters.KeyvaultName -Name $envParameters.EAEnrollmentSpn.ApplicationId).SecretValue
$eaSpnCredential = [pscredential]::new($envParameters.EAEnrollmentSpn.ApplicationId, $secureEaSpnPassword)
Connect-AzAccount -Credential $eaSpnCredential -ServicePrincipal -tenantid $envParameters.TenantId
#$eaAzContext = Get-AzContext

$utcNow = [datetime]::UtcNow.ToString('yyyyMMddHHmmss')

if ($Lint.IsPresent) {
    $armFilePath = "$PSScriptRoot/arm"
    if (!(Test-Path -Path $armFilePath)) {
        $null = New-Item -Path $armFilePath -Force -ItemType Directory
    }

    bicep build $BicepFile --outdir "$PSScriptRoot/arm"
}

if ($Preview.IsPresent) {

}

if ($WhatIf.IsPresent) {
    New-AzTenantDeployment `
        -Location westeurope `
        -TemplateParameterFile $TemplateParameterFile `
        -TemplateFile $TemplateFile `
        -Name "managementgroups-$($utcNow)" `
        -WhatIf
}

if ($Deploy.IsPresent) {

}

New-AzManagementGroupDeployment `
    -ManagementGroupId $ManagementGroupId `
    -Location westeurope `
    -TemplateParameterFile $TemplateParameterFile `
    -TemplateFile $TemplateFile `
    -Name "$($ManagementGroupId.ToLower())-policies-$($utcNow)"