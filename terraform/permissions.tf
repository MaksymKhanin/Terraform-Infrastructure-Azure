resource "azurerm_user_assigned_identity" "main" {
  resource_group_name = azurerm_resource_group.main.name
  name                = "apiTemplate-${var.subscription_type}-${var.environment_id}-Template"
  location            = local.location

  tags = local.default_tags
}

resource "azurerm_role_assignment" "main_identity_app_config" {
  scope                = data.azurerm_app_configuration.common.id
  role_definition_name = "App Configuration Data Reader"
  principal_id         = azurerm_user_assigned_identity.main.principal_id
}

resource "azurerm_key_vault_access_policy" "main_identity_external_key_vault" {
  key_vault_id = var.external_key_vault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.main.principal_id

  secret_permissions = [
    "Get",
  ]
}