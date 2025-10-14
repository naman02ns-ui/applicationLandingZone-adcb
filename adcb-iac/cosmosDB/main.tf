locals {
  collections = flatten([
    for db_key, db_details in var.databases : [
      for col in db_details.collections : {
        name           = col.name
        database       = db_key
        shard_key      = col.shard_key
        throughput     = lookup(col, "throughput", null)
        max_throughput = lookup(col, "max_throughput", null)
      }
    ]
  ])
}

module "res-id" {
  source = "../utility/random-identifier"
}

resource "azurerm_cosmosdb_account" "cosmosdb_account" {
  name                       = format("cosmos-%s-%s-%s-%s", var.application_name, var.environment, local.location_shortcode, module.res-id.result)
  location                   = local.location
  resource_group_name        = var.resource_group_name
  offer_type                 = var.offer_type
  kind                       = var.kind
  mongo_server_version       = var.kind == "MongoDB" ? var.mongo_server_version : null
  free_tier_enabled          = var.free_tier_enabled
  automatic_failover_enabled = true
  analytical_storage_enabled = var.analytical_storage_enabled

  dynamic "analytical_storage" {
    for_each = var.analytical_storage_type != null ? ["enabled"] : []
    content {
      schema_type = var.analytical_storage_type
    }
  }

  consistency_policy {
    consistency_level       = var.consistency_policy.consistency_level
    max_interval_in_seconds = var.consistency_policy.max_interval_in_seconds
    max_staleness_prefix    = var.consistency_policy.max_staleness_prefix
  }


  ip_range_filter = length(var.allowed_cidrs) > 0 ? var.allowed_cidrs : null


  public_network_access_enabled         = var.public_network_access_enabled
  is_virtual_network_filter_enabled     = var.is_virtual_network_filter_enabled
  network_acl_bypass_for_azure_services = var.network_acl_bypass_for_azure_services
  network_acl_bypass_ids                = var.network_acl_bypass_ids

  dynamic "virtual_network_rule" {
    for_each = var.virtual_network_rule != null ? toset(var.virtual_network_rule) : []
    content {
      id                                   = virtual_network_rule.value.id
      ignore_missing_vnet_service_endpoint = virtual_network_rule.value.ignore_missing_vnet_service_endpoint
    }
  }

  dynamic "geo_location" {
    for_each = var.failover_locations != null ? var.failover_locations : local.failover_locations
    content {
      location          = geo_location.value.location
      failover_priority = geo_location.value.failover_priority
      zone_redundant    = geo_location.value.zone_redundant
    }
  }

  dynamic "capabilities" {
    for_each = toset(var.capabilities)
    content {
      name = capabilities.key
    }
  }

  dynamic "backup" {
    for_each = var.backup != null ? ["enabled"] : []
    content {
      type                = lookup(var.backup, "type", null)
      interval_in_minutes = lookup(var.backup, "interval_in_minutes", null)
      retention_in_hours  = lookup(var.backup, "retention_in_hours", null)
      storage_redundancy  = lookup(var.backup, "storage_redundancy", null)
    }
  }

  dynamic "identity" {
    for_each = var.managed_identity ? [1] : [0]
    content {
      type         = "SystemAssigned, UserAssigned"
      identity_ids = [var.identity_ids]
    }
  }

  tags                         = local.tags
}

resource "azurerm_cosmosdb_mongo_database" "mongo_database" {
  for_each            = var.databases
  name                = each.key
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.cosmosdb_account.name
  throughput          = each.value.throughput
}

resource "azurerm_cosmosdb_mongo_collection" "mongo_collection" {
  for_each = {
    for col in local.collections : col.name => col
  }

  name                = each.value.name
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.cosmosdb_account.name
  database_name       = each.value.database
  shard_key           = each.value.shard_key
  throughput          = each.value.throughput
  index {
    keys   = ["_id"]
    unique = true
  }
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  for_each = var.diagnostic_settings

  name                           = each.value.name != null ? each.value.name : "diag-cosmon-${var.environment}"
  target_resource_id             = azurerm_cosmosdb_account.cosmosdb_account.id
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