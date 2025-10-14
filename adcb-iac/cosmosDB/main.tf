# Random identifier module for unique naming
module "res-id" {
  source = "../utility/random-identifier"
}

# Cosmos DB Account
resource "azurerm_cosmosdb_account" "this" {
  name                              = "${var.cosmosdb_account_name}-${local.location_shortcode}-${module.res-id.result}"
  resource_group_name               = var.resource_group_name
  location                          = local.location
  offer_type                        = var.offer_type
  kind                              = var.kind
  automatic_failover_enabled        = var.enable_automatic_failover
  multiple_write_locations_enabled  = var.enable_multiple_write_locations
  is_virtual_network_filter_enabled = var.enable_virtual_network_filter
  public_network_access_enabled     = var.public_network_access_enabled

  consistency_policy {
    consistency_level       = var.consistency_policy.consistency_level
    max_interval_in_seconds = var.consistency_policy.max_interval_in_seconds
    max_staleness_prefix    = var.consistency_policy.max_staleness_prefix
  }

  dynamic "geo_location" {
    for_each = length(var.geo_location) > 0 ? var.geo_location : [
      {
        location          = var.location
        failover_priority = 0
        zone_redundant    = false
      }
    ]
    content {
      location          = geo_location.value.location
      failover_priority = geo_location.value.failover_priority
      zone_redundant    = lookup(geo_location.value, "zone_redundant", false)
    }
  }

  dynamic "capabilities" {
    for_each = var.capabilities
    content {
      name = capabilities.value
    }
  }

  dynamic "virtual_network_rule" {
    for_each = var.virtual_network_rules != null ? var.virtual_network_rules : []
    content {
      id                                   = virtual_network_rule.value.subnet_id
      ignore_missing_vnet_service_endpoint = lookup(virtual_network_rule.value, "ignore_missing_vnet_service_endpoint", false)
    }
  }

  dynamic "backup" {
    for_each = var.backup != null ? [var.backup] : []
    content {
      type                = backup.value.type
      tier                = lookup(backup.value, "tier", null)
      interval_in_minutes = lookup(backup.value, "interval_in_minutes", null)
      retention_in_hours  = lookup(backup.value, "retention_in_hours", null)
      storage_redundancy  = lookup(backup.value, "storage_redundancy", null)
    }
  }

  dynamic "cors_rule" {
    for_each = var.cors_rule != null ? [var.cors_rule] : []
    content {
      allowed_headers    = cors_rule.value.allowed_headers
      allowed_methods    = cors_rule.value.allowed_methods
      allowed_origins    = cors_rule.value.allowed_origins
      exposed_headers    = cors_rule.value.exposed_headers
      max_age_in_seconds = cors_rule.value.max_age_in_seconds
    }
  }

  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []
    content {
      type         = identity.value.type
      identity_ids = lookup(identity.value, "identity_ids", null)
    }
  }

  dynamic "analytical_storage" {
    for_each = var.analytical_storage_enabled ? [1] : []
    content {
      schema_type = var.analytical_storage_schema_type
    }
  }

  tags = merge(local.common_tags, var.tags)

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

# Private Endpoint for Cosmos DB
resource "azurerm_private_endpoint" "cosmosdb_pe" {
  count               = var.enable_private_endpoint && var.privatelink_subnet != null ? 1 : 0
  name                = "pe-cosmosdb-${var.application_name}-${var.environment}-${local.location_shortcode}"
  location            = local.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.privatelink_subnet[0].id

  private_service_connection {
    name                           = "psc-cosmosdb-${var.application_name}-${var.environment}-${local.location_shortcode}"
    private_connection_resource_id = azurerm_cosmosdb_account.this.id
    is_manual_connection           = false
    subresource_names              = ["Sql"]
  }

  dynamic "private_dns_zone_group" {
    for_each = length(var.private_dns_zone_ids) > 0 ? [1] : []
    content {
      name                 = "pdz-cosmosdb-${var.application_name}-${var.environment}-${local.location_shortcode}"
      private_dns_zone_ids = var.private_dns_zone_ids
    }
  }

  tags = merge(local.common_tags, var.tags)
}

# Cosmos DB SQL Database
resource "azurerm_cosmosdb_sql_database" "database" {
  count               = length(var.sql_databases)
  name                = var.sql_databases[count.index].name
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.this.name

  dynamic "autoscale_settings" {
    for_each = lookup(var.sql_databases[count.index], "autoscale_settings", null) != null ? [var.sql_databases[count.index].autoscale_settings] : []
    content {
      max_throughput = autoscale_settings.value.max_throughput
    }
  }

  throughput = lookup(var.sql_databases[count.index], "throughput", null)
}

# Cosmos DB SQL Containers
resource "azurerm_cosmosdb_sql_container" "container" {
  count               = length(var.sql_containers)
  name                = var.sql_containers[count.index].name
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.this.name
  database_name       = var.sql_containers[count.index].database_name

  partition_key_paths = [var.sql_containers[count.index].partition_key_path]

  dynamic "autoscale_settings" {
    for_each = lookup(var.sql_containers[count.index], "autoscale_settings", null) != null ? [var.sql_containers[count.index].autoscale_settings] : []
    content {
      max_throughput = autoscale_settings.value.max_throughput
    }
  }

  throughput = lookup(var.sql_containers[count.index], "throughput", null)

  dynamic "unique_key" {
    for_each = lookup(var.sql_containers[count.index], "unique_keys", null) != null ? var.sql_containers[count.index].unique_keys : []
    content {
      paths = unique_key.value.paths
    }
  }

  dynamic "indexing_policy" {
    for_each = lookup(var.sql_containers[count.index], "indexing_policy", null) != null ? [var.sql_containers[count.index].indexing_policy] : []
    content {
      indexing_mode = indexing_policy.value.indexing_mode

      dynamic "included_path" {
        for_each = lookup(indexing_policy.value, "included_paths", [])
        content {
          path = included_path.value
        }
      }

      dynamic "excluded_path" {
        for_each = lookup(indexing_policy.value, "excluded_paths", [])
        content {
          path = excluded_path.value
        }
      }

      dynamic "composite_index" {
        for_each = lookup(indexing_policy.value, "composite_indexes", [])
        content {
          dynamic "index" {
            for_each = composite_index.value.indexes
            content {
              path  = index.value.path
              order = index.value.order
            }
          }
        }
      }

      dynamic "spatial_index" {
        for_each = lookup(indexing_policy.value, "spatial_indexes", [])
        content {
          path = spatial_index.value.path
          types = spatial_index.value.types
        }
      }
    }
  }

  depends_on = [azurerm_cosmosdb_sql_database.database]
}
