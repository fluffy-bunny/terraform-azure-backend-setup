az_resource_group_location = "eastus2"
az_resource_group_name = "rg-heidi"
az_storage_account_name = "stazfuncheidi"
az_plan = "plan-funcheidi"
az_app_insights = "appis-funcheidi"
az_func_name = "azfunc-funcheidi"

# export ARM_ACCESS_KEY=$(az keyvault secret show --name terraform-backend-key --vault-name kv-tf-heidi --query value -o tsv)