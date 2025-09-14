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
  count = length(var.public_ips)

  name                    = var.public_ips[count.index].name
  location                = var.location
  resource_group_name     = var.resource_group_name
  allocation_method       = "Static"
  sku                     = "Standard"
  zones                   = var.public_ips[count.index].zones
  idle_timeout_in_minutes = var.idle_timeout_in_minutes
}

resource "azurerm_nat_gateway_public_ip_association" "pip_association" {
  count = length(azurerm_public_ip.pip)

  nat_gateway_id       = azurerm_nat_gateway.natgw.id
  public_ip_address_id = azurerm_public_ip.pip[count.index].id
}

# Public IP Prefix association
resource "azurerm_public_ip_prefix" "pippre" {
  count = length(var.public_ip_prefixes)

  name                = var.public_ip_prefixes[count.index].name
  location            = var.location
  resource_group_name = var.resource_group_name
  prefix_length       = var.public_ip_prefixes[count.index].length
  zones               = var.public_ip_prefixes[count.index].zones
}

resource "azurerm_nat_gateway_public_ip_prefix_association" "public_ip_prefix_association" {
  count = length(azurerm_public_ip_prefix.pippre)

  nat_gateway_id      = azurerm_nat_gateway.natgw.id
  public_ip_prefix_id = azurerm_public_ip_prefix.pippre[count.index].id
}
