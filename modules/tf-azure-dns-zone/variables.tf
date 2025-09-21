variable "resource_group_name" {
  description = "Name of resource group to which the zone belongs"
  type        = string
}

variable "name" {
  description = "Name of the zone"
  type        = string
}

variable "a_records" {
  description = "DNS A records for the zone"
  type = map(object({
    records = list(string)
    ttl     = optional(number, 300)
  }))
  default  = {}
  nullable = false
}

variable "aaaa_records" {
  description = "DNS AAAA records for the zone"
  type = map(object({
    records = list(string)
    ttl     = optional(number, 300)
  }))
  default  = {}
  nullable = false
}

variable "cname_records" {
  description = "DNS  CNAME records for the zone"
  type = map(object({
    record = string
    ttl    = optional(number, 300)
  }))
  default  = {}
  nullable = false
}

variable "ns_records" {
  description = "DNS NS records for the zone"
  type = map(object({
    records = list(string)
    ttl     = optional(number, 300)
  }))
  default  = {}
  nullable = false
}

variable "ptr_records" {
  description = "DNS PTR records for the zone"
  type = map(object({
    records = list(string)
    ttl     = optional(number, 300)
  }))
  default  = {}
  nullable = false
}

variable "txt_records" {
  description = "DNS TXT records for the zone"
  type = map(object({
    records = list(string)
    ttl     = optional(number, 300)
  }))
  default  = {}
  nullable = false
}

variable "mx_records" {
  description = "DNS MX records for the zone"
  type = map(object({
    records = list(object({
      preference = number
      exchange   = string
    }))
    ttl = optional(number, 300)
  }))
  default  = {}
  nullable = false
}

variable "srv_records" {
  description = "DNS SRV records for the zone"
  type = map(object({
    records = list(object({
      priority = number
      weight   = number
      port     = number
      target   = string
    }))
    ttl = optional(number, 300)
  }))
  default  = {}
  nullable = false
}

variable "caa_records" {
  description = "DNS CAA records for the zone"
  type = map(object({
    records = list(object({
      flags = number
      tag   = string
      value = string
    }))
    ttl = optional(number, 300)
  }))
  default  = {}
  nullable = false
}
