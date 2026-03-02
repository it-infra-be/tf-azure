<!-- BEGIN_TF_DOCS -->
# Terraform Azure Module: VPN Connection

This module installs an Azure Virtual Network Gateway and its VPN connections.

A virtual network can only contain a single virtual network gateway.

The local network gateways and their connections are only meant to be used by this virtual network gateway.

This module will need a subnet called 'GatewaySubnet'!

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.41 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_connections"></a> [connections](#input\_connections) | Configuration of VPN connections for the virtual network gateway and its local network gateways | <pre>list(object({<br/>    name                       = string<br/>    dpd_timeout_seconds        = optional(number)<br/>    local_network_gateway_name = string<br/>    shared_key                 = string<br/>    connection_protocol        = optional(string, "IKEv2")<br/>    enable_bgp                 = optional(bool) # If not configured: check if VGW bgp is configured<br/>    custom_bgp_addresses = optional(object({<br/>      primary   = string<br/>      secondary = optional(string)<br/>    }))<br/><br/>    ipsec_policy = optional(object({<br/>      dh_group         = string<br/>      ike_encryption   = string<br/>      ike_integrity    = string<br/>      ipsec_encryption = string<br/>      ipsec_integrity  = string<br/>      pfs_group        = string<br/>      sa_datasize      = optional(number)<br/>      sa_lifetime      = optional(number)<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_local_network_gateways"></a> [local\_network\_gateways](#input\_local\_network\_gateways) | Local network gateways to associate with virtual network gateway | <pre>list(object({<br/>    name            = string<br/>    gateway_address = optional(string)<br/>    gateway_fqdn    = optional(string)<br/>    address_space   = list(string)<br/>    bgp_settings = optional(object({<br/>      asn         = number<br/>      bgp_peering_address = string<br/>      peer_weight = optional(number)<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | Location of the vpn connection | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of resource group to which the vpn connection belongs | `string` | n/a | yes |
| <a name="input_virtual_network_gateway"></a> [virtual\_network\_gateway](#input\_virtual\_network\_gateway) | Configuration of the virtual network gateway | <pre>object({<br/>    name          = string<br/>    generation    = optional(string, "Generation1")<br/>    enable_bgp    = optional(bool) # If not configured: check if VGW bgp is configured<br/>    sku           = optional(string, "VpnGw1AZ")<br/>    active_active = optional(string, true)<br/>    subnet_id     = string<br/>    custom_route = optional(object({<br/>      address_prefixes = list(string)<br/>    }))<br/>    bgp_settings = optional(object({<br/>      asn         = number<br/>      peer_weight = optional(number)<br/>    }))<br/>    instances = map(object({<br/>      public_ip_address_name = optional(string)<br/>      public_ip_address_id   = optional(string)<br/>      bgp_apipa_addresses    = optional(list(string))<br/>    }))<br/>  })</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->