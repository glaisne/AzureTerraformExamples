variable "subscriptionId" {}
variable "tenantId" {}

provider "azurerm" {
  features {}
  environment     = "public"
  subscription_id = var.subscriptionId
  tenant_id       = var.tenantId
}