output "id" {
  description = "The ID of the Key vault"
  value       = azurerm_key_vault.kv.id
}

output "vault_uri" {
  description = "The URI of the Key vault"
  value       = azurerm_key_vault.kv.vault_uri
}
