variable "resource_group_name" {
  description = "Name of resource group to which the Bastion host belongs."
  type        = string
}

variable "name" {
  description = "Name of the Bastion host."
  type        = string
}

variable "location" {
  description = "Location of the Bastion host."
  type        = string
}

variable "sku" {
  description = "SKU for the Bastion Host."
  type        = string
  default     = "Developer"
  nullable    = false

  validation {
    condition     = contains(["Developer", "Basic", "Standard", "Premium"], var.sku)
    error_message = "SKU must be 'Developer', 'Basic', 'Standard' or 'Premium'."
  }
}

variable "public_ip_name" {
  description = "The public IP name for the Bastion host. Private only if not provided. Not needed for SKU Developer."
  type        = string
  default     = null
}

variable "virtual_network_id" {
  description = "The Virtual Network ID for the Bastion host."
  type        = string
}

variable "subnet_prefix" {
  description = "The subnet prefix to place the Bastion host in. Not needed for SKU Developer."
  type        = string
  default     = null

  validation {
    condition     = var.sku == "Developer" || var.subnet_prefix != null
    error_message = "Subnet prefix has to be defined if SKU is not 'Developer'."
  }
}

variable "copy_paste_enabled" {
  description = "Enable Copy/Paste feature for the Bastion Host."
  type        = bool
  default     = false
  nullable    = false
}

variable "file_copy_enabled" {
  description = "Enable File Copy feature for the Bastion Host."
  type        = bool
  default     = false
  nullable    = false
}

variable "scale_units" {
  description = "The number of scale units with which to provision the Bastion Host (2-50)."
  type        = number
  default     = null
}

variable "session_recording_enabled" {
  description = "Enable session recording feature for the Bastion Host."
  type        = bool
  default     = false
  nullable    = false
}

variable "zones" {
  description = "Zones to which Bastion Host belongs."
  type        = list(string)
  default     = null
}
