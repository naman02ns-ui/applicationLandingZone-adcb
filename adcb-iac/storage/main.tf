module "res-id" {
  source = "../utility/random-identifier"
}

resource "azurerm_storage_account" "storeacc" {
  name                          = substr(format("%s%s", lower(replace(var.storage_account_name, "/[[:^alnum:]]/", "")), module.res-id.result), 0, 24)
  resource_group_name           = var.resource_group
  location                      = local.location
  account_kind                  = var.account_kind
  account_tier                  = local.account_tier
  public_network_access_enabled = var.public_network_access_enabled
  account_replication_type      = local.account_replication_type
  cross_tenant_replication_enabled = var.cross_tenant_replication_enabled
  https_traffic_only_enabled    = true
  min_tls_version               = var.min_tls_version
  tags                          = merge(local.common_tags, local.tags)
  dynamic "identity" {
    for_each = var.managed_identity_type != null ? [1] : []
    content {
      type         = var.managed_identity_type
      identity_ids = var.managed_identity_type == "UserAssigned" || var.managed_identity_type == "SystemAssigned, UserAssigned" ? [azurerm_user_assigned_identity.sa_managed_identity.id] : null
    }
  }

  blob_properties {
    delete_retention_policy {
      days = var.blob_soft_delete_retention_days
    }
    container_delete_retention_policy {
      days = var.container_soft_delete_retention_days
    }
    versioning_enabled       = var.enable_versioning
    last_access_time_enabled = var.last_access_time_enabled
    change_feed_enabled      = var.change_feed_enabled
  }

  dynamic "network_rules" {
    for_each = var.network_rules != null ? ["true"] : []
    content {
      default_action             = "Deny"
      bypass                     = var.network_rules.bypass
      ip_rules                   = var.network_rules.ip_rules
      virtual_network_subnet_ids = var.network_rules.subnet_ids
    }
  }
  infrastructure_encryption_enabled = var.infrastructure_encryption_enabled
  allow_nested_items_to_be_public   = var.allow_nested_items_to_be_public

  dynamic "customer_managed_key" {
    for_each = var.customer_managed_key == true ? [{}] : []

    content {
      key_vault_key_id          = azurerm_key_vault_key.vault_key[0].id
      user_assigned_identity_id = azurerm_user_assigned_identity.sa_managed_identity.id
    }
  }

  depends_on = [azurerm_user_assigned_identity.sa_managed_identity]
}

resource "azurerm_user_assigned_identity" "sa_managed_identity" {
  resource_group_name = var.resource_group
  location            = local.location
  name                = "${var.application_name}-${var.environment}-${var.storage_use}-sa-uai"
  tags                = var.tags
  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      name
   ]
  }
}

resource "azurerm_role_assignment" "crypto_encryption_role_assignment" {
  count = var.customer_managed_key == true ? 1 : 0
  scope                = data.azurerm_key_vault.keyvault[0].id
  role_definition_name = "Key Vault Crypto Officer"
  principal_id         = azurerm_user_assigned_identity.sa_managed_identity.principal_id
  lifecycle {
    ignore_changes = [
      principal_id,
      scope,
      role_definition_name
    ]
  }
}

# resource "azurerm_role_assignment" "crypto_encryption_role_assignment" {
#   count = var.customer_managed_key == true ? 1 : 0

#   scope                = data.azurerm_key_vault.keyvault[0].id
#   role_definition_name = "Key Vault Crypto Service Encryption User"
#   principal_id         = azurerm_user_assigned_identity.sa_managed_identity.principal_id
# }

resource "azurerm_key_vault_key" "vault_key" {
  count        = var.customer_managed_key == true ? 1 : 0
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
  lifecycle {
    ignore_changes  = [
      name,
      expiration_date
    ]
  }
}

#--------------------------------------
# Storage Advanced Threat Protection
#--------------------------------------
resource "azurerm_advanced_threat_protection" "atp" {
  target_resource_id = azurerm_storage_account.storeacc.id
  enabled            = var.enable_advanced_threat_protection
}

#-------------------------------
# Storage Container Creation
#-------------------------------

resource "azurerm_storage_container" "container" {
  count                 = length(var.containers_list)
  name                  = var.containers_list[count.index].name
  #storage_account_name    = azurerm_storage_account.storeacc.name
  storage_account_id    = azurerm_storage_account.storeacc.id  #storage_account_name replaced with storage_account_id
  container_access_type = var.containers_list[count.index].access_type
}

#-------------------------------
# Storage Fileshare Creation
#-------------------------------
resource "azurerm_storage_share" "fileshare" {
  count              = length(var.file_shares) > 0 ? length(var.file_shares) : 0
  name               = var.file_shares[count.index].name
  storage_account_id = azurerm_storage_account.storeacc.id
  quota              = var.file_shares[count.index].quota
}

#-------------------------------
# Storage Tables Creation
#-------------------------------
resource "azurerm_storage_table" "tables" {
  count                = length(var.tables)
  name                 = var.tables[count.index]
  storage_account_name    = azurerm_storage_account.storeacc.name
}

#-------------------------------
# Storage Queue Creation
#-------------------------------
resource "azurerm_storage_queue" "queues" {
  count                = length(var.queues)
  name                 = var.queues[count.index]
  storage_account_name    = azurerm_storage_account.storeacc.name
}

#-------------------------------
# Storage Lifecycle Management
#-------------------------------
resource "azurerm_storage_management_policy" "lcpolicy" {
  count              = length(var.lifecycles) == 0 ? 0 : 1
  storage_account_id = azurerm_storage_account.storeacc.id

  dynamic "rule" {
    for_each = var.lifecycles
    iterator = rule
    content {
      name    = "rule${rule.key}"
      enabled = true
      filters {
        prefix_match = rule.value.prefix_match
        blob_types   = ["blockBlob"]
      }
      actions {
        base_blob {
          tier_to_cool_after_days_since_modification_greater_than    = rule.value.tier_to_cool_after_days
          tier_to_archive_after_days_since_modification_greater_than = rule.value.tier_to_archive_after_days
          delete_after_days_since_modification_greater_than          = rule.value.delete_after_days
        }
        snapshot {
          delete_after_days_since_creation_greater_than = rule.value.snapshot_delete_after_days
        }
      }
    }
  }
}