<!-- BEGIN_TF_DOCS -->
# Terraform Azure Module: Virtual Machine

This module installs an Azure (Linux) Virtual Machine.

This Virtual Machine can also be associated with an Azure Network Security Group.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.41 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_public_key"></a> [admin\_public\_key](#input\_admin\_public\_key) | Public SSH Key of the local administrator for the virtual machine | `string` | n/a | yes |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | Name of the local administrator for the virtual machine | `string` | n/a | yes |
| <a name="input_interfaces"></a> [interfaces](#input\_interfaces) | Virtual machine interfaces | <pre>list(object({<br/>    name                           = string<br/>    ip_forwarding_enabled          = optional(bool)<br/>    accelerated_networking_enabled = optional(bool)<br/>    internal_dns_name_label        = optional(string)<br/>    ip_configurations = list(object({<br/>      name                       = string<br/>      subnet_id                  = string<br/>      primary                    = optional(bool)<br/>      private_ip_address_version = optional(string)<br/>      private_ip_address         = optional(string)<br/>      public_ip_address_id       = optional(string)<br/>    }))<br/>    has_network_security_group = optional(bool, false)<br/>    network_security_group_id  = optional(string)<br/>  }))</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location of the virtual machine | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the virtual machine | `string` | n/a | yes |
| <a name="input_os_disk"></a> [os\_disk](#input\_os\_disk) | OS disk for this Virtual Machine | <pre>object({<br/>    name                 = optional(string)<br/>    disk_size_gb         = optional(number)<br/>    caching              = optional(string, "ReadWrite")<br/>    storage_account_type = optional(string, "Standard_LRS")<br/>  })</pre> | `{}` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of resource group to which the virtual machine belongs | `string` | n/a | yes |
| <a name="input_size"></a> [size](#input\_size) | Type of virtual machine | `string` | n/a | yes |
| <a name="input_source_image_reference"></a> [source\_image\_reference](#input\_source\_image\_reference) | Source Image reference of the Virtual Machine | <pre>object({<br/>    publisher = string<br/>    offer     = string<br/>    sku       = string<br/>    version   = string<br/>  })</pre> | <pre>{<br/>  "offer": "almalinux-x86_64",<br/>  "publisher": "almalinux",<br/>  "sku": "9-gen1",<br/>  "version": "latest"<br/>}</pre> | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | User Data which should be used for this Virtual Machine | `string` | `null` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | Zone in which Virtual Machine should be located | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Linux Virtual Machine |
| <a name="output_interfaces"></a> [interfaces](#output\_interfaces) | The Linux Virtual Machine interfaces |
| <a name="output_location"></a> [location](#output\_location) | The location of the Linux Virtual Machine |
| <a name="output_name"></a> [name](#output\_name) | The name of the Linux Virtual Machine |
| <a name="output_network_security_group_associations"></a> [network\_security\_group\_associations](#output\_network\_security\_group\_associations) | The network security group associated with each interface |
| <a name="output_private_ip_address"></a> [private\_ip\_address](#output\_private\_ip\_address) | The primary private IP address of the Linux Virtual Machine |
| <a name="output_public_ip_address"></a> [public\_ip\_address](#output\_public\_ip\_address) | The primary public IP address of the Linux Virtual Machine |
<!-- END_TF_DOCS -->