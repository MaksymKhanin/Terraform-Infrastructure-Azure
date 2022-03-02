data "azurerm_client_config" "current" {}

data "azurerm_resources" "app_configuration" {
  type = "Microsoft.AppConfiguration/configurationStores"
  required_tags = {
    "stream"      = "apiTemplate"
    "component"   = "common"
    "environment" = var.environment_name
  }
}

data "azurerm_app_configuration" "common" {
  name                = data.azurerm_resources.app_configuration.resources.0.name
  resource_group_name = split("/", data.azurerm_resources.app_configuration.resources.0.id).4
}

data "azurerm_resources" "auth_app_service" {
  type = "Microsoft.Web/sites"
  required_tags = {
    "stream"      = "apiTemplate"
    "component"   = "common"
    "role"        = "auth"
    "environment" = var.environment_name
  }
}

data "azurerm_app_service" "auth" {
  name                = data.azurerm_resources.auth_app_service.resources.0.name
  resource_group_name = split("/", data.azurerm_resources.auth_app_service.resources.0.id).4
}

######################################################################################################################################
##
##   Application Insights (reference)
##
######################################################################################################################################

data "azurerm_resources" "application_insights" {
  type = "Microsoft.Insights/components"
  required_tags = {
    "stream"      = "apiTemplate"
    "component"   = "common"
    "environment" = var.environment_name
  }
}

data "azurerm_application_insights" "common" {
  name                = data.azurerm_resources.application_insights.resources.0.name
  resource_group_name = split("/", data.azurerm_resources.application_insights.resources.0.id).4
}

data "azurerm_resources" "primary_action_group" {
  type = "Microsoft.Insights/actionGroups"
  required_tags = {
    "stream"      = "apiTemplate"
    "component"   = "common"
    "environment" = var.environment_name
  }
}

data "azurerm_monitor_action_group" "primary_action_group" {
  name                = data.azurerm_resources.primary_action_group.resources.0.name
  resource_group_name = split("/", data.azurerm_resources.primary_action_group.resources.0.id).4
}