# Publish Teams Backend (Azure Functions) to Azure API Management

Azure API Management (APIM) is used to create consistent and modern API gateways for existing backend services. With Teams Toolkit or TeamsFx CLI, you can easily publish your backend APIs (Azure Functions) to existing or new APIM instance.

## Prerequisite

- [Node.js](https://nodejs.org/en/)
- An M365 account, if you do not have an M365 account, apply one from [M365 developer program](https://developer.microsoft.com/en-us/microsoft-365/dev-program)
- An Azure account with an active subscription, [create an account for free](https://azure.microsoft.com/en-us/free/)
  - Ensure the resource provider 'Microsoft.ApiManagement' is registered for the subscription by following [this document](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/error-register-resource-provider#solution-3---azure-portal)
- Teams Toolkit Extension for Visual Studio Code or TeamsFx CLI

## Enable API Management Feature in TeamsFx

> Publish APIs to APIM requires Azure Functions in your project. If your project does not include Azure Functions, please note that we will automatically add one for you. Read about [Azure Functions in TeamsFx](https://github.com/OfficeDev/TeamsFx/tree/main/templates/function-base/js/default#readme) to learn more.

You can enable Azure API Management by following steps:
| Using Teams Toolkit| Using TeamsFx CLI|
| :------------------| :----------------|
| <ul><li>Open Teams Toolkit, and sign into Azure by clicking the `Sign in to Azure` under the `ACCOUNTS` section from sidebar.<sup>\*</sup></li><li>After you signed in, select a subscription under your account.<sup>\*</sup></li><li>Open command palette, select `Teams: Add Resources` and select `Register APIs in Azure API Management` in next step.</ul> | <ul><li>Run command `teamsfx account login azure`.<sup>\*</sup></li><li>Run command `teamsfx account set --subscription $subscriptionId`.<sup>\*</sup></li><li>Create a new API Management instance or use an existing API Management instance</li><ul><li>Create a new instance: Run command `teamsfx resource add azure-apim`.</li><li>Use an existing instance: Run command `teamsfx resource add azure-apim --apim-resource-group $resourceGroupName --apim-service-name $serviceName`.</li></ul></ul>|

> \* Skip this step if you have already done in the previous steps.

> Note: We need your Azure account and subscription information here so you can specify whether to use an existing or new APIM instance.

## Deploy to Azure

Simply deploy your project to the cloud when it’s ready by following these steps:

- Login to Azure account<sup>\*</sup>
- Login to M365 account<sup>\*</sup>
- Set an active subscription<sup>\*</sup>
- Provision the resources in the cloud
- Deploy to the cloud

You can do this using the Teams Toolkit in Visual Studio Code or using the TeamsFx CLI:
| Using Teams Toolkit| Using TeamsFx CLI|
| :------------------| :----------------|
| <ul><li>Open Teams Toolkit, and sign into Azure by clicking the `Sign in to Azure` under the `ACCOUNTS` section from sidebar.<sup>\*</sup></li> <li>After you signed in, select a subscription under your account.<sup>\*</sup></li><li>Open Teams Toolkit, and sign into M365 by clicking the `Sign in to M365` under the `ACCOUNTS` section from sidebar.<sup>\*</sup></li><li>Open the command palette and select: `Teams: Provision in the cloud`.</li><li>Open the command palette and select: `Teams: Deploy to the cloud`.</li></ul> |<ul> <li>Run command `teamsfx account login azure`.<sup>\*</sup></li> <li>Run command `teamsfx account set --subscription $subscriptionId`.<sup>\*</sup></li> <li>Run command `teamsfx account login m365`.<sup>\*</sup></li> <li> Run command `teamsfx provision`.</li> <li>First-time: Run command `teamsfx deploy function apim --open-api-document openapi/openapi.json --api-prefix $apiPrefix --api-version $apiVersion`. </li><li>Non-first-time: Run command `teamsfx deploy function apim --api-version $apiVersion`. </li></ul>|

> \* Skip this step if you have already done in the previous steps.

In the deployment step, there will be some inputs needed:

- Select the resource `API Management`. The resource `Azure Function` should also be selected if the API changes have never been deployed to the cloud.
- The OpenAPI Specification File (Default: `openapi/openapi.json`).
- Input API prefix. The API path will be `$apiPrefix-$resourceSuffix`. The API Name will be `$apiPrefix-$resourceSuffix-$apiVersion`.
- Select an existing API version or input a new API version.

> Note: This may incur costs in your Azure Subscription if you choose to create a new instance in pervious step.

## Write OpenAPI Document

We support both yaml and json format for the OpenAPI document. You need to follow the [OpenAPI Specification](https://swagger.io/resources/open-api/), author the OpenAPI document and ensure the API schema is aligned with the Azure Functions HTTP trigger implementation.

Below is a sample swagger file for the default HTTP trigger function. You can copy the content into `./openapi/openapi.json`, and change the content according to your modification (E.g. `/getUserProfile` -> `/$yourFunctionName` ).

```json
{
  "openapi": "3.0.1",
  "info": {
    "title": "{appName}",
    "version": "v1"
  },
  "paths": {
    "/getUserProfile": {
      "get": {
        "summary": "Get User Profile",
        "operationId": "get-user-profile",
        "responses": {
          "200": {
            "description": "200 response",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "properties": {
                    "receivedHTTPRequestBody": {
                      "type": "string"
                    },
                    "userInfoMessage": {
                      "type": "string"
                    },
                    "graphClientMessage": {
                      "type": "object"
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
```

You can use your favorite tool to generate an OpenAPI document, such as [OpenAPI (Swagger) Editor](https://marketplace.visualstudio.com/items?itemName=42Crunch.vscode-openapi) and [swagger-jsdoc](https://github.com/Surnet/swagger-jsdoc/).

## Documentation

Find help in [troubleshooting guide](https://aka.ms/teamsfx-apim-help) if you met any issues.
