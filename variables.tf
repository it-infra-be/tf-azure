variable "resource_group" {
  description = "Name of resource group"
  type = object({
    name     = string
    location = string
  })
}

variable "nsgs" {
  description = "Network security groups and their rules"
  type = list(object({
    name     = string
    location = string
    rules = list(object({
      name                                       = string
      description                                = string
      priority                                   = number
      direction                                  = string
      access                                     = string
      protocol                                   = string
      source_address_prefix                      = optional(string)
      source_address_prefixes                    = optional(list(string))
      source_application_security_group_ids      = optional(list(string))
      source_port_range                          = optional(string)
      source_port_ranges                         = optional(list(string))
      destination_address_prefix                 = optional(string)
      destination_address_prefixes               = optional(list(string))
      destination_application_security_group_ids = optional(list(string))
      destination_port_range                     = optional(string)
      destination_port_ranges                    = optional(list(string))
    }))
  }))
  default = []
}

variable "natgws" {
  description = "NAT gateways"
  type = list(object({
    name                     = string
    location                 = string
    sku_name                 = optional(string)
    idle_timeout_in_minutes  = optional(number)
    zone                     = optional(string)
    public_ip_count          = optional(number, 1)
    public_ip_prefix_lengths = optional(list(number))
  }))
  default = []
}

variable "vnets" {
  description = "Network security groups and their rules"
  type = list(object({
    name           = string
    location       = string
    address_spaces = list(string)
    subnets = list(object({
      name                            = string
      address_prefix                  = string
      default_outbound_access_enabled = optional(bool, false)
      network_security_group_name     = optional(string)
      nat_gateway_name                = optional(string)
    }))
  }))
  default = []
}

variable "bastions" {
  description = "Bastion Hosts"
  type = list(object({
    name                      = string
    sku                       = optional(string)
    virtual_network_name      = string
    subnet_prefix             = optional(string)
    copy_paste_enabled        = optional(bool)
    file_copy_enabled         = optional(bool)
    scale_units               = optional(number)
    session_recording_enabled = optional(bool)
    zones                     = optional(list(string))
  }))
  default = []
}

variable "public_keys" {
  description = "SSH public keys"
  type = list(object({
    name       = string
    location   = string
    public_key = string
  }))
}

variable "vms" {
  description = "Virtual machines"
  type = list(object({
    name                  = string
    virtual_network_name  = string
    zone                  = optional(string)
    admin_username        = string
    admin_public_key_name = string
    size                  = string
    user_data             = optional(string)
    os_disk = optional(object({
      disk_size_gb         = optional(number)
      caching              = optional(string, "ReadWrite")
      storage_account_type = optional(string, "Standard_LRS")
    }))
    source_image_reference = optional(object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    }))
    interfaces = list(object({
      ip_forwarding_enabled          = optional(bool)
      accelerated_networking_enabled = optional(bool)
      internal_dns_name_label        = optional(string)
      ip_configurations = list(object({
        name                       = string
        subnet_name                = string
        primary                    = optional(bool)
        private_ip_address_version = optional(string)
        private_ip_address         = optional(string)
        public_ip_address_name     = optional(string)
      }))
      network_security_group_name = optional(string)
    }))
  }))
  default = []
}
