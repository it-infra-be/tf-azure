variable "resource_group_name" {
  description = "Name of resource group to which the virtual machine belongs."
  type        = string
}

variable "name" {
  description = "Name of the virtual machine."
  type        = string
}

variable "location" {
  description = "Location of the virtual machine."
  type        = string
}

variable "zone" {
  description = "Zone in which Virtual Machine should be located."
  type        = string
  default     = null
}

variable "admin_username" {
  description = "Name of the local administrator for the virtual machine."
  type        = string
}

variable "admin_public_key" {
  description = "Public SSH Key of the local administrator for the virtual machine."
  type        = string
}

variable "size" {
  description = "Type of virtual machine."
  type        = string
}

variable "user_data" {
  description = "User Data which should be used for this Virtual Machine."
  type        = string
  default     = null
}

variable "os_disk" {
  description = "OS disk for this Virtual Machine."
  type = object({
    name                 = optional(string)
    disk_size_gb         = optional(number)
    caching              = optional(string, "ReadWrite")
    storage_account_type = optional(string, "Standard_LRS")
  })
  default  = {}
  nullable = false
  validation {
    condition     = contains(["None", "ReadOnly", "ReadWrite"], var.os_disk.caching)
    error_message = "Caching must be 'None', 'ReadOnly' or 'ReadWrite'."
  }
  validation {
    condition     = contains(["Standard_LRS", "StandardSSD_LRS", "StandardSSD_ZRS", "Premium_LRS", "Premium_ZRS"], var.os_disk.storage_account_type)
    error_message = "Account Type must be 'Standard_LRS', 'StandardSSD_LRS', 'StandardSSD_ZRS', 'Premium_LRS' or 'Premium_ZRS'."
  }
}

variable "source_image_reference" {
  description = "Source Image reference of the Virtual Machine."
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "almalinux"
    offer     = "almalinux-x86_64"
    sku       = "9-gen1"
    version   = "latest"
  }
  nullable = false
}

variable "interfaces" {
  description = "Virtual machine interfaces."
  type = list(object({
    name                           = string
    ip_forwarding_enabled          = optional(bool)
    accelerated_networking_enabled = optional(bool)
    internal_dns_name_label        = optional(string)
    ip_configurations = list(object({
      name                       = string
      subnet_id                  = string
      primary                    = optional(bool)
      private_ip_address_version = optional(string)
      private_ip_address         = optional(string)
      public_ip_address_id       = optional(string)
    }))
    has_network_security_group = optional(bool, false)
    network_security_group_id  = optional(string)
  }))
}
