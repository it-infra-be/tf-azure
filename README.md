<!-- BEGIN_TF_DOCS -->
# Terraform Azure

This repository provides a collection of Terraform Azure Modules.
This collection can be used to create an Azure Resource Group together with all its resources.

Extra Information:
  - Naming help: https://learn.microsoft.com/mt-mt/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming
  - Abbreviations: https://learn.microsoft.com/mt-mt/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations
  - Tagging: https://learn.microsoft.com/mt-mt/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.41.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bastions"></a> [bastions](#module\_bastions) | ./modules/tf-azure-bastion | n/a |
| <a name="module_natgws"></a> [natgws](#module\_natgws) | ./modules/tf-azure-natgw | n/a |
| <a name="module_nsgs"></a> [nsgs](#module\_nsgs) | ./modules/tf-azure-nsg | n/a |
| <a name="module_vms"></a> [vms](#module\_vms) | ./modules/tf-azure-vm | n/a |
| <a name="module_vnets"></a> [vnets](#module\_vnets) | ./modules/tf-azure-vnet | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bastions"></a> [bastions](#input\_bastions) | Bastion Hosts | <pre>list(object({<br/>    name                      = string<br/>    sku                       = optional(string)<br/>    virtual_network_name      = string<br/>    subnet_prefix             = optional(string)<br/>    copy_paste_enabled        = optional(bool)<br/>    file_copy_enabled         = optional(bool)<br/>    scale_units               = optional(number)<br/>    session_recording_enabled = optional(bool)<br/>    zones                     = optional(list(string))<br/>  }))</pre> | `[]` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Name of environment these resources belong to | `any` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location these resources belong to | `any` | n/a | yes |
| <a name="input_natgws"></a> [natgws](#input\_natgws) | NAT gateways | <pre>list(object({<br/>    name                     = string<br/>    sku_name                 = optional(string)<br/>    idle_timeout_in_minutes  = optional(number)<br/>    zone                     = optional(string)<br/>    public_ip_address_count  = optional(number, 1)<br/>    public_ip_prefix_lengths = optional(list(number))<br/>  }))</pre> | `[]` | no |
| <a name="input_nsgs"></a> [nsgs](#input\_nsgs) | Network security groups and their rules | <pre>list(object({<br/>    name = string<br/>    rules = list(object({<br/>      name                                       = string<br/>      description                                = string<br/>      priority                                   = number<br/>      direction                                  = string<br/>      access                                     = string<br/>      protocol                                   = string<br/>      source_address_prefix                      = optional(string)<br/>      source_address_prefixes                    = optional(list(string))<br/>      source_application_security_group_ids      = optional(list(string))<br/>      source_port_range                          = optional(string)<br/>      source_port_ranges                         = optional(list(string))<br/>      destination_address_prefix                 = optional(string)<br/>      destination_address_prefixes               = optional(list(string))<br/>      destination_application_security_group_ids = optional(list(string))<br/>      destination_port_range                     = optional(string)<br/>      destination_port_ranges                    = optional(list(string))<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_project"></a> [project](#input\_project) | Name of project these resources belong to | `any` | n/a | yes |
| <a name="input_public_ips"></a> [public\_ips](#input\_public\_ips) | Reserved static public IP addresses | <pre>list(object({<br/>    name  = string<br/>    zones = optional(list(string), []) # [] = Zone-redundant<br/>  }))</pre> | `[]` | no |
| <a name="input_public_keys"></a> [public\_keys](#input\_public\_keys) | SSH public keys | <pre>list(object({<br/>    name       = string<br/>    public_key = string<br/>  }))</pre> | n/a | yes |
| <a name="input_vms"></a> [vms](#input\_vms) | Virtual machines | <pre>list(object({<br/>    name                  = string<br/>    virtual_network_name  = string<br/>    zone                  = optional(string)<br/>    admin_username        = string<br/>    admin_public_key_name = string<br/>    size                  = string<br/>    user_data             = optional(string)<br/>    os_disk = optional(object({<br/>      disk_size_gb         = optional(number)<br/>      caching              = optional(string, "ReadWrite")<br/>      storage_account_type = optional(string, "Standard_LRS")<br/>    }))<br/>    source_image_reference = optional(object({<br/>      publisher = string<br/>      offer     = string<br/>      sku       = string<br/>      version   = string<br/>    }))<br/>    interfaces = list(object({<br/>      ip_forwarding_enabled          = optional(bool)<br/>      accelerated_networking_enabled = optional(bool)<br/>      internal_dns_name_label        = optional(string)<br/>      ip_configurations = list(object({<br/>        subnet_name                = string<br/>        primary                    = optional(bool)<br/>        private_ip_address_version = optional(string)<br/>        private_ip_address         = optional(string)<br/>        public_ip_address_name     = optional(string)<br/>      }))<br/>      network_security_group_name = optional(string)<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_vnets"></a> [vnets](#input\_vnets) | Network security groups and their rules | <pre>list(object({<br/>    name           = string<br/>    address_spaces = list(string)<br/>    subnets = list(object({<br/>      name                            = string<br/>      address_prefix                  = string<br/>      default_outbound_access_enabled = optional(bool, false)<br/>      network_security_group_name     = optional(string)<br/>      nat_gateway_name                = optional(string)<br/>    }))<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | n/a |
<!-- END_TF_DOCS -->