output "id" {
  description = "The ID of the Linux Virtual Machine."
  value       = azurerm_linux_virtual_machine.vm.id
}

output "name" {
  description = "The name of the Linux Virtual Machine."
  value       = azurerm_linux_virtual_machine.vm.name
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
    interface.id => {
      mac_address          = interface.mac_address
      private_ip_addresses = interface.private_ip_addresses
    }
  }
}
