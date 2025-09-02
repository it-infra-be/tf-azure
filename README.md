<!-- BEGIN_TF_DOCS -->
# Terraform Azure: Resource Group

This repository provides a collection of Terraform Azure Modules.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.41.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_nsg"></a> [nsg](#module\_nsg) | ./modules/tf-azure-nsg | n/a |
| <a name="module_vnet"></a> [vnet](#module\_vnet) | ./modules/tf-azure-vnet | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_public_keys"></a> [public\_keys](#input\_public\_keys) | SSH Keys. | <pre>list(object({<br/>    name       = string<br/>    public_key = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "name": "sshkey-itinfra-dev-westeurope-001",<br/>    "public_key": "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAXE0oiFQ+Iu7aP43EE32H1wp2SpqpqOw99OPw78wRxw"<br/>  },<br/>  {<br/>    "name": "sshkey-itinfra-dev-westeurope-002",<br/>    "public_key": "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGYnEL0h6e2CUB8ryyGKvgU2V1ZJsPoA7FJEe56hkQGp"<br/>  }<br/>]</pre> | no |
| <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location) | Location of the resource group (metadata). | `string` | `"westeurope"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of resource group. | `string` | `"itinfra-rg"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | n/a |
<!-- END_TF_DOCS -->