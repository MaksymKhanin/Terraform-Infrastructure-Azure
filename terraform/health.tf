resource "azurerm_api_management_api_operation" "Template_health" {
  provider            = azurerm.apim
  operation_id        = "Template-health"
  api_name            = local.specific.apim.api_name
  api_management_name = local.specific.apim.name
  resource_group_name = local.specific.apim.resource_group_name
  display_name        = "Template Health"
  method              = "GET"
  url_template        = "/Template-health"
  description         = "Get the health status of the Template service"

  request {
    description = "Template health service"
  }

  response {
    status_code = 200
  }

  response {
    status_code = 503
  }
}


resource "azurerm_api_management_api_operation_policy" "Template_health" {
  provider            = azurerm.apim
  api_name            = local.specific.apim.api_name
  api_management_name = local.specific.apim.name
  resource_group_name = local.specific.apim.resource_group_name
  operation_id        = azurerm_api_management_api_operation.Template_health.operation_id

  xml_content = <<XML
<policies>
    <inbound>
      <base />
      <rewrite-uri template="/health" />
      <set-backend-service base-url="https://${azurerm_app_service.app_1.default_site_hostname}" />
    </inbound>
    <backend>
      <base />
    </backend>
    <outbound>
      <base />
    </outbound>
    <on-error>
      <base />
    </on-error>
</policies>
XML

}
