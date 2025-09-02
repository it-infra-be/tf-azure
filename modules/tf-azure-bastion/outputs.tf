output "id" {
  description = "The ID of the Bastion Host"
  value       = azurerm_bastion_host.bastion.id
}

output "name" {
  description = "The name of the Bastion Host"
  value       = azurerm_bastion_host.bastion.id
}

output "location" {
  description = "The location of the Bastion Host"
  value       = azurerm_bastion_host.bastion.location
}

output "public_ip" {
  description = "The public IP of the Bastion Host"
  value = length(azurerm_public_ip.pip) > 0 ? {
    id         = azurerm_public_ip.pip[0].id
    ip_address = azurerm_public_ip.pip[0].ip_address
  } : null
}
