# terraform-azure-backend-setup
Sets up an Azure storage account to use for terraform state management

# Reference
[terraform service_principal_client_secret](https://www.terraform.io/docs/providers/azurerm/guides/service_principal_client_secret.html)  
[github action azure login](https://github.com/Azure/login)  

# Setup you service principal
```bash
az login
az account set --subscription="<SUBSCRIPTION_ID>"
az ad sp create-for-rbac --name sp-terraform-subscription-<SUBSCRIPTION_ID>  --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>  -sdk-auth"  

produces.

{
  "clientId": "<GUID>",
  "clientSecret": "<GUID>",
  "subscriptionId": "<GUID>",
  "tenantId": "<GUID>",
  (...)
}
  
```
This will create a service principal, which you can see in AD App Registration that has the rights to create resources in the subscription.  


# Secrets
[project secrets](https://github.com/fluffy-bunny/terraform-azure-backend-setup/settings/secrets)
to use azure login, please follow the following instructions.
[github action azure login](https://github.com/Azure/login)  

As of this writing I have not been able to get terraform to work with azure managed identity.  Service Principals auth works.

The github actions need to set the following environment variables, which are all secrets;
```bash
export ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
export ARM_CLIENT_SECRET="00000000-0000-0000-0000-000000000000"
export ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
export ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"
```

By convention, add the secrets you produced by creating the rbac service principal and add them like you added AZURE_CREDENTIALS.
```
ARM_CLIENT_ID = <GUID>
ARM_CLIENT_SECRET = <GUID>
ARM_SUBSCRIPTION_ID = <GUID>
ARM_TENANT_ID = <GUID>
```  

The [github action](.github/workflows/terraform-tstate-setup.yml) will pull this data from secrets and export it to environment variables.  



