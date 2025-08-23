output "id" {
  description = "The ID of the Virtual Network."
  value       = azurerm_virtual_network.vnet.id
}

output "name" {
  description = "The name of the Virtual Network."
  value       = azurerm_virtual_network.vnet.name
}

output "subnets" {
  description = "The Virtual Network subnets."
  value = {
    for name, subnet in azurerm_subnet.snet :
    name => {
      id                              = subnet.id
      address_prefixes                = subnet.address_prefixes
      default_outbound_access_enabled = subnet.default_outbound_access_enabled
    }
  }
}
