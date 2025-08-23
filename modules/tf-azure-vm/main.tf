# Interfaces
resource "azurerm_network_interface" "interface" {
  count = length(var.interfaces)

  name                           = var.interfaces[count.index].name
  resource_group_name            = var.resource_group_name
  location                       = var.location
  ip_forwarding_enabled          = var.interfaces[count.index].ip_forwarding_enabled
  accelerated_networking_enabled = var.interfaces[count.index].accelerated_networking_enabled
  internal_dns_name_label        = var.interfaces[count.index].internal_dns_name_label

  dynamic "ip_configuration" {
    for_each = var.interfaces[count.index].ip_configurations

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
  resource_group_name   = var.resource_group_name
  location              = var.location
  admin_username        = var.admin_username
  zone                  = var.zone
  size                  = var.size
  user_data             = var.user_data
  network_interface_ids = azurerm_network_interface.interface[*].id

  disable_password_authentication = true
  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_ssh_key
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
