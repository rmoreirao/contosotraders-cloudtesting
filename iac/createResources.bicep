// common
targetScope = 'resourceGroup'

// parameters
////////////////////////////////////////////////////////////////////////////////

// common
@minLength(3)
@maxLength(6)
@description('A unique environment suffix (max 6 characters, alphanumeric only).')
param suffix string

@secure()
@description('A password which will be set on all SQL Azure DBs.')
param sqlPassword string // @TODO: Obviously, we need to fix this!

param resourceLocation string = resourceGroup().location

// tenant
param tenantId string = subscription().tenantId

// aks
param aksLinuxAdminUsername string // value supplied via parameters file

param prefix string = 'contosotraders'

param prefixHyphenated string = 'contoso-traders'

// sql
param sqlServerHostName string = environment().suffixes.sqlServerHostname

// use param to conditionally deploy private endpoint resources
param deployPrivateEndpoints bool = false

// variables
////////////////////////////////////////////////////////////////////////////////

// key vault
var kvName = '${prefix}kv${suffix}'
var kvSecretNameProductsApiEndpoint = 'productsApiEndpoint'
var kvSecretNameProductsDbConnStr = 'productsDbConnectionString'
var kvSecretNameProfilesDbConnStr = 'profilesDbConnectionString'
var kvSecretNameStocksDbConnStr = 'stocksDbConnectionString'
var kvSecretNameCartsApiEndpoint = 'cartsApiEndpoint'
var kvSecretNameCartsInternalApiEndpoint = 'cartsInternalApiEndpoint'
var kvSecretNameCartsDbConnStr = 'cartsDbConnectionString'
var kvSecretNameImagesEndpoint = 'imagesEndpoint'
var kvSecretNameAppInsightsConnStr = 'appInsightsConnectionString'
var kvSecretNameUiCdnEndpoint = 'uiCdnEndpoint'
var kvSecretNameVnetAcaSubnetId = 'vnetAcaSubnetId'

// user-assigned managed identity (for key vault access)
var userAssignedMIForKVAccessName = '${prefixHyphenated}-mi-kv-access${suffix}'

// cosmos db (stocks db)
var stocksDbAcctName = '${prefixHyphenated}-stocks${suffix}'
var stocksDbName = 'stocksdb'
var stocksDbStocksContainerName = 'stocks'

// cosmos db (carts db)
var cartsDbAcctName = '${prefixHyphenated}-carts${suffix}'
var cartsDbName = 'cartsdb'
var cartsDbStocksContainerName = 'carts'

// app service plan (products api)
var productsApiAppSvcPlanName = '${prefixHyphenated}-products${suffix}'
var productsApiAppSvcName = '${prefixHyphenated}-products${suffix}'
var productsApiSettingNameKeyVaultEndpoint = 'KeyVaultEndpoint'
var productsApiSettingNameManagedIdentityClientId = 'ManagedIdentityClientId'

// sql azure (products db)
var productsDbServerName = '${prefixHyphenated}-products${suffix}'
var productsDbName = 'productsdb'
var productsDbServerAdminLogin = 'localadmin'
var productsDbServerAdminPassword = sqlPassword

// sql azure (profiles db)
var profilesDbServerName = '${prefixHyphenated}-profiles${suffix}'
var profilesDbName = 'profilesdb'
var profilesDbServerAdminLogin = 'localadmin'
var profilesDbServerAdminPassword = sqlPassword

// azure container app (carts api)
var cartsApiAcaName = '${prefixHyphenated}-carts${suffix}'
var cartsApiAcaEnvName = '${prefix}acaenv${suffix}'
var cartsApiAcaSecretAcrPassword = 'acr-password'
var cartsApiAcaContainerDetailsName = '${prefixHyphenated}-carts${suffix}'
var cartsApiSettingNameKeyVaultEndpoint = 'KeyVaultEndpoint'
var cartsApiSettingNameManagedIdentityClientId = 'ManagedIdentityClientId'

// azure container app (carts api - internal only)
var cartsInternalApiAcaName = '${prefixHyphenated}-intcarts${suffix}'
var cartsInternalApiAcaEnvName = '${prefix}intacaenv${suffix}'
var cartsInternalApiAcaSecretAcrPassword = 'acr-password'
var cartsInternalApiAcaContainerDetailsName = '${prefixHyphenated}-intcarts${suffix}'
var cartsInternalApiSettingNameKeyVaultEndpoint = 'KeyVaultEndpoint'
var cartsInternalApiSettingNameManagedIdentityClientId = 'ManagedIdentityClientId'

// storage account (product images)
var productImagesStgAccName = '${prefix}img${suffix}'
var productImagesProductDetailsContainerName = 'product-details'
var productImagesProductListContainerName = 'product-list'

// storage account (old website)
var uiStgAccName = '${prefix}ui${suffix}'

// storage account (new website)
var ui2StgAccName = '${prefix}ui2${suffix}'

// storage account (image classifier)
var imageClassifierStgAccName = '${prefix}ic${suffix}'
var imageClassifierWebsiteUploadsContainerName = 'website-uploads'

// cdn
var cdnProfileName = '${prefixHyphenated}-cdn${suffix}'
var cdnImagesEndpointName = '${prefixHyphenated}-images${suffix}'
var cdnUiEndpointName = '${prefixHyphenated}-ui${suffix}'
var cdnUi2EndpointName = '${prefixHyphenated}-ui2${suffix}'

