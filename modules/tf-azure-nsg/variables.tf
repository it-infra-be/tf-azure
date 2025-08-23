variable "resource_group_name" {
  description = "Name of resource group to which the network security group belongs."
  type        = string
}

variable "name" {
  description = "Name of the network security group."
  type        = string
}

variable "location" {
  description = "Location of the network security group."
  type        = string
}

variable "rules" {
  description = ""
  type = list(object({
    name                                       = string
    description                                = string
    priority                                   = number
    direction                                  = string
    access                                     = string
    protocol                                   = string
    source_address_prefix                      = string
    source_address_prefixes                    = list(string)
    source_application_security_group_ids      = list(string)
    source_port_ranges                         = list(string)
    destination_address_prefix                 = string
    destination_address_prefixes               = list(string)
    destination_application_security_group_ids = list(string)
    destination_port_ranges                    = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.rules : contains(["Tcp", "Udp", "Icmp", "Esp", "Ah", "*"], rule.protocol)
    ])
    error_message = "Protocol must be one of 'Tcp' or 'Udp' or 'Udp' or 'Udp'."
  }
  validation {
    condition = alltrue([
      for rule in var.rules : contains(["Allow", "Deny"], rule.access)
    ])
    error_message = "Access must be 'Allow' or 'Deny'."
  }
  validation {
    condition = alltrue([
      for rule in var.rules : contains(["Inbound", "Outbound"], rule.direction)
    ])
    error_message = "Direction must be 'Inbound' or 'Outbound'."
  }
}