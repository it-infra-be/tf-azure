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
  for_each = { for public_ip in var.public_ips : public_ip.name => public_ip }

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
  for_each = { for natgw in var.natgws : natgw.name => natgw }

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
  for_each = { for nsg in var.nsgs : nsg.name => nsg }

  source              = "./modules/tf-azure-nsg"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  name                = "nsg-${local.context}-${each.key}"
  rules               = each.value.rules
}

###
# Virtual Networks configuration
###
module "vnets" {
  for_each = { for vnet in var.vnets : vnet.name => vnet }

  source              = "./modules/tf-azure-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  name                = "vnet-${local.context}-${each.key}"
  address_spaces      = each.value.address_spaces
  subnets = [
    for subnet in each.value.subnets :
    {
      name                            = subnet.name
      address_prefix                  = subnet.address_prefix
      default_outbound_access_enabled = subnet.default_outbound_access_enabled
      has_network_security_group      = subnet.network_security_group_name != null ? true : false
      network_security_group_id       = subnet.network_security_group_name != null ? module.nsgs[subnet.network_security_group_name].id : null
      has_nat_gateway                 = subnet.nat_gateway_name != null ? true : false
      nat_gateway_id                  = subnet.nat_gateway_name != null ? module.natgws[subnet.nat_gateway_name].id : null
    }
  ]
}

###
# Bastion Hosts configuration
###
module "bastions" {
  for_each = { for bastion in var.bastions : bastion.name => bastion }

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
  for_each = { for sshkey in var.public_keys : sshkey.name => sshkey }

  name                = "sshkey-${local.context}-${each.key}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  public_key          = each.value.public_key
}

module "vms" {
  for_each = { for vm in var.vms : vm.name => vm }

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
