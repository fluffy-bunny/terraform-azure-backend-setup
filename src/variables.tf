variable "az_resource_group_name" {
  description = "(Required) The name of the resource group where resources will be created."
  type        = string
}

variable "az_resource_group_location" {
  description = "(Required) The location where the resource group will reside."
  type        = string
}

variable "az_storage_account_name" {
  description = "(Required) The storage account name."
  type        = string
}

variable "az_plan" {
  description = "(Required) az_plan."
  type        = string
}
variable "az_app_insights" {
  description = "(Required) az_app_insights."
  type        = string
}
variable "az_func_name" {
  description = "(Required) az_func_name."
  type        = string
}


variable "tags" {
  description = "Tags to help identify various services."
  type        = map
  default = {
    DeployedBy     = "terraform"
    Environment    = "prod"
    OwnerEmail     = "DL-P7-OPS@p7.com"
    Platform       = "na" # does not apply to us.
  }
}