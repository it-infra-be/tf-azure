/*
 * # Terraform Azure Module: Bastion Host
 *
 * This module installs an Azure Bastion Host and its public IP address.
 *
 * This module also configures the 'AzureBastionSubnet' in the provided Virtual Network
 * with the provided subnet prefix.
 */

# Subnet
resource "azurerm_subnet" "snet" {
  count = var.sku != "Developer" ? 1 : 0

  name                            = "AzureBastionSubnet"
  resource_group_name             = var.resource_group_name
  virtual_network_name            = regex(".*/virtualNetworks/(.*)", var.virtual_network_id)[0]
  address_prefixes                = [var.subnet_prefix]
  default_outbound_access_enabled = false
}

# Public IP
resource "azurerm_public_ip" "pip" {
  count = var.public_ip_name != null ? 1 : 0

  name                = var.public_ip_name
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
  sku                       = var.sku
  scale_units               = var.scale_units
  session_recording_enabled = var.session_recording_enabled
  virtual_network_id        = var.sku == "Developer" ? var.virtual_network_id : null
  zones                     = var.zones

  dynamic "ip_configuration" {
    for_each = var.sku != "Developer" ? [true] : []

    content {
      name                 = "ipconf"
      subnet_id            = azurerm_subnet.snet[0].id
      public_ip_address_id = var.public_ip_name != null ? azurerm_public_ip.pip[0].id : null
    }
  }
}
