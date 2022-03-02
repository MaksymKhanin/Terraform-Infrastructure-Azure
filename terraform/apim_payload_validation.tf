resource "azurerm_api_management_api_operation" "validate_payload" {
  provider            = azurerm.apim
  operation_id        = "validate-payload"
  api_name            = local.specific.apim.api_name
  api_management_name = local.specific.apim.name
  resource_group_name = local.specific.apim.resource_group_name
  display_name        = "Validate payload"
  method              = "POST"
  url_template        = "/payload/validation"
  description         = "Validate payload Pdf file"

  request {
    description = "Validate payload"

    representation {
      content_type = "multipart/form-data"

      form_parameter {
        name     = "payload"
        required = true
        type     = "file"
      }
    }
  }

  response {
    status_code = 200
  }

  response {
    status_code = 400
  }
}

resource "azurerm_api_management_api_operation_policy" "validate_payload" {
  provider            = azurerm.apim
  api_name            = local.specific.apim.api_name
  api_management_name = local.specific.apim.name
  resource_group_name = local.specific.apim.resource_group_name
  operation_id        = azurerm_api_management_api_operation.validate_payload.operation_id

  xml_content = <<XML
<policies>
    <inbound>
      <base />
      <cors allow-credentials="true" terminate-unmatched-request="true">
          <allowed-origins>
              <origin>https://localhost:44448</origin>
          </allowed-origins>
          <allowed-methods>
              <method>post</method>
          </allowed-methods>
          <allowed-headers>
              <header>*</header>
          </allowed-headers>
      </cors>
      <validate-jwt header-name="Authorization" failed-validation-httpcode="401" failed-validation-error-message="Unauthorized. Access token is missing or invalid." require-scheme="Bearer">
          <openid-config url="${local.apiTemplate_authority}/.well-known/openid-configuration" />
          <audiences>
            <audience>${local.authorization_audience}</audience>
          </audiences>
          <issuers>
            <issuer>${local.apiTemplate_authority}</issuer>
          </issuers>
          <required-claims>
            <claim name="client_id" />
            <claim name="scope" match="any" separator=" ">
                <value>Template</value>
            </claim>
          </required-claims>
        </validate-jwt>
        <rewrite-uri template="/validation" />
        <set-backend-service base-url="https://${azurerm_app_service.app_1.default_site_hostname}/api/Api" />
    </inbound>
    <backend>
      <retry condition="@(new[] { 502, 503, 504 }.Contains(context.Response.StatusCode))" count="10" interval="2" max-interval="100" delta="5" first-fast-retry="true">
        <forward-request buffer-request-body="true" />
      </retry>
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
