project     = "itinfra"
environment = "test"
location    = "westeurope"
base_domain = "example.com"

public_keys = {
  "default" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAXE0oiFQ+Iu7aP43EE32H1wp2SpqpqOw99OPw78wRxw"
}

public_ips = {
  "vm001" = {}
}

natgws = {
  "default" = { public_ip_count = 1 }
}

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
        nat_gateway_name                = "default"
      },
      "private" = {
        address_prefix                  = "10.0.2.0/24",
        default_outbound_access_enabled = false
      }
    }
  }
}

bastions = {
  "basic001" = {
    sku                  = "Basic"
    virtual_network_name = "default"
    subnet_prefix        = "10.0.255.0/24"
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
            subnet_name            = "public"
            public_ip_address_name = "vm001"
          }
        ]
        network_security_group = "default"
      }
    ]
  }
  "vm002" = {
    domain = "example2.com"
    aliases = [
      "test5"
    ]
    admin_username        = "itinfra"
    admin_public_key_name = "default"
    size                  = "Standard_B1s"
    virtual_network_name  = "default"
    interfaces = [
      {
        ip_configurations = [
          {
            subnet_name            = "public"
            public_ip_address_name = "vm001"
          }
        ]
        network_security_group = "default"
      }
    ]
  }
}

dns_zones = {
  "test.itinfra.weu.example.com" = {
    a_records = {
      "test" = ["10.10.10.10"]
    }
    cname_records = {
      "test2" = "test"
    }
  }
  "example2.com" = {
    a_records = {
      "test" = ["10.10.10.10"]
    }
  }
}
