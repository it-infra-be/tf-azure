/*
 * # Terraform Azure Module: Virtual Machine
 *
 * This module installs an Azure (Linux) Virtual Machine.
 *
 * This Virtual Machine can also be associated with an Azure Network Security Group.
 */
# Interfaces
resource "azurerm_network_interface" "interface" {
  for_each = { for interface in var.interfaces : interface.name => interface }

  name                           = each.key
  resource_group_name            = var.resource_group_name
  location                       = var.location
  ip_forwarding_enabled          = each.value.ip_forwarding_enabled
  accelerated_networking_enabled = each.value.accelerated_networking_enabled
  internal_dns_name_label        = each.value.internal_dns_name_label

  dynamic "ip_configuration" {
    for_each = each.value.ip_configurations

    content {
      name                          = ip_configuration.value.name
      subnet_id                     = ip_configuration.value.subnet_id
      primary                       = ip_configuration.value.primary
      private_ip_address_version    = ip_configuration.value.private_ip_address_version
      private_ip_address_allocation = ip_configuration.value.private_ip_address != null ? "Static" : "Dynamic"
      private_ip_address            = ip_configuration.value.private_ip_address
      public_ip_address_id          = ip_configuration.value.public_ip_address_id
    }
  }
}

# Virtual Machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                  = var.name
  computer_name         = var.computer_name
  resource_group_name   = var.resource_group_name
  location              = var.location
  admin_username        = var.admin_username
  zone                  = var.zone
  size                  = var.size
  user_data             = var.user_data
  network_interface_ids = [for interface in values(azurerm_network_interface.interface) : interface.id]

  disable_password_authentication = true
  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_public_key
  }

  os_disk {
    name                 = var.os_disk.name
    disk_size_gb         = var.os_disk.disk_size_gb
    caching              = var.os_disk.caching
    storage_account_type = var.os_disk.storage_account_type
  }

  source_image_reference {
    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }
}

# Network Security Group Association
resource "azurerm_network_interface_security_group_association" "nsg" {
  for_each = {
    for interface in var.interfaces :
    interface.name => interface
    if interface.has_network_security_group == true
  }

  network_interface_id      = azurerm_network_interface.interface[each.key].id
  network_security_group_id = each.value.network_security_group_id
}
