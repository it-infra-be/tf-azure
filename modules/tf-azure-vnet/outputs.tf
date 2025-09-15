output "id" {
  description = "The ID of the Virtual Network."
  value       = azurerm_virtual_network.vnet.id
}

output "name" {
  description = "The name of the Virtual Network."
  value       = azurerm_virtual_network.vnet.name
}

output "location" {
  description = "The location of the Virtual Network"
  value       = azurerm_virtual_network.vnet.location
}

output "subnets" {
  description = "The Virtual Network subnets"
  value = {
    for name, subnet in azurerm_subnet.snet :
    name => {
      id                              = subnet.id
      address_prefixes                = subnet.address_prefixes
      default_outbound_access_enabled = subnet.default_outbound_access_enabled
    }
  }
}

output "network_security_group_associations" {
  description = "The network security group associated with each subnet"
  value = {
    for name, association in azurerm_subnet_network_security_group_association.nsg :
    name => association.network_security_group_id
  }
}

output "nat_gateway_associations" {
  description = "The NAT gateway associated with each subnet"
  value = {
    for name, association in azurerm_subnet_nat_gateway_association.natgw :
    name => association.nat_gateway_id
  }
}
