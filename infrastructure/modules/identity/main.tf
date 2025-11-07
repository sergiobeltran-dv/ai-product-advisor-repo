# User Assigned Managed Identities
resource "azurerm_user_assigned_identity" "identities" {
  for_each = var.managed_identities

  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# App Registrations (Azure AD Applications)
resource "azuread_application" "app_registrations" {
  for_each = var.app_registrations

  display_name = each.value.display_name
  owners       = lookup(each.value, "owners", [])

  dynamic "web" {
    for_each = lookup(each.value, "web", null) != null ? [each.value.web] : []
    content {
      redirect_uris = lookup(web.value, "redirect_uris", [])
      
      implicit_grant {
        access_token_issuance_enabled = lookup(web.value, "access_token_issuance_enabled", false)
        id_token_issuance_enabled     = lookup(web.value, "id_token_issuance_enabled", false)
      }
    }
  }

  dynamic "api" {
    for_each = lookup(each.value, "api", null) != null ? [each.value.api] : []
    content {
      mapped_claims_enabled          = lookup(api.value, "mapped_claims_enabled", false)
      requested_access_token_version = lookup(api.value, "requested_access_token_version", 2)
    }
  }

  dynamic "required_resource_access" {
    for_each = lookup(each.value, "required_resource_access", [])
    content {
      resource_app_id = required_resource_access.value.resource_app_id

      dynamic "resource_access" {
        for_each = required_resource_access.value.resource_access
        content {
          id   = resource_access.value.id
          type = resource_access.value.type
        }
      }
    }
  }
}

# Service Principals for App Registrations
resource "azuread_service_principal" "service_principals" {
  for_each = var.app_registrations

  client_id                    = azuread_application.app_registrations[each.key].client_id
  app_role_assignment_required = lookup(each.value, "app_role_assignment_required", false)
  owners                       = lookup(each.value, "owners", [])

  tags = [for k, v in var.tags : "${k}:${v}"]
}

# Role Assignments for Managed Identities
resource "azurerm_role_assignment" "managed_identity_roles" {
  for_each = { for ra in local.role_assignments : ra.key => ra }

  scope                = each.value.scope
  role_definition_name = each.value.role_definition_name
  principal_id         = azurerm_user_assigned_identity.identities[each.value.identity_key].principal_id
}

# Local variables for flattening role assignments
locals {
  role_assignments = flatten([
    for identity_key, identity in var.managed_identities : [
      for role_idx, role in lookup(identity, "role_assignments", []) : {
        key                  = "${identity_key}-${role.role_definition_name}-${role_idx}"
        identity_key         = identity_key
        scope                = role.scope
        role_definition_name = role.role_definition_name
      }
    ]
  ])
}
