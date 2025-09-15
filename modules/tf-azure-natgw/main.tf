/*
 * # Terraform Azure Module: NAT Gateway
 *
 * This module installs an Azure NAT Gateway together with its public IPs and public IP prefixes.
 *
 * The NAT Gateway associations are handled by the resources that need it.
 */

# NAT Gateway
resource "azurerm_nat_gateway" "natgw" {
  name                    = var.name
  resource_group_name     = var.resource_group_name
  location                = var.location
  sku_name                = var.sku_name
  idle_timeout_in_minutes = var.idle_timeout_in_minutes
  zones                   = var.zone != null ? [var.zone] : null
}

# Public IP Association
resource "azurerm_public_ip" "pip" {
  count = length(var.new_public_ip_addresses)

  name                    = var.new_public_ip_addresses[count.index].name
  location                = var.location
  resource_group_name     = var.resource_group_name
  allocation_method       = "Static"
  sku                     = "Standard"
  zones                   = var.new_public_ip_addresses[count.index].zones
  idle_timeout_in_minutes = var.idle_timeout_in_minutes
}

locals {
  all_public_ip_address_ids = concat(azurerm_public_ip.pip[*].id, var.public_ip_address_ids)
}

resource "azurerm_nat_gateway_public_ip_association" "pip_association" {
  count = length(local.all_public_ip_address_ids)

  nat_gateway_id       = azurerm_nat_gateway.natgw.id
  public_ip_address_id = local.all_public_ip_address_ids[count.index]
}

# Public IP Prefix association
resource "azurerm_public_ip_prefix" "pippre" {
  count = length(var.new_public_ip_prefixes)

  name                = var.new_public_ip_prefixes[count.index].name
  location            = var.location
  resource_group_name = var.resource_group_name
  prefix_length       = var.new_public_ip_prefixes[count.index].length
  zones               = var.new_public_ip_prefixes[count.index].zones
}

locals {
  all_public_ip_prefix_ids = concat(azurerm_public_ip_prefix.pippre[*].id, var.public_ip_prefix_ids)
}

resource "azurerm_nat_gateway_public_ip_prefix_association" "public_ip_prefix_association" {
  count = length(local.all_public_ip_prefix_ids)

  nat_gateway_id      = azurerm_nat_gateway.natgw.id
  public_ip_prefix_id = local.all_public_ip_prefix_ids[count.index]
}
