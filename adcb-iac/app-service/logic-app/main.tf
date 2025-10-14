module "res-id" {
  source = "../../utility/random-identifier"
}

module "service-plan" {
  count                    = var.existing_service_plan == null ? 1 : 0
  source                   = "../app-service-plan"
  resource_location        = local.location
  resource_group_name      = var.resource_group_name
  application_name         = var.application_name
  environment              = var.environment
  service_plan_sku         = var.service_plan_sku
  os_type                  = "Linux"
  tags                     = merge(local.tags, local.common_tags)
}

module "storage_account" {
  source = "../../storage"
  resource_group                = local.rg
  environment                   = var.environment
  location                      = local.location
  application_name              = var.application_name
  storage_account_name          = format("logic-sa-%s-%s-%s-%s", var.application_name, var.environment, local.location_shortcode, module.res-id.result)
  account_kind                  = "StorageV2"
  skuname                       = var.sku_name
  public_network_access_enabled = false  # Secure access through private endpoint and managed identity
 tags                           = local.tags
  file_shares                   = var.file_shares
  customer_managed_key          = var.customer_managed_key_enabled
  kv_name                       = var.kv_name
  kv_resource_group_name        = var.kv_resource_group_name
  managed_identity_type         = "SystemAssigned, UserAssigned"
  azurerm_key_vault_key         = var.cmk_name
  storage_use                   = var.storage_use

}

resource "azurerm_private_endpoint" "pep" {
  count               = var.privatelink_subnet != null ? 1 : 0
  name                = format("pe-logic-sa-%s-%s-%s", var.application_name, var.environment, local.location_shortcode)
  location            = local.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.privatelink_subnet[0].id

  private_service_connection {
    name                           = format("%s%s", module.storage_account.storage_account_name, "-privatelink")
    is_manual_connection           = false
    private_connection_resource_id = module.storage_account.storage_account_id
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "privatelink-blob-core-windows-net"
    private_dns_zone_ids = [var.private_dns_zone_id]
  }

 tags                         = local.tags
}

resource "azurerm_private_endpoint" "pep-fileshare" {
  count               = (var.privatelink_subnet != null && var.create_fileshare == true) ? 1 : 0
  name                = format("pe-sa-fileshare-%s-%s-%s", var.application_name, var.environment, local.location_shortcode)
  location            = local.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.privatelink_subnet[0].id

  private_service_connection {
    name                           = format("%s%s", module.storage_account.storage_account_name, "-privatelink")
    is_manual_connection           = false
    private_connection_resource_id = module.storage_account.storage_account_id
    subresource_names              = ["file"]
  }

  private_dns_zone_group {
    name                 = "privatelink-file-core-windows-net"
    private_dns_zone_ids = [var.file_share_private_dns_zone_id]
  }

  tags                         = local.tags
}

resource "azurerm_logic_app_standard" "this" {
  for_each                   = var.logic_apps
  location                   = local.location
  name                       = "${var.application_name}-${var.environment}-${each.value.name}"
  resource_group_name        = var.resource_group_name
  app_service_plan_id        = module.service-plan[0].id
  storage_account_name       = module.storage_account.storage_account_name
  storage_account_access_key = module.storage_account.storage_primary_access_key
  version                    = "~4"

  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.uai[0].id]
  }

  tags = merge(
    local.tags,
    local.common_tags,
    {
    resource_type = "Logic-app"
    }
  )
}

# RBAC: Grant Logic Apps managed identity access to storage account
resource "azurerm_role_assignment" "logic_app_storage_blob_data_contributor" {
  count                = length(var.logic_apps) > 0 ? 1 : 0
  scope                = module.storage_account.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.uai[0].principal_id
}

resource "azurerm_role_assignment" "logic_app_storage_file_data_smb_share_contributor" {
  count                = length(var.logic_apps) > 0 ? 1 : 0
  scope                = module.storage_account.storage_account_id
  role_definition_name = "Storage File Data SMB Share Contributor"
  principal_id         = azurerm_user_assigned_identity.uai[0].principal_id
}

resource "azurerm_role_assignment" "logic_app_storage_queue_data_contributor" {
  count                = length(var.logic_apps) > 0 ? 1 : 0
  scope                = module.storage_account.storage_account_id
  role_definition_name = "Storage Queue Data Contributor"
  principal_id         = azurerm_user_assigned_identity.uai[0].principal_id
}

# RBAC: Grant Logic Apps system-assigned identity access to storage account
resource "azurerm_role_assignment" "logic_app_system_storage_blob_data_contributor" {
  for_each             = var.logic_apps
  scope                = module.storage_account.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_logic_app_standard.this[each.key].identity[0].principal_id
}

resource "azurerm_role_assignment" "logic_app_system_storage_file_data_smb_share_contributor" {
  for_each             = var.logic_apps
  scope                = module.storage_account.storage_account_id
  role_definition_name = "Storage File Data SMB Share Contributor"
  principal_id         = azurerm_logic_app_standard.this[each.key].identity[0].principal_id
}