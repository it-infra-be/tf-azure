output "id" {
  description = "The ID of the NAT gateway."
  value       = azurerm_nat_gateway.natgw.id
}

output "name" {
  description = "The name of the NAT gateway."
  value       = azurerm_nat_gateway.natgw.name
}

output "location" {
  description = "The location of the NAT gateway."
  value       = azurerm_nat_gateway.natgw.location
}

output "zone" {
  description = "The zone of the NAT gateway."
  value       = azurerm_nat_gateway.natgw.zones != null ? one(azurerm_nat_gateway.natgw.zones) : null
}

output "public_ips" {
  description = "The public IPs of the NAT gateway."
  value = { for name, public_ip in azurerm_public_ip.pip :
    name => {
      id         = public_ip.id
      ip_address = public_ip.ip_address
      zones      = public_ip.zones
    }
  }
}

output "public_ip_prefixes" {
  description = "The public IP prefixes of the NAT gateway."
  value = { for name, public_ip_prefix in azurerm_public_ip_prefix.pippre :
    name => {
      id        = public_ip_prefix.id
      ip_prefix = public_ip_prefix.id
      zones     = public_ip_prefix.zones
    }
  }
}
