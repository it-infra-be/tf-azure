/*
 * # Terraform Azure Module: Key Vault
 *
 * This module installs an Azure Key Vault.
 *
 * This module only supports the RBAC permission model.
 */

# Get local Azure AD Tenant
data "azurerm_client_config" "current" {}

# Create Key Vault
resource "azurerm_key_vault" "kv" {
  # Basics
  name                       = var.name
  location                   = var.location
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  resource_group_name        = var.resource_group_name
  sku_name                   = var.sku
  soft_delete_retention_days = var.soft_delete_retention_days
  purge_protection_enabled   = var.purge_protection_enabled

  # Access Configuration (only RBAC supported)
  rbac_authorization_enabled      = true
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_template_deployment = var.enabled_for_template_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption

  # Networking
  public_network_access_enabled = var.public_network_access_enabled

  dynamic "network_acls" {
    for_each = var.network_acls != null ? [var.network_acls] : []

    content {
      bypass                     = network_acls.value.bypass
      default_action             = network_acls.value.default_action
      ip_rules                   = network_acls.value.ip_rules
      virtual_network_subnet_ids = network_acls.value.virtual_network_subnet_ids
    }
  }
}
