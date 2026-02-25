# TODO: LNGs can be used by multiple VNGs. But with this module the design is LNGs are linked to one VNG. No problem to create multiple LNGs with the same IP ...

# TODO: Important, only one VNG per VNET!!! So VNET is ID for VPN? -> VPN connections for a VNET (single VNG = hard limit, multiple LNGs/connections)
<!-- BEGIN_TF_DOCS -->
# Terraform Azure Module: VPN Connection

This module installs an Azure VPN Connection.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.41 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_connections"></a> [connections](#input\_connections) | Configuration of VPN connections for the virtual network gateway and its local network gateways | <pre>list(object({<br/>    name                       = string<br/>    dpd_timeout_seconds        = optional(number)<br/>    local_network_gateway_name = string<br/>    shared_key                 = string<br/>    connection_protocol        = optional(string, "IKEv2")<br/>    enable_bgp                 = optional(bool, false)<br/><br/>    custom_bgp_addresses = optional(object({<br/>      primary   = string<br/>      secondary = optional(string)<br/>    }))<br/><br/>    ipsec_policy = optional(object({<br/>      dh_group         = string<br/>      ike_encryption   = string<br/>      ike_integrity    = string<br/>      ipsec_encryption = string<br/>      ipsec_integrity  = string<br/>      pfs_group        = string<br/>      sa_datasize      = optional(number)<br/>      sa_lifetime      = optional(number)<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_local_network_gateways"></a> [local\_network\_gateways](#input\_local\_network\_gateways) | Configuration of local network gateways | <pre>list(object({<br/>    name            = string<br/>    gateway_address = optional(string)<br/>    gateway_fqdn    = optional(string)<br/>    address_space   = list(string)<br/>    bgp_peer = optional(map(object({<br/>      asn         = number<br/>      peer_weight = optional(number)<br/>    })))<br/>  }))</pre> | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | Location of the vpn connection | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of resource group to which the vpn connection belongs | `string` | n/a | yes |
| <a name="input_virtual_network_gateway"></a> [virtual\_network\_gateway](#input\_virtual\_network\_gateway) | Configuration of the virtual network gateway | <pre>object({<br/>    name          = string<br/>    generation    = optional(string, "Generation1")<br/>    sku           = optional(string, "VpnGw1AZ")<br/>    active_active = optional(string, true)<br/>    subnet_id     = string<br/>    custom_route = optional(object({<br/>      address_prefixes = list(string)<br/>    }))<br/>    bgp = optional(object({<br/>      asn         = number<br/>      peer_weight = optional(number)<br/>    }))<br/>    instances = map(object({<br/>      public_ip_address_name = optional(string)<br/>      public_ip_address_id   = optional(string)<br/>      bgp_apipa_addresses    = optional(list(string))<br/>    }))<br/>  })</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->