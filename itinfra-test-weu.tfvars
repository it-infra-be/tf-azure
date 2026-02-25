project     = "itinfra"
environment = "test"
location    = "westeurope"
base_domain = "example.com"

public_keys = {
  "default" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICc01YBW875bXi6/bHlw6k9sBAF2lRpAHkEMveoeMLih"
}

create_default_domain = false

# public_ips = {
#   "vm001" = {}
# }
#
# natgws = {
#   "default" = { public_ip_count = 1 }
# }

nsgs = {
  "default" = [
    {
      name                       = "DenyAllIn"
      description                = "Deny all inbound traffic"
      priority                   = "4096"
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_address_prefix      = "*"
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "*"
    },
    {
      name                       = "DenyAllOut"
      description                = "Deny all outbound traffic"
      priority                   = "4096"
      direction                  = "Outbound"
      access                     = "Deny"
      protocol                   = "*"
      source_address_prefix      = "*"
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "*"
    }
  ]
}


vnets = {
  "default" = {
    address_spaces = ["10.0.0.0/16"]
    subnets = {
      "public" = {
        address_prefix                  = "10.0.1.0/24",
        default_outbound_access_enabled = true
        network_security_group_name     = "default"
        #        nat_gateway_name                = "default"
      },
      "private" = {
        address_prefix                  = "10.0.2.0/24",
        default_outbound_access_enabled = false
      }
      "GatewaySubnet" = {
        address_prefix                  = "10.0.254.0/24",
        default_outbound_access_enabled = false
      }
      "AzureBastionSubnet" = {
        address_prefix                  = "10.0.255.0/24",
        default_outbound_access_enabled = false
      }
    }
  }
}

bastions = {
  "basic001" = {
    sku                  = "Basic"
    virtual_network_name = "default"
  }
}

vms = {
  "vm001" = {
    aliases = [
      "vm-test1",
      "vm-test2"
    ]
    admin_username        = "itinfra"
    admin_public_key_name = "default"
    size                  = "Standard_B1s"
    virtual_network_name  = "default"
    interfaces = [
      {
        ip_configurations = [
          {
            subnet_name = "private"
            #public_ip_address_name = "vm001"
          }
        ]
        network_security_group = "default"
      }
    ]
  }
  #   "vm002" = {
  #     domain = "example2.com"
  #     aliases = [
  #       "test5"
  #     ]
  #     admin_username        = "itinfra"
  #     admin_public_key_name = "default"
  #     size                  = "Standard_B1s"
  #     virtual_network_name  = "default"
  #     interfaces = [
  #       {
  #         ip_configurations = [
  #           {
  #             subnet_name            = "public"
  #             public_ip_address_name = "vm001"
  #           }
  #         ]
  #         network_security_group = "default"
  #       }
  #     ]
  #   }
}

# dns_zones = {
#   "test.itinfra.weu.example.com" = {
#     a_records = {
#       "test" = ["10.10.10.10"]
#     }
#     cname_records = {
#       "test2" = "test"
#     }
#   }
#   "example2.com" = {
#     a_records = {
#       "test" = ["10.10.10.10"]
#     }
#   }
# }

vpns = [
  {
    virtual_network_name = "default"

    virtual_network_gateway = {
      generation    = "Generation1"
      sku           = "VpnGw1AZ"
      active_active = true
      # bgp = {
      #   asn = 65001
      # }
      instances = {
        "instance1" = {
          public_ip_address_name = "pip-vpn-fortigate-instance1"
          # bgp_apipa_addresses    = "169.254.21.1"
        }
        "instance2" = {
          public_ip_address_name = "pip-vpn-fortigate-instance2"
          # bgp_apipa_addresses    = "169.254.22.1"
        }
      }
    }

    local_network_gateways = {
      "home" = {
        gateway_address = "213.118.249.152"
        address_space = [
          "192.168.1.0/24"
        ]
        # bgp_peer = {
        #   asn = 65002
        # }
        connection = {
          #dpd_timeout_seconds = optional(number)
          shared_key          = "kfroi5939flrikd39"
          connection_protocol = "IKEv2"
          enable_bgp          = false

          # custom_bgp_addresses = {
          #   primary = string
          #   secondary = optional(string)
          # }
          ipsec_policy = {
            dh_group         = "DHGroup14"
            ike_encryption   = "GCMAES256"
            ike_integrity    = "SHA384"
            ipsec_encryption = "GCMAES256"
            ipsec_integrity  = "GCMAES256"
            pfs_group        = "None"
            sa_lifetime      = 27000
          }
        }
      }
    }
  }
]
