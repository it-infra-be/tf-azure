/*
 * # Terraform Azure Module: Network Security Group
 *
 * This module installs an Azure Network Security Group and its rules.
 *
 * The Network Security Group associations are handled by the resources that need it.
 */

# Network Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
}

# Network Security Group Rules
resource "azurerm_network_security_rule" "nsgsr" {
  for_each = { for rule in var.rules : rule.name => rule }

  resource_group_name                        = var.resource_group_name
  network_security_group_name                = azurerm_network_security_group.nsg.name
  name                                       = each.value.name
  description                                = each.value.description
  priority                                   = each.value.priority
  direction                                  = each.value.direction
  access                                     = each.value.access
  protocol                                   = each.value.protocol
  source_address_prefix                      = each.value.source_address_prefix
  source_address_prefixes                    = each.value.source_address_prefixes
  source_application_security_group_ids      = each.value.source_application_security_group_ids
  source_port_range                          = each.value.source_port_range
  source_port_ranges                         = each.value.source_port_ranges
  destination_address_prefix                 = each.value.destination_address_prefix
  destination_address_prefixes               = each.value.destination_address_prefixes
  destination_application_security_group_ids = each.value.destination_application_security_group_ids
  destination_port_range                     = each.value.destination_port_range
  destination_port_ranges                    = each.value.destination_port_ranges
}
