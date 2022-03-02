resource "azurerm_resource_group" "main" {
  name     = local.naming.main_resource_group_name
  location = local.location

  tags = local.default_tags
}

resource "azurerm_app_service_plan" "main" {
  resource_group_name = azurerm_resource_group.main.name
  name                = local.naming.plan_name
  location            = local.location

  kind = "Windows"

  sku {
    tier = var.plan_sku.tier
    size = var.plan_sku.size
  }

  tags = local.default_tags
}

resource "azurerm_app_service" "app_1" {
  name                = local.naming.app_1_name
  location            = local.location
  resource_group_name = azurerm_resource_group.main.name
  app_service_plan_id = azurerm_app_service_plan.main.id

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"               = data.azurerm_application_insights.common.instrumentation_key
    "APP_CONFIG_ENDPOINT"                          = data.azurerm_app_configuration.common.endpoint
    "APP_CONFIG_LABEL"                             = local.app_config_labels.Template
    "APP_CONFIG_LABEL_SHARED"                      = local.app_config_labels.shared
    "AZURE_CLIENT_ID"                              = azurerm_user_assigned_identity.main.client_id
    "Logging:ApplicationInsights:LogLevel:Default" = var.default_log_level
  }

  tags = local.default_tags

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.main.id]
  }

  site_config {
    always_on = true
    scm_type  = ""
    ip_restriction = [
      {
        name                      = "FromApim"
        priority                  = 50
        action                    = "Allow"
        ip_address                = "${data.azurerm_api_management.apim.public_ip_addresses.0}/32"
        headers                   = []
        service_tag               = null
        virtual_network_subnet_id = null
      }
    ]
  }

  https_only = true

  lifecycle {
    ignore_changes = [
      app_settings["WEBSITE_ENABLE_SYNC_UPDATE_SITE"],
      app_settings["WEBSITE_RUN_FROM_PACKAGE"],
    ]
  }
}