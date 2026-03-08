variable "project" {
  description = "Name of project these resources belong to"
  type        = string
}

variable "environment" {
  description = "Name of environment these resources belong to"
  type        = string
}

variable "location" {
  description = "Location these resources belong to"
  type        = string
}

variable "base_domain" {
  description = "The base DNS domain, resource group default domain: <environment>.<project>.<location>.<base_domain>"
  type        = string
}

variable "key_vaults" {
  description = "Key Vaults"
  type = map(object({
    sku                             = optional(string, "standard")
    soft_delete_retention_days      = optional(number, 7)
    purge_protection_enabled        = optional(bool, false)
    enabled_for_deployment          = optional(bool, false)
    enabled_for_template_deployment = optional(bool, false)
    enabled_for_disk_encryption     = optional(bool, false)
    public_network_access_enabled   = optional(bool, true)
    network_acls = optional(object({
      bypass                     = optional(string, "None")
      default_action             = optional(string, "Deny")
      ip_rules                   = optional(list(string))
      virtual_network_subnet_ids = optional(list(string))
    }))
  }))
  default = {}
}

variable "public_ips" {
  description = "Reserved static public IP addresses"
  type = map(object({
    zones = optional(list(string), []) # [] = Zone-redundant
  }))
  default  = {}
  nullable = false
}

variable "nsgs" {
  description = "Network security groups and their rules"
  type = map(list(object({
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
  })))
  default = {}
}

variable "natgws" {
  description = "NAT gateways"
  type = map(object({
    sku_name                 = optional(string)
    idle_timeout_in_minutes  = optional(number)
    zone                     = optional(string)
    public_ip_address_count  = optional(number, 1)
    public_ip_prefix_lengths = optional(list(number))
  }))
  default = {}
}

variable "vnets" {
  description = "Virtual networks and their subnets"
  type = map(object({
    address_spaces = list(string)
    subnets = map(object({
      address_prefix                  = string
      default_outbound_access_enabled = optional(bool, false)
      network_security_group_name     = optional(string)
      nat_gateway_name                = optional(string)
    }))
  }))
  default = {}
}

variable "bastions" {
  description = "Bastion Hosts"
  type = map(object({
    sku                       = optional(string)
    virtual_network_name      = string
    subnet_prefix             = optional(string)
    copy_paste_enabled        = optional(bool)
    file_copy_enabled         = optional(bool)
    scale_units               = optional(number)
    session_recording_enabled = optional(bool)
    zones                     = optional(list(string))
  }))
  default = {}
}

variable "public_keys" {
  description = "SSH public keys"
  type        = map(string)
  default     = {}
}

variable "vms" {
  description = "Virtual machines"
  type = map(object({
    domain                = optional(string) # Default = resource group default domain
    aliases               = optional(list(string))
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
        subnet_name                = string
        primary                    = optional(bool)
        private_ip_address_version = optional(string)
        private_ip_address         = optional(string)
        public_ip_address_name     = optional(string)
      }))
      network_security_group_name = optional(string)
    }))
  }))
  default = {}
}

variable "create_default_domain" {
  description = "Create default domain based on base_domain, location, project and environment."
  type        = bool
  default     = true
}

variable "dns_zones" {
  description = "DNS zones with records"
  type = map(object({
    soa_record = optional(object({
      email         = string
      host_name     = optional(string)
      expire_time   = optional(number)
      minimum_ttl   = optional(number)
      refresh_time  = optional(number)
      retry_time    = optional(number)
      serial_number = optional(number)
      ttl           = optional(number)
    }))
    a_records     = optional(map(list(string)), {})
    aaaa_records  = optional(map(list(string)), {})
    cname_records = optional(map(string), {})
    ns_records    = optional(map(list(string)), {})
    ptr_records   = optional(map(list(string)), {})
    txt_records   = optional(map(list(string)), {})
    mx_records = optional(map(list(object({
      preference = number
      exchange   = string
    }))), {})
    srv_records = optional(map(list(object({
      priority = number
      weight   = number
      port     = number
      target   = string
    }))), {})
    caa_records = optional(map(list(object({
      flags = number
      tag   = string
      value = string
    }))), {})
  }))
  default = null
}

variable "vpns" {
  description = "Virtual Private Networks"
  type = map(object({
    key_vault_name = string

    virtual_network_gateway = object({
      generation    = optional(string, "Generation1")
      enable_bgp    = optional(bool)
      sku           = optional(string, "VpnGw1AZ")
      active_active = optional(string, true)
      custom_route = optional(object({
        address_prefixes = list(string)
      }))
      bgp_settings = optional(object({
        asn         = number
        peer_weight = optional(number)
      }))
      instances = map(object({
        public_ip_address_id = optional(string)
        bgp_apipa_addresses  = optional(list(string))
      }))
    })

    local_network_gateways = optional(map(object({
      gateway_address = optional(string)
      gateway_fqdn    = optional(string)
      address_space   = optional(list(string))
      bgp_settings = optional(object({
        asn                 = number
        bgp_peering_address = string
        peer_weight         = optional(number)
      }))
      connection = object({
        key_vault_secret_psk = string
        dpd_timeout_seconds  = optional(number)
        connection_protocol  = optional(string, "IKEv2")
        enable_bgp           = optional(bool)
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
      })
    })), {})
  }))
  default = {}
}
