output "managed_identity_ids" {
  description = "Map of Managed Identity keys to their IDs"
  value = {
    for key, identity in azurerm_user_assigned_identity.identities : key => identity.id
  }
}

output "managed_identity_principal_ids" {
  description = "Map of Managed Identity keys to their Principal IDs"
  value = {
    for key, identity in azurerm_user_assigned_identity.identities : key => identity.principal_id
  }
}

output "managed_identity_client_ids" {
  description = "Map of Managed Identity keys to their Client IDs"
  value = {
    for key, identity in azurerm_user_assigned_identity.identities : key => identity.client_id
  }
}

output "app_registration_ids" {
  description = "Map of App Registration keys to their IDs"
  value = {
    for key, app in azuread_application.app_registrations : key => app.id
  }
}

output "app_registration_client_ids" {
  description = "Map of App Registration keys to their Client IDs"
  value = {
    for key, app in azuread_application.app_registrations : key => app.client_id
  }
}

output "service_principal_ids" {
  description = "Map of Service Principal keys to their IDs"
  value = {
    for key, sp in azuread_service_principal.service_principals : key => sp.id
  }
}

output "service_principal_object_ids" {
  description = "Map of Service Principal keys to their Object IDs"
  value = {
    for key, sp in azuread_service_principal.service_principals : key => sp.object_id
  }
}