// azure container registry
var acrName = '${prefix}acr${suffix}'

// load testing service
var loadTestSvcName = '${prefixHyphenated}-loadtest${suffix}'

// application insights
var logAnalyticsWorkspaceName = '${prefixHyphenated}-loganalytics${suffix}'
var appInsightsName = '${prefixHyphenated}-ai${suffix}'

// portal dashboard
var portalDashboardName = '${prefixHyphenated}-dashboard${suffix}'

// aks cluster
var aksClusterName = '${prefixHyphenated}-aks${suffix}'
var aksClusterDnsPrefix = '${prefixHyphenated}-aks${suffix}'
var aksClusterNodeResourceGroup = '${prefixHyphenated}-aks-nodes-rg${suffix}'

// virtual network
var vnetName = '${prefixHyphenated}-vnet${suffix}'
var vnetAddressSpace = '10.0.0.0/16'
var vnetAcaSubnetName = 'subnet-aca'
var vnetAcaSubnetAddressPrefix = '10.0.0.0/23'
var vnetVmSubnetName = 'subnet-vm'
var vnetVmSubnetAddressPrefix = '10.0.2.0/23'
var vnetLoadTestSubnetName = 'subnet-loadtest'
var vnetLoadTestSubnetAddressPrefix = '10.0.4.0/23'

// jumpbox vm
var jumpboxPublicIpName = '${prefixHyphenated}-jumpbox${suffix}'
var jumpboxNsgName = '${prefixHyphenated}-jumpbox${suffix}'
var jumpboxNicName = '${prefixHyphenated}-jumpbox${suffix}'
var jumpboxVmName = 'jumpboxvm'
var jumpboxVmAdminLogin = 'localadmin'
var jumpboxVmAdminPassword = sqlPassword
var jumpboxVmShutdownSchduleName = 'shutdown-computevm-jumpboxvm'
var jumpboxVmShutdownScheduleTimezoneId = 'UTC'

// private dns zone
var privateDnsZoneVnetLinkName = '${prefixHyphenated}-privatednszone-vnet-link${suffix}'

// chaos studio
var chaosKvExperimentName = '${prefixHyphenated}-chaos-kv-experiment${suffix}'
var chaosKvSelectorId = guid('${prefixHyphenated}-chaos-kv-selector-id${suffix}')
var chaosAksExperimentName = '${prefixHyphenated}-chaos-aks-experiment${suffix}'
var chaosAksSelectorId = guid('${prefixHyphenated}-chaos-aks-selector-id${suffix}')

// tags
var resourceTags = {
  Product: prefixHyphenated
  Environment: suffix
}

// resources
////////////////////////////////////////////////////////////////////////////////

//
// key vault
//

//
// product images
//

// storage account (product images)
resource productimagesstgacc 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: productImagesStgAccName
  location: resourceLocation
  tags: resourceTags
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    allowBlobPublicAccess: true
  }

  // blob service
  resource productimagesstgacc_blobsvc 'blobServices' = {
    name: 'default'

    // container
    resource productimagesstgacc_blobsvc_productdetailscontainer 'containers' = {
      name: productImagesProductDetailsContainerName
      properties: {
        publicAccess: 'Container'
      }
    }

    // container
    resource productimagesstgacc_blobsvc_productlistcontainer 'containers' = {
      name: productImagesProductListContainerName
      properties: {
        publicAccess: 'Container'
      }
    }
  }
}

// //
// // main website / ui
// // new website / ui
// //

// // storage account (main website)
// resource uistgacc 'Microsoft.Storage/storageAccounts@2022-09-01' = {
//   name: uiStgAccName
//   location: resourceLocation
//   tags: resourceTags
//   sku: {
//     name: 'Standard_LRS'
//   }
//   kind: 'StorageV2'
//   properties: {
//     allowBlobPublicAccess: true
//   }

//   // blob service
//   resource uistgacc_blobsvc 'blobServices' = {
//     name: 'default'
//   }
// }

// // storage account (new website)
// resource ui2stgacc 'Microsoft.Storage/storageAccounts@2022-05-01' = {
//   name: ui2StgAccName
//   location: resourceLocation
//   tags: resourceTags
//   sku: {
//     name: 'Standard_LRS'
//   }
//   kind: 'StorageV2'
//   properties: {
//     allowBlobPublicAccess: true
//   }

//   // blob service
//   resource ui2stgacc_blobsvc 'blobServices' = {
//     name: 'default'
//   }
// }


// //
// // image classifier
// //

// // storage account (main website)
// resource imageclassifierstgacc 'Microsoft.Storage/storageAccounts@2022-09-01' = {
//   name: imageClassifierStgAccName
//   location: resourceLocation
//   tags: resourceTags
//   sku: {
//     name: 'Standard_LRS'
//   }
//   properties: {
//     allowBlobPublicAccess: true
//   }
//   kind: 'StorageV2'
  

//   // blob service
//   resource imageclassifierstgacc_blobsvc 'blobServices' = {
//     name: 'default'

//     // container
//     resource uistgacc_blobsvc_websiteuploadscontainer 'containers' = {
//       name: imageClassifierWebsiteUploadsContainerName
//       properties: {
//         publicAccess: 'Container'
//       }
//     }
//   }
// }

//
// cdn
//
