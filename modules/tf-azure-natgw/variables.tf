variable "resource_group_name" {
  description = "Name of resource group to which the NAT Gateway belongs."
  type        = string
}

variable "name" {
  description = "Name of the NAT Gateway."
  type        = string
}

variable "location" {
  description = "Location of the NAT Gateway."
  type        = string
}

variable "sku_name" {
  description = "SKU Name of the NAT Gateway."
  type        = string
  default     = "Standard"
}

variable "idle_timeout_in_minutes" {
  description = "TCP idle timeout of the NAT Gateway."
  type        = number
  default     = 4
}

variable "zones" {
  description = "Zones to which NAT Gateway belongs."
  type        = list(string)
  default     = null
}

variable "subnets" {
  description = "Subnet IDs to associate with the NAT Gateway."
  type        = list(string)
  default     = []
}

variable "public_ips" {
  description = "Public IP addresses to associate with the NAT Gateway."
  type = list(object({
    name  = string
    zones = optional(list(string))
  }))
  default = []
}

variable "public_ip_prefixes" {
  description = "Public IP prefixes to associate with the NAT Gateway."
  type = list(object({
    name   = string
    length = number
    zones  = optional(list(string))
  }))
  default = []
}
