<!-- BEGIN_TF_DOCS -->
# Terraform Azure Module: DNS Zone and records

This module installs an Azure DNS zone with its records.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_a_records"></a> [a\_records](#input\_a\_records) | DNS A records for the zone | <pre>map(object({<br/>    records = list(string)<br/>    ttl     = optional(number, 300)<br/>  }))</pre> | `{}` | no |
| <a name="input_aaaa_records"></a> [aaaa\_records](#input\_aaaa\_records) | DNS AAAA records for the zone | <pre>map(object({<br/>    records = list(string)<br/>    ttl     = optional(number, 300)<br/>  }))</pre> | `{}` | no |
| <a name="input_caa_records"></a> [caa\_records](#input\_caa\_records) | DNS CAA records for the zone | <pre>map(object({<br/>    records = list(object({<br/>      flags = number<br/>      tag   = string<br/>      value = string<br/>    }))<br/>    ttl = optional(number, 300)<br/>  }))</pre> | `{}` | no |
| <a name="input_cname_records"></a> [cname\_records](#input\_cname\_records) | DNS  CNAME records for the zone | <pre>map(object({<br/>    record = string<br/>    ttl    = optional(number, 300)<br/>  }))</pre> | `{}` | no |
| <a name="input_mx_records"></a> [mx\_records](#input\_mx\_records) | DNS MX records for the zone | <pre>map(object({<br/>    records = list(object({<br/>      preference = number<br/>      exchange   = string<br/>    }))<br/>    ttl = optional(number, 300)<br/>  }))</pre> | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the zone | `string` | n/a | yes |
| <a name="input_ns_records"></a> [ns\_records](#input\_ns\_records) | DNS NS records for the zone | <pre>map(object({<br/>    records = list(string)<br/>    ttl     = optional(number, 300)<br/>  }))</pre> | `{}` | no |
| <a name="input_ptr_records"></a> [ptr\_records](#input\_ptr\_records) | DNS PTR records for the zone | <pre>map(object({<br/>    records = list(string)<br/>    ttl     = optional(number, 300)<br/>  }))</pre> | `{}` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of resource group to which the zone belongs | `string` | n/a | yes |
| <a name="input_srv_records"></a> [srv\_records](#input\_srv\_records) | DNS SRV records for the zone | <pre>map(object({<br/>    records = list(object({<br/>      priority = number<br/>      weight   = number<br/>      port     = number<br/>      target   = string<br/>    }))<br/>    ttl = optional(number, 300)<br/>  }))</pre> | `{}` | no |
| <a name="input_txt_records"></a> [txt\_records](#input\_txt\_records) | DNS TXT records for the zone | <pre>map(object({<br/>    records = list(string)<br/>    ttl     = optional(number, 300)<br/>  }))</pre> | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->