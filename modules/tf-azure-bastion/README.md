<!-- BEGIN_TF_DOCS -->
# Terraform Azure Module: Bastion Host

This module installs an Azure Bastion Host and its public IP address.

This module also configures the 'AzureBastionSubnet' in the provided Virtual Network
with the provided subnet prefix.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.41 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_copy_paste_enabled"></a> [copy\_paste\_enabled](#input\_copy\_paste\_enabled) | Enable Copy/Paste feature for the Bastion Host. | `bool` | `false` | no |
| <a name="input_file_copy_enabled"></a> [file\_copy\_enabled](#input\_file\_copy\_enabled) | Enable File Copy feature for the Bastion Host. | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | Location of the Bastion host. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the Bastion host. | `string` | n/a | yes |
| <a name="input_public_ip_name"></a> [public\_ip\_name](#input\_public\_ip\_name) | The public IP name for the Bastion host. Private only if not provided. Not needed for SKU Developer. | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of resource group to which the Bastion host belongs. | `string` | n/a | yes |
| <a name="input_scale_units"></a> [scale\_units](#input\_scale\_units) | The number of scale units with which to provision the Bastion Host (2-50). | `number` | `null` | no |
| <a name="input_session_recording_enabled"></a> [session\_recording\_enabled](#input\_session\_recording\_enabled) | Enable session recording feature for the Bastion Host. | `bool` | `false` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | SKU for the Bastion Host. | `string` | `"Developer"` | no |
| <a name="input_subnet_prefix"></a> [subnet\_prefix](#input\_subnet\_prefix) | The subnet prefix to place the Bastion host in. Not needed for SKU Developer. | `string` | `null` | no |
| <a name="input_virtual_network_id"></a> [virtual\_network\_id](#input\_virtual\_network\_id) | The Virtual Network ID for the Bastion host. | `string` | n/a | yes |
| <a name="input_zones"></a> [zones](#input\_zones) | Zones to which Bastion Host belongs. | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Bastion Host. |
| <a name="output_name"></a> [name](#output\_name) | The name of the Bastion Host. |
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | The public IP of the Bastion Host. |
<!-- END_TF_DOCS -->