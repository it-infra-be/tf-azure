variable "resource_group_name" {
  description = "Name of resource group to which the vpn connection belongs"
  type        = string
}

variable "location" {
  description = "Location of the vpn connection"
  type        = string
}

variable "virtual_network_gateway" {
  description = "Configuration of the virtual network gateway"
  type = object({
    name          = string
    generation    = optional(string, "Generation1")
    sku           = optional(string, "VpnGw1AZ")
    active_active = optional(string, true)
    subnet_id     = string
    custom_route = optional(object({
      address_prefixes = list(string)
    }))
    bgp = optional(object({
      asn         = number
      peer_weight = optional(number)
    }))
    instances = map(object({
      public_ip_address_name = optional(string)
      public_ip_address_id   = optional(string)
      bgp_apipa_addresses    = optional(list(string))
    }))
  })
}

variable "local_network_gateways" {
  description = "Configuration of local network gateways"
  type = list(object({
    name            = string
    gateway_address = optional(string)
    gateway_fqdn    = optional(string)
    address_space   = list(string)
    bgp_peer = optional(map(object({
      asn         = number
      peer_weight = optional(number)
    })))
  }))
  default = []
}

variable "connections" {
  description = "Configuration of VPN connections for the virtual network gateway and its local network gateways"
  type = list(object({
    name                       = string
    dpd_timeout_seconds        = optional(number)
    local_network_gateway_name = string
    shared_key                 = string
    connection_protocol        = optional(string, "IKEv2")
    enable_bgp                 = optional(bool, false)

    custom_bgp_addresses = optional(object({
      primary   = string
      secondary = optional(string)
    }))

    ipsec_policy = optional(object({
      dh_group         = string
      ike_encryption   = string
      ike_integrity    = string
      ipsec_encryption = string
      ipsec_integrity  = string
      pfs_group        = string
      sa_datasize      = optional(number)
      sa_lifetime      = optional(number)
    }))
  }))
  default = []
}