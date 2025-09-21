/*
 * # Terraform Azure
 *
 * This repository provides a collection of Terraform Azure Modules.
 *
 * This collection can also be used to create an Azure resource group together with all its resources.
 * A resource group belongs to a project, environment and location and can be configured in a separate 'tfvars' file.
 *
 */

/*
 * Extra Information:
 *   - Naming help: https://learn.microsoft.com/mt-mt/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming
 *   - Abbreviations: https://learn.microsoft.com/mt-mt/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations
 *   - Tagging: https://learn.microsoft.com/mt-mt/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging
 */

###
# Local variables declaration
###
locals {
  locations = {
    "westeurope"         = "weu"
    "northeurope"        = "neu"
    "uksouth"            = "uks"
    "ukwest"             = "ukw"
    "francecentral"      = "frc"
    "germanywestcentral" = "gwc"
    "swedencentral"      = "sec"
    "swedensouth"        = "ses"
    "eastus"             = "eus"
    "eastus2"            = "eus2"
    "centralus"          = "cus"
    "northcentralus"     = "ncus"
    "southcentralus"     = "scus"
    "westus"             = "wus"
    "westus2"            = "wus2"
    "westus3"            = "wus3"
    "canadacentral"      = "cac"
    "canadaeast"         = "cae"
    "brazilsouth"        = "brs"
    "brazilsoutheast"    = "brse"
    "australiaeast"      = "aue"
    "australiasoutheast" = "ause"
    "australiacentral"   = "auc"
    "australiacentral2"  = "auc2"
    "japaneast"          = "jpe"
    "japanwest"          = "jpw"
    "koreacentral"       = "krc"
    "koreasouth"         = "krs"
    "southeastasia"      = "sea"
    "eastasia"           = "eas"
    "centralindia"       = "inc"
    "southindia"         = "ins"
    "westindia"          = "inw"
    "southafricanorth"   = "zan"
    "southafricawest"    = "zaw"
    "uaenorth"           = "uaen"
    "uaecentral"         = "uaec"
  }
  context = "${var.project}-${var.environment}-${local.locations[var.location]}"
}

###
# Resource Group configuration
###
resource "azurerm_resource_group" "rg" {
  name     = "rg-${local.context}"
  location = var.location # RG metadata location
}

# Public IPs
resource "azurerm_public_ip" "pip" {
  for_each = var.public_ips

  name                = "pip-${local.context}-${each.key}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = each.value.zones
}

###
# NAT Gateways configuration
###
module "natgws" {
  for_each = var.natgws

  source                  = "./modules/tf-azure-natgw"
  resource_group_name     = azurerm_resource_group.rg.name
  location                = var.location
  name                    = "natgw-${local.context}-${each.key}"
  idle_timeout_in_minutes = each.value.idle_timeout_in_minutes
  zone                    = each.value.zone
  new_public_ip_addresses = [for count in range(each.value.public_ip_address_count) :
    { name = "pip-${local.context}-natgw-${each.key}-${count + 1}" }
  ]
  new_public_ip_prefixes = each.value.public_ip_prefix_lengths != null ? [
    for idx, prefix_length in each.value.public_ip_prefix_lengths :
    {
      name   = "pippre-${local.context}-natgw-${each.key}-${idx + 1}"
      length = prefix_length
    }
  ] : null
}

###
# Network Security Groups configuration
###
module "nsgs" {
  for_each = var.nsgs

  source              = "./modules/tf-azure-nsg"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  name                = "nsg-${local.context}-${each.key}"
  rules               = each.value
}

###
# Virtual Networks configuration
###
module "vnets" {
  for_each = var.vnets

  source              = "./modules/tf-azure-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  name                = "vnet-${local.context}-${each.key}"
  address_spaces      = each.value.address_spaces
  subnets = [
    for subnet_key, subnet_value in each.value.subnets :
    {
      name                            = subnet_key
      address_prefix                  = subnet_value.address_prefix
      default_outbound_access_enabled = subnet_value.default_outbound_access_enabled
      has_network_security_group      = subnet_value.network_security_group_name != null ? true : false
      network_security_group_id       = subnet_value.network_security_group_name != null ? module.nsgs[subnet_value.network_security_group_name].id : null
      has_nat_gateway                 = subnet_value.nat_gateway_name != null ? true : false
      nat_gateway_id                  = subnet_value.nat_gateway_name != null ? module.natgws[subnet_value.nat_gateway_name].id : null
    }
  ]
}

