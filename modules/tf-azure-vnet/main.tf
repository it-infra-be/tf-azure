# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.name
  address_space       = var.address_spaces
  location            = var.location
  resource_group_name = var.resource_group_name
}

# Virtual Network Subnets
resource "azurerm_subnet" "snet" {
  for_each = { for subnet in var.subnets : subnet.name => subnet }

  name                            = each.key
  resource_group_name             = var.resource_group_name
  virtual_network_name            = azurerm_virtual_network.vnet.name
  address_prefixes                = [each.value.address_prefix]
  default_outbound_access_enabled = each.value.default_outbound_access_enabled
}
