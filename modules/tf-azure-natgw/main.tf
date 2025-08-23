# NAT Gateway
resource "azurerm_nat_gateway" "natgw" {
  name                    = var.name
  resource_group_name     = var.resource_group_name
  location                = var.location
  sku_name                = var.sku_name
  idle_timeout_in_minutes = var.idle_timeout_in_minutes
  zones                   = var.zones
}

# Subnets association
resource "azurerm_subnet_nat_gateway_association" "snet" {
  for_each = toset(var.subnets)

  subnet_id      = each.key
  nat_gateway_id = azurerm_nat_gateway.natgw.id
}

# Public IP Association
resource "azurerm_public_ip" "pip" {
  for_each = { for pip in var.public_ips : pip.name => pip }

  name                    = each.key
  location                = var.location
  resource_group_name     = var.resource_group_name
  allocation_method       = "Static"
  sku                     = "Standard"
  zones                   = each.value.zones
  idle_timeout_in_minutes = var.idle_timeout_in_minutes
}

resource "azurerm_nat_gateway_public_ip_association" "pip_association" {
  for_each = azurerm_public_ip.pip

  nat_gateway_id       = azurerm_nat_gateway.natgw.id
  public_ip_address_id = each.value.id
}

# Public IP Prefix association
resource "azurerm_public_ip_prefix" "pippre" {
  for_each = { for pip_prefix in var.public_ip_prefixes : pip_prefix.name => pip_prefix }

  name                = each.key
  location            = var.location
  resource_group_name = var.resource_group_name
  prefix_length       = each.value.length
  zones               = each.value.zones
}

resource "azurerm_nat_gateway_public_ip_prefix_association" "public_ip_prefix_association" {
  for_each = azurerm_public_ip_prefix.pippre

  nat_gateway_id      = azurerm_nat_gateway.natgw.id
  public_ip_prefix_id = each.value.id
}
