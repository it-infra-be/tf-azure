output "id" {
  description = "The ID of the Linux Virtual Machine."
  value       = azurerm_linux_virtual_machine.vm.id
}

output "name" {
  description = "The name of the Linux Virtual Machine."
  value       = azurerm_linux_virtual_machine.vm.name
}

output "location" {
  description = "The location of the Linux Virtual Machine."
  value       = azurerm_linux_virtual_machine.vm.location
}

output "private_ip_address" {
  description = "The primary private IP address of the Linux Virtual Machine."
  value       = azurerm_linux_virtual_machine.vm.private_ip_address
}

output "public_ip_address" {
  description = "The primary public IP address of the Linux Virtual Machine."
  value       = azurerm_linux_virtual_machine.vm.public_ip_address
}

output "interfaces" {
  description = "The Linux Virtual Machine interfaces."
  value = {
    for interface in azurerm_network_interface.interface :
    interface.name => {
      id                   = interface.id
      mac_address          = interface.mac_address
      private_ip_addresses = interface.private_ip_addresses
    }
  }
}

output "network_security_group_associations" {
  description = "The network security group associated with each interface."
  value = {
    for name, association in azurerm_network_interface_security_group_association.nsg :
    name => association.network_security_group_id
  }
}
