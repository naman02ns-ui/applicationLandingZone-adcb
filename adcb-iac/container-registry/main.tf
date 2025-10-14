module "res-id" {
  source = "../utility/random-identifier"
}

resource "azurerm_container_registry" "acr" {
  name                          = local.acr_name
  resource_group_name           = var.resource_group_name
  location                      = local.location
  sku                           = var.sku
  admin_enabled                 = var.admin_enabled
  public_network_access_enabled = var.public_network_access_enabled
  network_rule_bypass_option    = var.azure_services_bypass_allowed ? "AzureServices" : "None"
  data_endpoint_enabled         = var.data_endpoint_enabled
  zone_redundancy_enabled       = var.zone_redundancy_enabled

  dynamic "identity" {
    for_each = var.encryption_enabled ? [{}] : []

    content {
      type = "UserAssigned"
      identity_ids = [
        azurerm_user_assigned_identity.acr_managed_identity[0].id
      ]
    }
  }

  retention_policy_in_days = var.images_retention_enabled && var.sku == "Premium" ? var.retention_policy_in_days : 0
  # dynamic "retention_policy" {
  #   for_each = var.images_retention_enabled && var.sku == "Premium" ? ["enabled"] : []

  #   content {
  #     enabled = var.images_retention_enabled
  #     days    = var.images_retention_days
  #   }
  # }

  # dynamic "trust_policy" {
  #   for_each = var.trust_policy_enabled && var.sku == "Premium" ? ["enabled"] : []

  #   content {
  #     enabled = var.trust_policy_enabled
  #   }
  # }

  trust_policy_enabled = var.trust_policy_enabled && var.sku == "Premium"
  dynamic "georeplications" {
    for_each = var.georeplication_locations != null && var.sku == "Premium" ? var.georeplication_locations : []

    content {
      location                  = try(georeplications.value.location, georeplications.value)
      zone_redundancy_enabled   = try(georeplications.value.zone_redundancy_enabled, null)
      regional_endpoint_enabled = try(georeplications.value.regional_endpoint_enabled, null)
      tags                      = try(georeplications.value.tags, null)
    }
  }

  dynamic "encryption" {
    for_each = var.encryption_enabled && var.sku == "Premium" ? ["enabled"] : []

    content {
      key_vault_key_id   = azurerm_key_vault_key.vault_key[0].id
      identity_client_id = azurerm_user_assigned_identity.acr_managed_identity[0].client_id
    }
  }

  dynamic "network_rule_set" {
    for_each = length(concat(var.allowed_cidrs, var.allowed_subnets)) > 0 ? ["enabled"] : []

    content {
      default_action = "Deny"

      dynamic "ip_rule" {
        for_each = var.allowed_cidrs
        content {
          action   = "Allow"
          ip_range = ip_rule.value
        }
      }

      # dynamic "virtual_network" {
      #   for_each = var.allowed_subnets
      #   content {
      #     action    = "Allow"
      #     subnet_id = virtual_network.value
      #   }
      # }
    }
  }

  tags                         = local.tags

  lifecycle {
    precondition {
      condition     = !var.data_endpoint_enabled || var.sku == "Premium"
      error_message = "Premium SKU is mandatory to enable the data endpoints."
    }
  }
}

resource "azurerm_user_assigned_identity" "acr_managed_identity" {
  count = var.encryption_enabled ? 1 : 0

  resource_group_name = var.resource_group_name
  location            = local.location
  name                = "${local.acr_name}-id"
  tags                = local.tags
}

resource "azurerm_role_assignment" "crypto_encryption_role_assignment" {
  count = var.encryption_enabled ? 1 : 0

  scope                = data.azurerm_key_vault.keyvault[0].id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_user_assigned_identity.acr_managed_identity[0].principal_id
}

resource "azurerm_private_endpoint" "pep" {
  count               = var.privatelink_subnet != null ? 1 : 0
  name                = format("pep-acr-%s-%s-%s", var.application_name, var.environment, local.location_shortcode)
  location            = local.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.privatelink_subnet[0].id
  private_service_connection {
    name                           = format("%s%s", azurerm_container_registry.acr.name, "-privatelink")
    is_manual_connection           = false
    private_connection_resource_id = azurerm_container_registry.acr.id
    subresource_names              = ["registry"]
  }

  private_dns_zone_group {
    name                 = "privatelink-azurecr-io"
    private_dns_zone_ids = [var.private_dns_zone_id]
  }

  tags                         = local.tags
}

resource "azurerm_role_assignment" "this" {
  for_each                               = var.role_assignments
  principal_id                           = each.value.principal_id
  scope                                  = azurerm_container_registry.acr.id
  condition                              = each.value.condition
  condition_version                      = each.value.condition_version
  delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
  role_definition_id                     = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? each.value.role_definition_id_or_name : null
  role_definition_name                   = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? null : each.value.role_definition_id_or_name
  skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check
}

resource "azurerm_key_vault_key" "vault_key" {
  count = var.encryption_enabled ? 1 : 0

  name         = var.azurerm_key_vault_key
  key_vault_id = data.azurerm_key_vault.keyvault[0].id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
  expiration_date = var.key_expiration_date  # e.g., "2026-12-31T23:59:59Z"
  depends_on = [azurerm_role_assignment.crypto_encryption_role_assignment]
  lifecycle {
    ignore_changes = [
      expiration_date,
      name
    ]
  }

}