<!-- BEGIN_TF_DOCS -->
# Terraform Azure Module: DNS Zone and records

This module installs an Azure DNS zone with its records.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.41 |

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
| <a name="input_soa_record"></a> [soa\_record](#input\_soa\_record) | DNS SOA record for the zone | <pre>object({<br/>    email         = string<br/>    host_name     = optional(string)<br/>    expire_time   = optional(number)<br/>    minimum_ttl   = optional(number)<br/>    refresh_time  = optional(number)<br/>    retry_time    = optional(number)<br/>    serial_number = optional(number)<br/>    ttl           = optional(number)<br/>  })</pre> | `null` | no |
| <a name="input_srv_records"></a> [srv\_records](#input\_srv\_records) | DNS SRV records for the zone | <pre>map(object({<br/>    records = list(object({<br/>      priority = number<br/>      weight   = number<br/>      port     = number<br/>      target   = string<br/>    }))<br/>    ttl = optional(number, 300)<br/>  }))</pre> | `{}` | no |
| <a name="input_txt_records"></a> [txt\_records](#input\_txt\_records) | DNS TXT records for the zone | <pre>map(object({<br/>    records = list(string)<br/>    ttl     = optional(number, 300)<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the DNS zone |
| <a name="output_name"></a> [name](#output\_name) | The name of the DNS zone |
<!-- END_TF_DOCS -->