module "res-id" {
  source = "../utility/random-identifier"
}

resource "azurerm_key_vault" "this" {
  name                          = local.kv_name
  location                      = local.location
  resource_group_name           = var.resource_group_name
  enabled_for_deployment        = var.enabled_for_deployment
  enabled_for_disk_encryption   = var.enabled_for_disk_encryption
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days    = var.soft_delete_retention_days
  purge_protection_enabled      = var.purge_protection_enabled
  public_network_access_enabled = var.public_network_access_enabled
  enable_rbac_authorization     = var.rbac_authorization_enabled # var.enable_rbac_authorization #this option rename in new version. with rbac_authorization_enabled
  #rbac_authorization_enabled     = var.rbac_authorization_enabled
  sku_name = var.sku_name

  dynamic "network_acls" {
    for_each = var.network_acls != null ? { this = var.network_acls } : {}
    content {
      bypass                     = network_acls.value.bypass
      default_action             = network_acls.value.default_action
      ip_rules                   = network_acls.value.ip_rules
      virtual_network_subnet_ids = network_acls.value.virtual_network_subnet_ids
    }
  }

  tags = local.tags
}

resource "azurerm_management_lock" "this" {
  count = var.lock.kind != "None" ? 1 : 0

  lock_level = var.lock.kind
  name       = coalesce(var.lock.name, "lock-${local.kv_name}")
  scope      = azurerm_key_vault.this.id
}

resource "azurerm_role_assignment" "this" {
  for_each = var.role_assignments

  principal_id                           = each.value.principal_id
  scope                                  = azurerm_key_vault.this.id
  condition                              = each.value.condition
  condition_version                      = each.value.condition_version
  delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
  role_definition_id                     = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? each.value.role_definition_id_or_name : null
  role_definition_name                   = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? null : each.value.role_definition_id_or_name
  skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check
}

resource "azurerm_role_assignment" "kv_admin" {
  count                = var.rbac_authorization_enabled ? 1 : 0
  principal_id         = data.azurerm_client_config.current.object_id
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Administrator"

  lifecycle {
    ignore_changes = [
      principal_id,
      scope,
      role_definition_name
    ]
  }
}

resource "azurerm_role_assignment" "kv_secrets_user" {
  count                = var.rbac_authorization_enabled ? 1 : 0
  principal_id         = data.azurerm_client_config.current.object_id
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Secrets User"
  lifecycle {
    ignore_changes = [
      principal_id,
      scope,
      role_definition_name
    ]
  }
}

resource "azurerm_role_assignment" "kv_secrets_officer" {
  count                = var.rbac_authorization_enabled ? 1 : 0
  principal_id         = data.azurerm_client_config.current.object_id
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Secrets officer"
  lifecycle {
    ignore_changes = [
      principal_id,
      scope,
      role_definition_name
    ]
  }
}

resource "azurerm_role_assignment" "kv_crypto_officer" {
  count                = var.rbac_authorization_enabled ? 1 : 0
  principal_id         = data.azurerm_client_config.current.object_id
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Crypto Officer"
  lifecycle {
    ignore_changes = [
      principal_id,
      scope,
      role_definition_name
    ]
  }
}

resource "azurerm_role_assignment" "kv_enc_officer" {
  count                = var.rbac_authorization_enabled ? 1 : 0
  principal_id         = data.azurerm_client_config.current.object_id
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  lifecycle {
    ignore_changes = [
      principal_id,
      scope,
      role_definition_name
    ]
  }
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  for_each = var.diagnostic_settings

  name                           = each.value.name != null ? each.value.name : "diag-${local.kv_name}"
  target_resource_id             = azurerm_key_vault.this.id
  eventhub_authorization_rule_id = each.value.event_hub_authorization_rule_resource_id
  eventhub_name                  = each.value.event_hub_name
  log_analytics_destination_type = each.value.log_analytics_destination_type
  log_analytics_workspace_id     = each.value.workspace_resource_id
  partner_solution_id            = each.value.marketplace_partner_resource_id
  storage_account_id             = each.value.storage_account_resource_id

  dynamic "enabled_log" {
    for_each = each.value.log_categories
    content {
      category = enabled_log.value
    }
  }

  dynamic "enabled_log" {
    for_each = each.value.log_groups
    content {
      category_group = enabled_log.value
    }
  }

  dynamic "metric" {
    for_each = each.value.metric_categories
    content {
      category = metric.value
    }
  }
}

resource "azurerm_private_endpoint" "kv" {
  count               = var.privatelink_subnet != null ? 1 : 0
  name                = format("pep-kv-%s-%s-%s", var.application_name, local.environment, local.location_shortcode)
  location            = local.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.privatelink_subnet[0].id

  private_service_connection {
    name                           = format("%s%s", azurerm_key_vault.this.name, "-privatelink")
    private_connection_resource_id = azurerm_key_vault.this.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  private_dns_zone_group {
    name                 = "dns-kv-01"
    private_dns_zone_ids = [var.private_dns_zone_id]
  }

  tags = local.tags
}