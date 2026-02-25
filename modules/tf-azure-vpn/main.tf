/*
 * # Terraform Azure Module: VPN Connection
 *
 * This module installs an Azure VPN Connection.
 *
 * This module also configures the 'GatewaySubnet' in the provided Virtual Network
 * with the provided subnet prefix.
 */

# Public IPs
locals {
  public_ips = {
    for instance_name, instance in var.virtual_network_gateway.instances : instance_name => instance.public_ip_address_name
    if instance.public_ip_address_name != null
  }
}

resource "azurerm_public_ip" "pip" {
  for_each = local.public_ips

  name                = each.value
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = [1, 2, 3] # Zone-redundant
}

# Virtual Network Gateway
resource "azurerm_virtual_network_gateway" "vnetgw" {
  name                = var.virtual_network_gateway.name
  location            = var.location
  resource_group_name = var.resource_group_name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = var.virtual_network_gateway.active_active
  enable_bgp    = var.virtual_network_gateway.bgp != null ? true : false
  sku           = var.virtual_network_gateway.sku

  dynamic ip_configuration {
    for_each = var.virtual_network_gateway.instances

    content {
      name                          = ip_configuration.key
      subnet_id                     = var.virtual_network_gateway.subnet_id
      public_ip_address_id          = ip_configuration.value.public_ip_address_name != null ? azurerm_public_ip.pip[ip_configuration.key].id : ip_configuration.value.public_ip_address_id
      private_ip_address_allocation = "Dynamic"
    }
  }

  dynamic custom_route {
    for_each = var.virtual_network_gateway.custom_route != null ? [true] : []

    content {
      address_prefixes = var.virtual_network_gateway.custom_route.address_prefixes
    }
  }

  dynamic "bgp_settings" {
    for_each = var.virtual_network_gateway.bgp != null ? var.virtual_network_gateway.instances : {}

    content {
      asn = var.virtual_network_gateway.bgp.asn
      peer_weight = var.virtual_network_gateway.bgp.peer_weight
      peering_addresses {
        ip_configuration_name = bgp_settings.key
        apipa_addresses = bgp_settings.value.bgp_apipa_addresses
      }
    }
  }
}

# Local Network Gateways
resource "azurerm_local_network_gateway" "lnetgw" {
  for_each = { for lgw in var.local_network_gateways: lgw.name => lgw }

  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name
  gateway_address     = each.value.gateway_address
  gateway_fqdn        = each.value.gateway_fqdn
  address_space       = each.value.address_space

  dynamic "bgp_settings" {
    for_each = each.value.bgp_peer != null ? each.value.bgp_peer : {}

    content {
      bgp_peering_address = bgp_settings.key
      asn = bgp_settings.value.asn
      peer_weight = bgp_settings.value.peer_weight
    }
  }
}

# Tunnel Connections
resource "azurerm_virtual_network_gateway_connection" "connection" {
  for_each = { for vcn in var.connections: vcn.name => vcn }

  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name
  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vnetgw.id
  local_network_gateway_id   = azurerm_local_network_gateway.lnetgw[each.value.local_network_gateway_name].id
  shared_key = each.value.shared_key
  connection_mode = "Default"
  connection_protocol = each.value.connection_protocol
  enable_bgp = each.value.enable_bgp

  dynamic "custom_bgp_addresses" {
    for_each = each.value.custom_bgp_addresses != null ? [true] : []

    content {
      primary = each.value.custom_bgp_addresses.primary
      secondary = each.value.custom_bgp_addresses.secondary
    }
  }

  dynamic "ipsec_policy" {
    for_each = each.value.ipsec_policy!= null ? [true] : []

    content {
      dh_group         = each.value.ipsec_policy.dh_group
      ike_encryption   = each.value.ipsec_policy.ike_encryption
      ike_integrity    = each.value.ipsec_policy.ike_integrity
      ipsec_encryption = each.value.ipsec_policy.ipsec_encryption
      ipsec_integrity  = each.value.ipsec_policy.ipsec_integrity
      pfs_group        = each.value.ipsec_policy.pfs_group
      sa_datasize      = each.value.ipsec_policy.sa_datasize
      sa_lifetime      = each.value.ipsec_policy.sa_lifetime
    }
  }
}
