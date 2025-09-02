<!-- BEGIN_TF_DOCS -->
# Terraform Azure Module: Network Security Group

This module installs an Azure Network Security Group and its rules.

The Network Security Group associations are handled by the resources that need it.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.41 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | Location of the network security group. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the network security group. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of resource group to which the network security group belongs. | `string` | n/a | yes |
| <a name="input_rules"></a> [rules](#input\_rules) | Network security group rules. | <pre>list(object({<br/>    name                                       = string<br/>    description                                = string<br/>    priority                                   = number<br/>    direction                                  = string<br/>    access                                     = string<br/>    protocol                                   = string<br/>    source_address_prefix                      = optional(string)<br/>    source_address_prefixes                    = optional(list(string))<br/>    source_application_security_group_ids      = optional(list(string))<br/>    source_port_range                          = optional(string)<br/>    source_port_ranges                         = optional(list(string))<br/>    destination_address_prefix                 = optional(string)<br/>    destination_address_prefixes               = optional(list(string))<br/>    destination_application_security_group_ids = optional(list(string))<br/>    destination_port_range                     = optional(string)<br/>    destination_port_ranges                    = optional(list(string))<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the network security group. |
| <a name="output_location"></a> [location](#output\_location) | The location of the network security group. |
| <a name="output_name"></a> [name](#output\_name) | The name of the network security group. |
<!-- END_TF_DOCS -->