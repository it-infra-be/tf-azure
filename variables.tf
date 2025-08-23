variable "resource_group_location" {
  type        = string
  default     = "westeurope"
  description = "Location of the resource group (metadata)."
}

variable "resource_group_name" {
  type        = string
  default     = "itinfra-rg"
  description = "Name of resource group."
}

variable "public_keys" {
  description = "SSH Keys."
  type = list(object({
    name       = string
    public_key = string
  }))
  default = [
    {
      name       = "sshkey-itinfra-dev-westeurope-001"
      public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAXE0oiFQ+Iu7aP43EE32H1wp2SpqpqOw99OPw78wRxw"
    },
    {
      name       = "sshkey-itinfra-dev-westeurope-002"
      public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGYnEL0h6e2CUB8ryyGKvgU2V1ZJsPoA7FJEe56hkQGp"
    },
  ]
}