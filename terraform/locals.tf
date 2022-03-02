locals {

  naming   = lookup(local.naming_map, var.subscription_type)
  specific = lookup(local.specific_map, var.subscription_type)

  saas_digits = ""
  location    = ""
  tenant_id   = data.azurerm_client_config.current.tenant_id

  naming_map = {

    build = {
      main_resource_group_name = ""
      plan_name                = ""
      app_1_name               = ""
    }

    inte = {
      main_resource_group_name = ""
      plan_name                = ""
      app_1_name               = ""
    }

    prod = {
      main_resource_group_name = ""
      plan_name                = ""
      app_1_name               = ""
    }
  }

  specific_map = {
    build = {
      subscription_id = ""
      apim = {
        subscription_id     = ""
        resource_group_name = ""
        name                = ""
        api_name            = ""
      }
      tags = {}
    }

    inte = {
      subscription_id = ""
      apim = {
        subscription_id     = ""
        resource_group_name = ""
        name                = ""
        api_name            = ""
      }
      tags = {
        CostCenter = ""
      }
    }

    prod = {
      subscription_id = ""
      tags = {
        CostCenter = ""
      }
    }
  }

  app_config_labels = {
    Template   = "Template"
    shared   = "shared"
  }

  default_tags = merge(local.specific.tags, {
    managed_by  = "terraform"
    stream      = "apiTemplate"
    component   = "Template"
    environment = var.environment_name
  })

  authorization_audience = "apiTemplate"
  apim_public_host_name  = [for p in data.azurerm_api_management.apim.hostname_configuration.0.proxy : p.host_name if p.default_ssl_binding == true].0
  apim_apiTemplate_base_uri = "https://${local.apim_public_host_name}/${data.azurerm_api_management_api.apiTemplate.path}"
  apiTemplate_authority     = "${local.apim_apiTemplate_base_uri}/auth"
}
