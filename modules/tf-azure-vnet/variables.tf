variable "resource_group_name" {
  description = "Name of resource group to which the virtual network belongs"
  type        = string
}

variable "name" {
  description = "Name of the virtual network"
  type        = string
}

variable "location" {
  description = "Location of the virtual network"
  type        = string
}

variable "address_spaces" {
  description = "Address spaces in the virtual network"
  type        = list(string)
}

variable "subnets" {
  description = "Subnets in the virtual network"
  type = list(object({
    name                            = string
    address_prefix                  = string
    default_outbound_access_enabled = optional(bool, false)
    has_network_security_group      = optional(bool, false)
    network_security_group_id       = optional(string)
    network_security_group_name     = optional(string)
    has_nat_gateway                 = optional(bool, false)
    nat_gateway_id                  = optional(string)
  }))
}
