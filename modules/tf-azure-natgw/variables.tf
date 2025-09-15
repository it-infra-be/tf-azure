variable "resource_group_name" {
  description = "Name of resource group to which the NAT Gateway belongs"
  type        = string
}

variable "name" {
  description = "Name of the NAT Gateway"
  type        = string
}

variable "location" {
  description = "Location of the NAT Gateway"
  type        = string
}

variable "sku_name" {
  description = "SKU Name of the NAT Gateway"
  type        = string
  default     = "Standard"
  nullable    = false
}

variable "idle_timeout_in_minutes" {
  description = "TCP idle timeout of the NAT Gateway"
  type        = number
  default     = 4
  nullable    = false
}

variable "zone" {
  description = "Zone to which NAT Gateway belongs"
  type        = string
  default     = null
}

variable "new_public_ip_addresses" {
  description = "New public IP addresses to associate with the NAT Gateway"
  type = list(object({
    name  = string
    zones = optional(list(string))
  }))
  default  = []
  nullable = false
}

variable "public_ip_address_ids" {
  description = "Existing public IP addresses to associate with the NAT Gateway"
  type        = list(string)
  default     = []
  nullable    = false
}

variable "new_public_ip_prefixes" {
  description = "New public IP prefixes to associate with the NAT Gateway"
  type = list(object({
    name   = string
    length = number
    zones  = optional(list(string))
  }))
  default  = []
  nullable = false
}

variable "public_ip_prefix_ids" {
  description = "Existing public IP prefixes to associate with the NAT Gateway"
  type        = list(string)
  default     = []
  nullable    = false
}