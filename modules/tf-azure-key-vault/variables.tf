###
# Basics
###
variable "resource_group_name" {
  description = "Name of resource group to which the Key Vault belongs"
  type        = string
}

variable "name" {
  description = "Name of the Key Vault"
  type        = string
}

variable "location" {
  description = "Location of the Key Vault"
  type        = string
}

variable "sku" {
  description = "SKU for the Key Vault"
  type        = string
  default     = "standard"
  nullable    = false

  validation {
    condition     = contains(["standard", "premium"], var.sku)
    error_message = "SKU must be 'standard', 'premium'"
  }
}

variable "soft_delete_retention_days" {
  description = "Soft delete retention days for Key Vault"
  type        = number
  default     = 7
}

variable "purge_protection_enabled" {
  description = "Enable purge protection for Key Vault"
  type        = bool
  default     = false
}

###
# Access Configuration
###
variable "enabled_for_deployment" {
  description = "Enable VMs to retrieve certificates stored as secrets from the Key Vault"
  type        = bool
  default     = false
}

variable "enabled_for_template_deployment" {
  description = "Enable Azure Resource Manager to retrieve secrets from the key vault"
  type        = bool
  default     = false
}

variable "enabled_for_disk_encryption" {
  description = "Enable Azure Disk Encryption to retrieve secrets from the Key Vault and unwrap keys"
  type        = bool
  default     = false
}

###
# Networking
###
variable "public_network_access_enabled" {
  description = "Whether public network access is allowed for this Key Vault"
  type        = bool
  default     = true
}

variable "network_acls" {
  description = "Network ACLs for Key Vault"
  type = object({
    bypass                     = optional(string, "None")
    default_action             = optional(string, "Deny")
    ip_rules                   = optional(list(string))
    virtual_network_subnet_ids = optional(list(string))
  })
  default = null
}
