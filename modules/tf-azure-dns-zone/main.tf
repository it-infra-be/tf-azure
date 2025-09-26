/*
 * # Terraform Azure Module: DNS Zone and records
 *
 * This module installs an Azure DNS zone with its records.
 */
# Zone
resource "azurerm_dns_zone" "zone" {
  name                = var.name
  resource_group_name = var.resource_group_name

  dynamic "soa_record" {
    for_each = var.soa_record != null ? [1] : []

    content {
      email         = var.soa_record.email
      host_name     = var.soa_record.host_name
      expire_time   = var.soa_record.expire_time
      minimum_ttl   = var.soa_record.minimum_ttl
      refresh_time  = var.soa_record.refresh_time
      retry_time    = var.soa_record.retry_time
      serial_number = var.soa_record.serial_number
      ttl           = var.soa_record.ttl
    }
  }
}

# Records
resource "azurerm_dns_a_record" "a" {
  for_each = var.a_records

  zone_name           = azurerm_dns_zone.zone.name
  resource_group_name = var.resource_group_name
  name                = each.key
  ttl                 = each.value.ttl
  records             = each.value.records
}

resource "azurerm_dns_aaaa_record" "aaaa" {
  for_each = var.aaaa_records

  zone_name           = azurerm_dns_zone.zone.name
  resource_group_name = var.resource_group_name
  name                = each.key
  ttl                 = each.value.ttl
  records             = each.value.records
}

resource "azurerm_dns_cname_record" "cname" {
  for_each = var.cname_records

  zone_name           = azurerm_dns_zone.zone.name
  resource_group_name = var.resource_group_name
  name                = each.key
  ttl                 = each.value.ttl
  record              = each.value.record
}

resource "azurerm_dns_ns_record" "ns" {
  for_each = var.ns_records

  zone_name           = azurerm_dns_zone.zone.name
  resource_group_name = var.resource_group_name
  name                = each.key
  ttl                 = each.value.ttl
  records             = each.value.records
}

resource "azurerm_dns_ptr_record" "ns" {
  for_each = var.ptr_records

  zone_name           = azurerm_dns_zone.zone.name
  resource_group_name = var.resource_group_name
  name                = each.key
  ttl                 = each.value.ttl
  records             = each.value.records
}

resource "azurerm_dns_txt_record" "txt" {
  for_each = var.txt_records

  zone_name           = azurerm_dns_zone.zone.name
  resource_group_name = var.resource_group_name
  name                = each.key
  ttl                 = each.value.ttl

  dynamic "record" {
    for_each = each.value.records

    content {
      value = record.value
    }
  }
}

resource "azurerm_dns_mx_record" "mx" {
  for_each = var.mx_records

  zone_name           = azurerm_dns_zone.zone.name
  resource_group_name = var.resource_group_name
  name                = each.key
  ttl                 = each.value.ttl

  dynamic "record" {
    for_each = each.value.records

    content {
      preference = record.value.preference
      exchange   = record.value.exchange
    }
  }
}

resource "azurerm_dns_srv_record" "srv" {
  for_each = var.srv_records

  zone_name           = azurerm_dns_zone.zone.name
  resource_group_name = var.resource_group_name
  name                = each.key
  ttl                 = each.value.ttl

  dynamic "record" {
    for_each = each.value.records

    content {
      priority = record.value.priority
      weight   = record.value.weight
      port     = record.value.port
      target   = record.value.target
    }
  }
}

resource "azurerm_dns_caa_record" "caa" {
  for_each = var.caa_records

  zone_name           = azurerm_dns_zone.zone.name
  resource_group_name = var.resource_group_name
  name                = each.key
  ttl                 = each.value.ttl

  dynamic "record" {
    for_each = each.value.records

    content {
      flags = record.value.flags
      tag   = record.value.tag
      value = record.value.value
    }
  }
}
