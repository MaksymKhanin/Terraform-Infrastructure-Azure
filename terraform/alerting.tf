resource "azurerm_application_insights_web_test" "app_1" {
  name                    = ""
  location                = local.location
  resource_group_name     = data.azurerm_application_insights.common.resource_group_name
  application_insights_id = data.azurerm_application_insights.common.id
  kind                    = "ping"
  frequency               = 300
  timeout                 = 120
  enabled                 = true
  geo_locations           = ["", ""]
  retry_enabled           = true
  

  tags = merge(local.default_tags, {
    "hidden-link:${data.azurerm_application_insights.common.id}" = "Resource"
  })
}

resource "azurerm_monitor_metric_alert" "app1_availability" {
  name                = ""
  resource_group_name = azurerm_resource_group.main.name
  scopes              = [azurerm_application_insights_web_test.app_1.id, data.azurerm_application_insights.common.id]
  description         = "Template service didn't respond correctly at least once"
  enabled             = true
  auto_mitigate       = true
  frequency           = ""
  severity            = 0

  application_insights_web_test_location_availability_criteria {
    web_test_id           = azurerm_application_insights_web_test.app_1.id
    component_id          = data.azurerm_application_insights.common.id
    failed_location_count = 1
  }

  action {
    action_group_id = data.azurerm_monitor_action_group.primary_action_group.id
  }

  tags = local.default_tags
}
