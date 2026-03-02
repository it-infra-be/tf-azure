/*
 * # Terraform Azure Module: Bastion Host
 *
 * This module installs an Azure Bastion Host and its public IP address.
 *
 * This module will need a subnet called 'AzureBastionSubnet'!
 *
 */

# Public IP
resource "azurerm_public_ip" "pip" {
  count = var.new_public_ip_address != null ? 1 : 0

  name                = var.new_public_ip_address.name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = [] # Zone-redundant
}

# Bastion Host
resource "azurerm_bastion_host" "bastion" {
  name                      = var.name
  location                  = var.location
  resource_group_name       = var.resource_group_name
  copy_paste_enabled        = var.copy_paste_enabled
  file_copy_enabled         = var.file_copy_enabled
  sku                       = coalesce(var.sku)
  scale_units               = var.scale_units
  session_recording_enabled = var.session_recording_enabled
  virtual_network_id        = var.sku == "Developer" ? var.virtual_network_id : null
  zones                     = var.zones

  dynamic "ip_configuration" {
    for_each = var.sku != "Developer" ? [true] : []

    content {
      name                 = "ipconf"
      subnet_id            = var.subnet_id
      public_ip_address_id = var.new_public_ip_address != null ? azurerm_public_ip.pip[0].id : var.public_ip_address_id != null ? var.public_ip_address_id : null
    }
  }
}
