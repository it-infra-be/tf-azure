<!-- BEGIN_TF_DOCS -->
# Terraform Azure Module: Virtual Network

This module installs an Azure Virtual Network and its subnets.

The Virtual Network Subnets can each be associated with an 'Azure Network Security Group'
and an 'Azure NAT Gateway'.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.41 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_spaces"></a> [address\_spaces](#input\_address\_spaces) | Address spaces in the virtual network. | `list(string)` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location of the virtual network. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the virtual network. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of resource group to which the virtual network belongs. | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Subnets in the virtual network. | <pre>list(object({<br/>    name                            = string<br/>    address_prefix                  = string<br/>    default_outbound_access_enabled = optional(bool, false)<br/>    has_network_security_group      = optional(bool, false)<br/>    network_security_group_id       = optional(string)<br/>    has_nat_gateway                 = optional(bool, false)<br/>    nat_gateway_id                  = optional(string)<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Virtual Network. |
| <a name="output_name"></a> [name](#output\_name) | The name of the Virtual Network. |
| <a name="output_nat_gateway_associations"></a> [nat\_gateway\_associations](#output\_nat\_gateway\_associations) | The NAT gateway associated with each subnet. |
| <a name="output_network_security_group_associations"></a> [network\_security\_group\_associations](#output\_network\_security\_group\_associations) | The network security group associated with each subnet. |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | The Virtual Network subnets. |
<!-- END_TF_DOCS -->