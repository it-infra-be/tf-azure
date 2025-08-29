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

# Network Security Group Associations
resource "azurerm_subnet_network_security_group_association" "nsg" {
  for_each = {
    for subnet in var.subnets :
    subnet.name => subnet
    if subnet.has_network_security_group == true
  }

  subnet_id                 = azurerm_subnet.snet[each.key].id
  network_security_group_id = each.value.network_security_group_id
}

# NAT Gateway association
resource "azurerm_subnet_nat_gateway_association" "natgw" {
  for_each = {
    for subnet in var.subnets :
    subnet.name => subnet
    if subnet.has_nat_gateway == true
  }

  subnet_id      = azurerm_subnet.snet[each.key].id
  nat_gateway_id = each.value.nat_gateway_id
}
