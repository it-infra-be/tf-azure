output "id" {
  description = "The ID of the DNS zone"
  value       = azurerm_dns_zone.zone.id
}

output "name" {
  description = "The name of the DNS zone"
  value       = azurerm_dns_zone.zone.name
}
