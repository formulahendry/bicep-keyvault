param resourceBaseName string
param frontendHosting_storageName string = 'frontendstg${uniqueString(resourceBaseName)}'
param m365ClientId string
@secure()
param m365ClientSecret string
param m365TenantId string
param m365OauthAuthorityHost string
param function_serverfarmsName string = '${resourceBaseName}-function-serverfarms'
param function_webappName string = '${resourceBaseName}-function-webapp'
param function_storageName string = 'functionstg${uniqueString(resourceBaseName)}'
param apimServiceName string = '${resourceBaseName}-apim-service'
param apimOauthServerName string = '${resourceBaseName}-apim-oauthserver'
param apimProductName string = '${resourceBaseName}-apim-product'
param apimClientId string
@secure()
param apimClientSecret string
param apimPublisherEmail string
param apimPublisherName string
param simpleAuth_sku string = 'F1'
param simpleAuth_serverFarmsName string = '${resourceBaseName}-simpleAuth-serverfarms'
param simpleAuth_webAppName string = '${resourceBaseName}-simpleAuth-webapp'
param simpleAuth_packageUri string = 'https://github.com/OfficeDev/TeamsFx/releases/download/simpleauth@0.1.0/Microsoft.TeamsFx.SimpleAuth_0.1.0.zip'

var m365ApplicationIdUri = 'api://${frontendHostingProvision.outputs.domain}/${m365ClientId}'

module frontendHostingProvision './modules/frontendHostingProvision.bicep' = {
  name: 'frontendHostingProvision'
  params: {
    frontendHostingStorageName: frontendHosting_storageName
  }
}
module functionProvision './modules/functionProvision.bicep' = {
  name: 'functionProvision'
  params: {
    functionAppName: function_webappName
    functionServerfarmsName: function_serverfarmsName
    functionStorageName: function_storageName
  }
}
module functionConfiguration './modules/functionConfiguration.bicep' = {
  name: 'functionConfiguration'
  dependsOn: [
    functionProvision
  ]
  params: {
    functionAppName: function_webappName
    functionStorageName: function_storageName
    m365ClientId: m365ClientId
    m365ClientSecret: m365ClientSecret
    m365TenantId: m365TenantId
    m365ApplicationIdUri: m365ApplicationIdUri
    m365OauthAuthorityHost: m365OauthAuthorityHost
    frontendHostingStorageEndpoint: frontendHostingProvision.outputs.endpoint
  }
}
module apimProvision './modules/apimProvision.bicep' = {
  name: 'apimProvision'
  params: {
    apimServiceName: apimServiceName
    productName: apimProductName
    publisherEmail: apimPublisherEmail
    publisherName: apimPublisherName
    oauthServerName: apimOauthServerName
    clientId: apimClientId
    clientSecret: apimClientSecret
    m365TenantId: m365TenantId
    m365ApplicationIdUri:m365ApplicationIdUri
    m365OauthAuthorityHost: m365OauthAuthorityHost
  }
}
module simpleAuthProvision './modules/simpleAuthProvision.bicep' = {
  name: 'simpleAuthProvision'
  params: {
    simpleAuthServerFarmsName: simpleAuth_serverFarmsName
    simpleAuthWebAppName: simpleAuth_webAppName
    sku: simpleAuth_sku
  }
}
module simpleAuthConfiguration './modules/simpleAuthConfiguration.bicep' = {
  name: 'simpleAuthConfiguration'
  dependsOn: [
    simpleAuthProvision
  ]
  params: {
    simpleAuthWebAppName: simpleAuth_webAppName
    m365ClientId: m365ClientId
    m365ClientSecret: m365ClientSecret
    m365ApplicationIdUri: m365ApplicationIdUri
    frontendHostingStorageEndpoint: frontendHostingProvision.outputs.endpoint
    m365TenantId: m365TenantId
    oauthAuthorityHost: m365OauthAuthorityHost
    simpleAuthPackageUri: simpleAuth_packageUri
  }
}

output frontendHosting_storageResourceId string = frontendHostingProvision.outputs.resourceId
output frontendHosting_endpoint string = frontendHostingProvision.outputs.endpoint
output frontendHosting_domain string = frontendHostingProvision.outputs.domain
output function_functionEndpoint string = functionProvision.outputs.functionEndpoint
output function_appResourceId string = functionProvision.outputs.functionAppResourceId
output apimServiceResourceId string = apimProvision.outputs.serviceResourceId
output apimProductResourceId string = apimProvision.outputs.productResourceId
output apimAuthServiceResourceId string = apimProvision.outputs.authServiceResourceId
output simpleAuth_skuName string = simpleAuthProvision.outputs.skuName
output simpleAuth_endpoint string = simpleAuthProvision.outputs.endpoint
output simpleAuth_webAppName string = simpleAuthProvision.outputs.webAppName
output simpleAuth_appServicePlanName string = simpleAuthProvision.outputs.appServicePlanName