###
# Bastion Hosts configuration
###
module "bastions" {
  for_each = var.bastions

  source                    = "./modules/tf-azure-bastion"
  resource_group_name       = azurerm_resource_group.rg.name
  location                  = module.vnets[each.value.virtual_network_name].location
  name                      = "bastion-${local.context}-${each.key}"
  sku                       = each.value.sku
  new_public_ip_address     = { name = "pip-${local.context}-bastion-${each.key}" }
  virtual_network_id        = module.vnets[each.value.virtual_network_name].id
  subnet_prefix             = each.value.subnet_prefix
  copy_paste_enabled        = each.value.copy_paste_enabled
  file_copy_enabled         = each.value.file_copy_enabled
  scale_units               = each.value.scale_units
  session_recording_enabled = each.value.session_recording_enabled
  zones                     = each.value.zones
}

###
# Virtual Machines configuration
###
resource "azurerm_ssh_public_key" "sshkeys" {
  for_each = var.public_keys

  name                = "sshkey-${local.context}-${each.key}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  public_key          = each.value
}

module "vms" {
  for_each = var.vms

  source              = "./modules/tf-azure-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = module.vnets[each.value.virtual_network_name].location
  name                = "vm-${local.context}-${each.key}"
  zone                = each.value.zone
  admin_username      = each.value.admin_username
  admin_public_key    = azurerm_ssh_public_key.sshkeys[each.value.admin_public_key_name].public_key
  size                = each.value.size
  user_data           = each.value.user_data
  os_disk = merge(
    { name = "osdisk-${local.context}-vm-${each.key}" },
    each.value.os_disk != null ? each.value.os_disk : {}
  )
  source_image_reference = each.value.source_image_reference
  interfaces = [
    for idx, interface in each.value.interfaces :
    {
      name                           = "nic-${local.context}-vm-${each.key}-${idx}"
      ip_forwarding_enabled          = interface.ip_forwarding_enabled
      accelerated_networking_enabled = interface.accelerated_networking_enabled
      internal_dns_name_label        = interface.internal_dns_name_label
      ip_configurations = [
        for ip_configuration in interface.ip_configurations :
        {
          name                       = ip_configuration.subnet_name
          subnet_id                  = module.vnets[each.value.virtual_network_name].subnets[ip_configuration.subnet_name].id
          primary                    = ip_configuration.primary
          private_ip_address_version = ip_configuration.private_ip_address_version
          private_ip_address         = ip_configuration.private_ip_address
          public_ip_addres_id        = ip_configuration.public_ip_address_name != null ? azurerm_public_ip.pip[ip_configuration.public_ip_address_name].id : null
        }
      ]
      network_security_group_id = interface.network_security_group_name != null ? module.nsgs[interface.network_security_group_name].id : null
    }
  ]
}

###
# DNS Zones
###
locals {
  # Create VM a_records (DNS zone name -> A records)
  vm_a_records = {
    for dns_zone_name, dns_zone_records in var.dns_zones : dns_zone_name => {
      for vm_name, vm_value in var.vms : vm_name => [module.vms[vm_name].private_ip_address]
      if (vm_value.domain == dns_zone_name)
    }
  }

  # Create VM a_records (DNS zone name -> CNAME records)
  vm_cname_records = { for dns_zone_name, dns_zone_records in var.dns_zones : dns_zone_name => merge([
    for vm_name, vm_value in var.vms : {
      for alias in vm_value.aliases : alias => vm_name
      if vm_value.aliases != null }
    if vm_value.domain == dns_zone_name ]...) }
}

module "dns_zones" {
  for_each = var.dns_zones

  source              = "./modules/tf-azure-dns-zone"
  resource_group_name = azurerm_resource_group.rg.name
  name                = each.key
  a_records           = { for name, record in merge(each.value.a_records, local.vm_a_records[each.key]) : name => { records = record } }
  aaaa_records        = { for name, record in each.value.aaaa_records : name => { records = record } }
  ptr_records         = { for name, record in each.value.ptr_records : name => { records = record } }
  cname_records       = { for name, record in merge(each.value.cname_records, local.vm_cname_records[each.key]) : name => { record = record } }
  ns_records          = { for name, record in each.value.ns_records : name => { records = record } }
  txt_records         = { for name, record in each.value.txt_records : name => { records = record } }
  mx_records          = { for name, record in each.value.mx_records : name => { records = record } }
  srv_records         = { for name, record in each.value.srv_records : name => { records = record } }
  caa_records         = { for name, record in each.value.caa_records : name => { records = record } }
}