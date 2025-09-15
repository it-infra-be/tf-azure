<!-- BEGIN_TF_DOCS -->
# Terraform Azure Module: NAT Gateway

This module installs an Azure NAT Gateway together with its public IPs and public IP prefixes.

The NAT Gateway associations are handled by the resources that need it.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.41 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_idle_timeout_in_minutes"></a> [idle\_timeout\_in\_minutes](#input\_idle\_timeout\_in\_minutes) | TCP idle timeout of the NAT Gateway | `number` | `4` | no |
| <a name="input_location"></a> [location](#input\_location) | Location of the NAT Gateway | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the NAT Gateway | `string` | n/a | yes |
| <a name="input_new_public_ip_addresses"></a> [new\_public\_ip\_addresses](#input\_new\_public\_ip\_addresses) | New public IP addresses to associate with the NAT Gateway | <pre>list(object({<br/>    name  = string<br/>    zones = optional(list(string))<br/>  }))</pre> | `[]` | no |
| <a name="input_new_public_ip_prefixes"></a> [new\_public\_ip\_prefixes](#input\_new\_public\_ip\_prefixes) | New public IP prefixes to associate with the NAT Gateway | <pre>list(object({<br/>    name   = string<br/>    length = number<br/>    zones  = optional(list(string))<br/>  }))</pre> | `[]` | no |
| <a name="input_public_ip_address_ids"></a> [public\_ip\_address\_ids](#input\_public\_ip\_address\_ids) | Existing public IP addresses to associate with the NAT Gateway | `list(string)` | `[]` | no |
| <a name="input_public_ip_prefix_ids"></a> [public\_ip\_prefix\_ids](#input\_public\_ip\_prefix\_ids) | Existing public IP prefixes to associate with the NAT Gateway | `list(string)` | `[]` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of resource group to which the NAT Gateway belongs | `string` | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | SKU Name of the NAT Gateway | `string` | `"Standard"` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | Zone to which NAT Gateway belongs | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the NAT gateway |
| <a name="output_location"></a> [location](#output\_location) | The location of the NAT gateway |
| <a name="output_name"></a> [name](#output\_name) | The name of the NAT gateway |
| <a name="output_public_ip_prefixes"></a> [public\_ip\_prefixes](#output\_public\_ip\_prefixes) | The public IP prefixes of the NAT gateway |
| <a name="output_public_ips"></a> [public\_ips](#output\_public\_ips) | The public IPs of the NAT gateway |
| <a name="output_zone"></a> [zone](#output\_zone) | The zone of the NAT gateway |
<!-- END_TF_DOCS -->