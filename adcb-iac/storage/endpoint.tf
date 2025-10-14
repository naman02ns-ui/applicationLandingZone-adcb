resource "azurerm_private_endpoint" "file_sa" {
  count               = length(var.file_shares) > 0 && var.privatelink_subnet != null ? 1 : 0
  name                = format("pep-sa-file-%s-%s-%s", var.application_name, local.environment, local.location_shortcode)
  location            = var.location
  resource_group_name = var.resource_group
  subnet_id           = data.azurerm_subnet.privatelink_subnet[0].id

  private_service_connection {
    name                           = format("%s%s", azurerm_storage_account.storeacc.name, "-sa-file-privatelink")
    private_connection_resource_id = azurerm_storage_account.storeacc.id
    is_manual_connection           = false
    subresource_names              = ["File"]
  }
}

resource "azurerm_private_endpoint" "blob_sa" {
  count               = length(var.containers_list) > 0 || var.privatelink_subnet != null ? 1 : 0
  name                = format("pep-sa-file-%s-%s-%s", var.application_name, local.environment, local.location_shortcode)
  location            = var.location
  resource_group_name = var.resource_group
  subnet_id           = data.azurerm_subnet.privatelink_subnet[0].id
  tags                = local.tags

  private_service_connection {
    name                           = "${var.environment}-${var.application_name}-psc"
    private_connection_resource_id = azurerm_storage_account.storeacc.id
    is_manual_connection           = false
    subresource_names              = ["Blob"]
  }

  private_dns_zone_group {
    name                 = "dns-blob-01"
    private_dns_zone_ids = [var.private_dns_zone_ids]
  }
}

resource "azurerm_private_endpoint" "table_sa" {
  count               = length(var.tables) > 0 && var.privatelink_subnet != null ? 1 : 0
  name                = format("pep-sa-file-%s-%s-%s", var.application_name, local.environment, local.location_shortcode)
  location            = var.location
  resource_group_name = var.resource_group
  subnet_id           = data.azurerm_subnet.privatelink_subnet[0].id
  tags                = local.tags

  private_service_connection {
    name                           = format("%s%s", azurerm_storage_account.storeacc.name, "-sa-table-privatelink")
    private_connection_resource_id = azurerm_storage_account.storeacc.id
    is_manual_connection           = false
    subresource_names              = ["Table"]
  }
}

resource "azurerm_private_endpoint" "queue_sa" {
  count               = length(var.queues) > 0 && var.privatelink_subnet != null ? 1 : 0
  name                = format("pep-sa-file-%s-%s-%s", var.application_name, local.environment, local.location_shortcode)
  location            = var.location
  resource_group_name = var.resource_group
  subnet_id           = data.azurerm_subnet.privatelink_subnet[0].id
  tags                = local.tags

  private_service_connection {
    name                           = format("%s%s", azurerm_storage_account.storeacc.name, "-sa-queue-privatelink")
    private_connection_resource_id = azurerm_storage_account.storeacc.id
    is_manual_connection           = false
    subresource_names              = ["Queue"]

  }
}