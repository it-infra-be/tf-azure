# Info: Naming help: https://learn.microsoft.com/mt-mt/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming
#       Abbreviations: https://learn.microsoft.com/mt-mt/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations
#       Tagging: https://learn.microsoft.com/mt-mt/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging

resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = "rg-itinfra-dev"
}

module "vnet" {
  source              = "./modules/tf-azure-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "westeurope"
  name                = "vnet-itinfra-dev-westeurope-001"
  address_spaces      = ["10.0.0.0/16"]
  subnets = [
    { name = "snet-itinfra-dev-westeurope-001", address_prefix = "10.0.1.0/24", default_outbound_access_enabled = true },
    { name = "snet-itinfra-dev-westeurope-002", address_prefix = "10.0.2.0/24", default_outbound_access_enabled = false }
  ]
}

module "natgw" {
  source              = "./modules/tf-azure-natgw"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "westeurope"
  name                = "natgw-itinfra-dev-westeurope-001"
  subnets             = [module.vnet.subnets["snet-itinfra-dev-westeurope-002"].id]
  public_ips = [
    {
      name = "pip-itinfra-dev-westeurope-natgw-001"
    }
  ]
}

module "bastion" {
  source              = "./modules/tf-azure-bastion"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "westeurope"
  name                = "bastion-itinfra-dev-westeurope-001"
  sku                 = "Basic"
  public_ip_name      = "pip-itinfra-dev-westeurope-bastion-001"
  virtual_network_id  = module.vnet.id
  subnet_prefix       = "10.0.255.0/24"
}

resource "azurerm_ssh_public_key" "sshkey" {
  for_each = { for key in var.public_keys : key.name => key }

  name                = each.key
  resource_group_name = azurerm_resource_group.rg.name
  location            = "westeurope"
  public_key          = each.value.public_key
}

module "vm" {
  source              = "./modules/tf-azure-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "westeurope"
  name                = "vm-itinfra-dev-westeurope-test001"
  admin_username      = "itinfra"
  admin_ssh_key       = azurerm_ssh_public_key.sshkey["sshkey-itinfra-dev-westeurope-001"].public_key
  size                = "Standard_B1s"
  interfaces = [{
    name = "nic-itinfra-dev-westeurope-test001-internal"
    ip_configurations = [{
      name      = "internal"
      subnet_id = module.vnet.subnets["snet-itinfra-dev-westeurope-001"].id
    }]
  }]
}

# module "nsg" {
#   source = "./modules/tf-azure-nsg"
#   name = "test"
#   resource_group_name = var.resource_group_name
#
# }