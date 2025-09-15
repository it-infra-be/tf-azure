project     = "itinfra"
environment = "test"
location    = "westeurope"

public_keys = [
  {
    name       = "default"
    public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAXE0oiFQ+Iu7aP43EE32H1wp2SpqpqOw99OPw78wRxw"
  },
]

public_ips = [
  {
    name = "vm001"
  }
]

natgws = [
  {
    name            = "default"
    public_ip_count = 1
  }
]

nsgs = [
  {
    name = "default"
    rules = [
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
]

vnets = [
  {
    name           = "default"
    address_spaces = ["10.0.0.0/16"]
    subnets = [
      {
        name                            = "public",
        address_prefix                  = "10.0.1.0/24",
        default_outbound_access_enabled = true
        network_security_group_name     = "default"
        nat_gateway_name                = "default"
      },
      {
        name                            = "private",
        address_prefix                  = "10.0.2.0/24",
        default_outbound_access_enabled = false
      }
    ]
  }
]

bastions = [
  {
    name                 = "basic01"
    sku                  = "Basic"
    virtual_network_name = "default"
    subnet_prefix        = "10.0.255.0/24"
  }
]

vms = [
  {
    name                  = "vm001"
    admin_username        = "itinfra"
    admin_public_key_name = "default"
    size                  = "Standard_B1s"
    virtual_network_name  = "default"
    interfaces = [{
      ip_configurations = [{
        subnet_name            = "public"
        public_ip_address_name = "vm001"
      }]
      network_security_group = "default"
    }]
  }
]
