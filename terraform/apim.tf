provider "azurerm" {
  alias                      = "apim"
  subscription_id            = local.specific.apim.subscription_id
  skip_provider_registration = true
  features {}
}

data "azurerm_api_management" "apim" {
  provider            = azurerm.apim
  name                = local.specific.apim.name
  resource_group_name = local.specific.apim.resource_group_name
}

data "azurerm_api_management_api" "apiTemplate" {
  provider            = azurerm.apim
  name                = local.specific.apim.api_name
  api_management_name = local.specific.apim.name
  resource_group_name = local.specific.apim.resource_group_name
  revision            = "1"
}