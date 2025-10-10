# =============================================================================
# Terraform Variables for AI Services Application Landing Zone
# =============================================================================

# =============================================================================
# Platform Configuration
# =============================================================================

variable "subscription_id_resources" {
  description = "Subscription ID for deploying resources"
  type        = string
  default     = ""
}

variable "location" {
  description = "Azure region for resource deployment"
  type        = string
  default     = "uaenorth"
}

variable "environment" {
  description = "Environment name (dev, qa, sit, uat, preprod, prod)"
  type        = string
  default     = "dev"
}

variable "existing_vnet_name" {
  description = "Name of existing virtual network"
  type        = string
  default     = ""
}

variable "existing_vnet_resource_group" {
  description = "Resource group of existing virtual network"
  type        = string
  default     = ""
}

variable "subscription_id_infra" {
  description = "Subscription ID for infrastructure resources"
  type        = string
  default     = ""
}

variable "subnet_id_aifoundry" {
  description = "Subnet ID for AI Foundry resources"
  type        = string
  default     = ""
}

variable "existing_vnet_rg" {
  description = "Resource group of existing virtual network"
  type        = string
  default     = ""
}

variable "ainonprod_sub_id" {
  description = "Subscription ID for AI non-production resources"
  type        = string
  default     = ""
}

variable "application_name" {
  description = "Name of the application"
  type        = string
}

variable "resource_group_name_dns" {
  description = "Resource group name for DNS resources"
  type        = string
  default     = ""
}

variable "subnet_id" {
  description = "Subnet ID for private endpoints"
  type        = string
  default     = ""
}

# =============================================================================
# Module Enable/Disable Flags
# =============================================================================

variable "enable_key_vaults" {
  description = "Enable Key Vault module deployment (1 = deploy, 0 = skip)"
  type        = number
  default     = 1
}

variable "enable_function_apps" {
  description = "Enable Function Apps module deployment (1 = deploy, 0 = skip)"
  type        = number
  default     = 1
}

variable "enable_container_registries" {
  description = "Enable Container Registry module deployment (1 = deploy, 0 = skip)"
  type        = number
  default     = 1
}

variable "enable_container_app_environments" {
  description = "Enable Container App Environments module deployment (1 = deploy, 0 = skip)"
  type        = number
  default     = 1
}

variable "enable_container_apps" {
  description = "Enable Container Apps module deployment (1 = deploy, 0 = skip)"
  type        = number
  default     = 1
}

variable "enable_ai_search_services" {
  description = "Enable AI Search Services module deployment (1 = deploy, 0 = skip)"
  type        = number
  default     = 1
}

variable "enable_cosmos_db" {
  description = "Enable Cosmos DB module deployment (1 = deploy, 0 = skip)"
  type        = number
  default     = 1
}

variable "enable_logic_apps" {
  description = "Enable Logic Apps module deployment (1 = deploy, 0 = skip)"
  type        = number
  default     = 1
}

# =============================================================================
# Existing Resource Flags and Configurations
# =============================================================================

variable "enable_existing_key_vaults" {
  description = "Enable using existing Key Vaults (1 = enabled, 0 = disabled)"
  type        = number
  default     = 0
}

variable "existing_key_vaults" {
  description = "Map of existing Key Vault configurations"
  type = map(object({
    name                = string
    resource_group_name = string
  }))
  default = {}
}

variable "enable_existing_storage_accounts" {
  description = "Enable using existing Storage Accounts (1 = enabled, 0 = disabled)"
  type        = number
  default     = 0
}

variable "existing_storage_accounts" {
  description = "Map of existing Storage Account configurations"
  type = map(object({
    name                = string
    resource_group_name = string
  }))
  default = {}
}

variable "enable_existing_ai_search_services" {
  description = "Enable using existing AI Search Services (1 = enabled, 0 = disabled)"
  type        = number
  default     = 0
}

variable "existing_ai_search_services" {
  description = "Map of existing AI Search Service configurations"
  type = map(object({
    name                = string
    resource_group_name = string
  }))
  default = {}
}

variable "enable_existing_log_analytics_workspaces" {
  description = "Enable using existing Log Analytics Workspaces (1 = enabled, 0 = disabled)"
  type        = number
  default     = 0
}

variable "existing_log_analytics_workspaces" {
  description = "Map of existing Log Analytics Workspace configurations"
  type = map(object({
    name                = string
    resource_group_name = string
  }))
  default = {}
}

variable "enable_existing_cosmos_db" {
  description = "Enable using existing Cosmos DB Accounts (1 = enabled, 0 = disabled)"
  type        = number
  default     = 0
}

variable "existing_cosmos_db_accounts" {
  description = "Map of existing Cosmos DB Account configurations"
  type = map(object({
    name                = string
    resource_group_name = string
  }))
  default = {}
}

# =============================================================================
# Resource Configuration Maps
# =============================================================================

variable "function_apps" {
  description = "Map of Function App configurations"
  type = map(object({
    resource_location                = optional(string, "uaenorth")
    resource_group_name             = string
    application_name                = string
    environment                     = string
    service_plan_sku                = optional(string, "Y1")
    max_elastic_worker_count        = optional(number, null)
    existing_service_plan = optional(object({
      name                = string
      resource_group_name = string
    }), null)
    function_apps = map(object({
      name            = string
      env_vars        = optional(map(string), {})
      file_share_name = optional(string, null)
    }))
    app_function_subnet = optional(object({
      name           = string
      vnet_name      = string
      resource_group = string
    }), null)
    privatelink_subnet = optional(object({
      name           = string
      vnet_name      = string
      resource_group = string
    }), null)
    privatelink_funcapp_subnet = optional(object({
      name           = string
      vnet_name      = string
      resource_group = string
    }), null)
    private_dns_zone_id                    = optional(string, "")
    func_app_private_dns_zone_id          = optional(string, "")
    file_share_private_dns_zone_id        = optional(string, null)
    public_network_access_enabled         = optional(bool, false)
    vnet_route_all_enabled                = optional(bool, true)
    application_insights_enabled          = optional(bool, true)
    application_insights_connection_string = optional(string, null)
    application_insights_key              = optional(string, null)
    log_analytics_worksapce_id            = optional(string, null)
    daily_memory_time_quota               = optional(number, null)
    customer_managed_key_enabled         = optional(bool, false)
    kv_name                              = optional(string, null)
    kv_resource_group_name               = optional(string, null)
    cmk_name                             = optional(string, null)
    storage_use                          = optional(bool, false)
    uai_required                         = optional(bool, false)
    user_assigned_identity_ids           = optional(list(string), [])
    storage_account_name                 = optional(string, null)
    sku_name                            = optional(string, "Standard_LRS")
    file_shares                         = optional(list(object({ name = string, quota = number })), [])
    create_fileshare                    = optional(bool, false)
    tags                                = optional(map(string), {})
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.function_apps : contains(["dev", "qa", "sit", "uat", "preprod", "prod"], v.environment)
    ])
    error_message = "Allowed values for environment: dev, qa, uat, sit, preprod, prod."
  }

  validation {
    condition = alltrue([
      for k, v in var.function_apps : contains(["EP1", "EP2", "EP3", "Y1"], v.service_plan_sku)
    ])
    error_message = "Allowed values for service_plan_sku: EP1, EP2, EP3, Y1."
  }
}

variable "container_registries" {
  description = "Map of Container Registry configurations"
  type = map(object({
    resource_location              = optional(string, "uaenorth")
    resource_group_name           = string
    application_name              = string
    environment                   = string
    sku                          = optional(string, "Premium")
    admin_enabled                = optional(bool, false)
    public_network_access_enabled = optional(bool, false)
    quarantine_policy_enabled     = optional(bool, false)
    retention_policy_days         = optional(number, 30)
    trust_policy_enabled          = optional(bool, false)
    zone_redundancy_enabled       = optional(bool, false)
    key_expiration_date           = optional(string, null)
    azurerm_key_vault_key         = optional(string, null)
    kv_name                       = optional(string, null)
    georeplication_locations      = optional(list(string), [])
    images_retention_enabled      = optional(bool, false)
    images_retention_days         = optional(number, 30)
    retention_policy_in_days      = optional(number, 30)
    azure_services_bypass_allowed = optional(bool, true)
    allowed_cidrs                 = optional(list(string), [])
    allowed_subnets               = optional(list(string), [])
    data_endpoint_enabled         = optional(bool, false)
    encryption_enabled            = optional(bool, false)
    privatelink_subnet = optional(object({
      name           = string
      vnet_name      = string
      resource_group = string
    }), null)
    private_dns_zone_id = optional(string, "")
    tags               = optional(map(string), {})
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.container_registries : contains(["dev", "qa", "sit", "uat", "preprod", "prod"], v.environment)
    ])
    error_message = "Allowed values for environment: dev, qa, uat, sit, preprod, prod."
  }

  validation {
    condition = alltrue([
      for k, v in var.container_registries : contains(["Basic", "Standard", "Premium"], v.sku)
    ])
    error_message = "Allowed values for sku: Basic, Standard, Premium."
  }
}

variable "container_app_environments" {
  description = "Map of Container App Environment configurations"
  type = map(object({
    resource_location        = optional(string, "uaenorth")
    resource_group_name     = string
    application_name        = string
    environment             = string
    management_sub_id       = optional(string, null)
    workload_profile        = optional(object({
      name                    = string
      workload_profile_type   = string
    }), null)
    log_analytics_workspace_id = optional(string, null)
    internal_load_balancer_enabled = optional(bool, false)
    subnet = optional(object({
      name           = string
      vnet_name      = string
      resource_group = string
    }), null)
    tags                    = optional(map(string), {})
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.container_app_environments : contains(["dev", "qa", "sit", "uat", "preprod", "prod"], v.environment)
    ])
    error_message = "Allowed values for environment: dev, qa, uat, sit, preprod, prod."
  }
}

variable "container_apps" {
  description = "Map of Container App configurations"
  type = map(object({
    resource_location              = optional(string, "uaenorth")
    resource_group_name           = string
    application_name              = string
    environment                   = string
    container_app_environment_name = string
    revision_mode                 = optional(string, "Single")
    containers = list(object({
      name    = string
      image   = string
      cpu     = optional(string, "0.25")
      memory  = optional(string, "0.5Gi")
      command = optional(list(string), [])
      args    = optional(list(string), [])
      env     = optional(list(object({
        name  = string
        value = string
      })), [])
    }))
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string), [])
    }), null)
    ingress = optional(object({
      allow_insecure_connections = optional(bool, false)
      external_enabled          = optional(bool, true)
      target_port               = number
      traffic_weight = optional(list(object({
        percentage      = number
        revision_suffix = optional(string, null)
        label          = optional(string, null)
      })), [])
    }), null)
    tags                         = optional(map(string), {})
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.container_apps : contains(["dev", "qa", "sit", "uat", "preprod", "prod"], v.environment)
    ])
    error_message = "Allowed values for environment: dev, qa, uat, sit, preprod, prod."
  }
}

variable "logic_apps_services" {
  description = "Map of Logic Apps configurations"
  type = map(object({
    application_name     = string
    environment         = string
    resource_group_name = string
    resource_location   = optional(string, "uaenorth")
    service_plan_name   = optional(string, null)
    service_plan_sku    = optional(string, "WS1")
    existing_service_plan = optional(object({
      name                = string
      resource_group_name = string
    }), null)
    uai_required                     = optional(bool, false)
    user_assigned_identity_ids       = optional(list(string), [])
    storage_account_name            = optional(string, null)
    sku_name                       = optional(string, "Standard_LRS")
    file_shares                    = optional(list(object({ name = string, quota = number })), [])
    create_fileshare               = optional(bool, false)
    customer_managed_key_enabled  = optional(bool, false)
    kv_name                       = optional(string, "")
    kv_resource_group_name        = optional(string, "")
    cmk_name                      = optional(string, "")
    storage_use                   = optional(bool, false)
    privatelink_subnet = optional(object({
      name           = string
      vnet_name      = string
      resource_group = string
    }), null)
    private_dns_zone_ids          = optional(list(string), [])
    private_dns_zone_id           = optional(string, "")
    file_share_private_dns_zone_id = optional(string, "")
    logic_apps = optional(map(object({
      name = string
      env_vars = optional(map(string), {})
    })), {})
    workflow_apps = optional(map(object({
      name = string
    })), {})
    definistion_file_path        = optional(string, "")
    tags                         = optional(map(string), {})
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.logic_apps_services : contains(["dev", "qa", "sit", "uat", "preprod", "prod"], v.environment)
    ])
    error_message = "Allowed values for environment: dev, qa, uat, sit, preprod, prod."
  }

  validation {
    condition = alltrue([
      for k, v in var.logic_apps_services : contains(["WS1", "WS2", "WS3"], v.service_plan_sku)
    ])
    error_message = "Valid values for Logic App Standard SKU are: WS1, WS2, and WS3."
  }
}

# =============================================================================
# Module Variables for New Infrastructure Components
# =============================================================================

# Add missing enable variable for storage accounts
variable "enable_storage_accounts" {
  description = "Enable Storage Accounts module deployment (1 = deploy, 0 = skip)"
  type        = number
  default     = 1
}

variable "enable_log_analytics_workspaces" {
  description = "Enable Log Analytics Workspaces module deployment (1 = deploy, 0 = skip)"
  type        = number
  default     = 1
}

# =============================================================================
# Key Vault Module Variables
# =============================================================================

variable "key_vaults" {
  description = "Configuration for Key Vaults to be created"
  type = map(object({
    resource_group_name           = string
    application_name              = string
    environment                   = string
    resource_location             = string
    enabled_for_deployment        = optional(bool, false)
    enabled_for_disk_encryption   = optional(bool, false)
    purge_protection_enabled      = optional(bool, true)
    public_network_access_enabled = optional(bool, false)
    rbac_authorization_enabled    = optional(bool, true)
    sku_name                      = optional(string, "standard")
    soft_delete_retention_days    = optional(number, 7)
    network_acls = optional(object({
      bypass                     = optional(string, "AzureServices")
      default_action            = optional(string, "Allow")
      ip_rules                  = optional(list(string), [])
      virtual_network_subnet_ids = optional(list(string), [])
    }), {})
    role_assignments = optional(map(object({
      role_definition_id_or_name = string
      principal_id               = string
      description                = optional(string, "")
    })), {})
    lock = optional(object({
      kind = optional(string, "None")
    }), {})
    diagnostic_settings = optional(map(object({
      name                         = string
      log_groups                   = optional(list(string), ["allLogs"])
      metric_categories            = optional(list(string), ["AllMetrics"])
      log_analytics_destination_type = optional(string, "Dedicated")
      workspace_resource_id        = optional(string, "")
    })), {})
    privatelink_subnet = optional(object({
      name           = string
      vnet_name      = string
      resource_group = string
    }), null)
    private_dns_zone_name = optional(string, "")
    private_dns_zone_id   = optional(string, "")
    tags                  = optional(map(string), {})
  }))
  default = {}
}

# =============================================================================
# Storage Account Module Variables
# =============================================================================

variable "storage_accounts" {
  description = "Configuration for Storage Accounts to be created"
  type = map(object({
    resource_group_name                = string
    location                          = string
    application_name                  = string
    storage_account_name              = string
    account_kind                      = optional(string, "StorageV2")
    skuname                          = optional(string, "Standard_RAGRS")
    min_tls_version                  = optional(string, "TLS1_2")
    public_network_access_enabled    = optional(bool, true)
    allow_nested_items_to_be_public  = optional(bool, false)
    cross_tenant_replication_enabled = optional(bool, true)
    infrastructure_encryption_enabled = optional(bool, true)
    customer_managed_key             = optional(bool, true)
    azurerm_key_vault_key           = optional(string, null)
    kv_name                         = optional(string, null)
    kv_resource_group_name          = optional(string, null)
    key_expiration_date             = optional(string, "2027-12-31T23:59:59Z")
    managed_identity_type           = optional(string, null)
    managed_identity_ids            = optional(list(string), null)
    blob_soft_delete_retention_days = optional(number, 7)
    container_soft_delete_retention_days = optional(number, 7)
    enable_versioning               = optional(bool, true)
    last_access_time_enabled        = optional(bool, false)
    management_policy_rules = optional(list(object({
      prefix_match               = set(string)
      tier_to_cool_after_days    = number
      tier_to_archive_after_days = number
      delete_after_days          = number
      snapshot_delete_after_days = number
    })), [])
    privatelink_subnet = optional(object({
      name           = string
      vnet_name      = string
      resource_group = string
    }), null)
    private_dns_zone_ids = optional(list(string), null)
    tags                 = optional(map(string), {})
  }))
  default = {}
}

# =============================================================================
# AI Search Module Variables
# =============================================================================

variable "ai_search_services" {
  description = "Configuration for AI Search Services to be created"
  type = map(object({
    resource_group_name    = string
    location              = string
    application_name      = string
    environment           = string
    location_shortcode    = optional(string, "")
    sku                   = optional(string, "standard")
    partition_count       = optional(number, 1)
    replica_count         = optional(number, 1)
    hosting_mode          = optional(string, "default")
    public_network_access_enabled = optional(bool, false)
    allowed_ips           = optional(list(string), [])
    authentication_failure_mode = optional(string, "http401WithBearerChallenge")
    customer_managed_key_enforcement_enabled = optional(bool, false)
    enable_system_assigned_identity = optional(bool, true)
    private_endpoint_enabled = optional(bool, true)
    private_endpoint_subnet_name = optional(string, "")
    virtual_network_name = optional(string, "")
    network_resource_group_name = optional(string, "")
    private_dns_zone_id = optional(string, "")
    log_analytics_workspace_id = optional(string, "")
    diagnostic_logs_retention_days = optional(number, 30)
    diagnostic_metrics_retention_days = optional(number, 30)
    contributor_principal_ids = optional(list(string), [])
    index_data_contributor_principal_ids = optional(list(string), [])
    index_data_reader_principal_ids = optional(list(string), [])
    tags        = optional(map(string), {})
    cost_center = optional(string, "")
    owner       = optional(string, "")
    project     = optional(string, "")
  }))
  default = {}
}

# =============================================================================
# Cosmos DB Module Variables
# =============================================================================

variable "cosmos_accounts" {
  description = "Configuration for Cosmos DB Accounts to be created"
  type = map(object({
    application_name     = string
    environment         = string
    resource_group_name = string
    location            = string
    cosmosdb_account_name = string
    offer_type          = optional(string, "Standard")
    kind                = optional(string, "GlobalDocumentDB")
    enable_automatic_failover = optional(bool, true)
    enable_multiple_write_locations = optional(bool, false)
    public_network_access_enabled = optional(bool, false)
    consistency_policy = optional(object({
      consistency_level       = string
      max_interval_in_seconds = optional(number, 300)
      max_staleness_prefix    = optional(number, 100000)
    }), {
      consistency_level = "Session"
    })
    capabilities = optional(list(string), [])
    geo_location = optional(list(object({
      location          = string
      failover_priority = number
      zone_redundant    = optional(bool, false)
    })), [])
    enable_private_endpoint = optional(bool, true)
    privatelink_subnet = optional(object({
      name           = string
      vnet_name      = string
      resource_group = string
    }), null)
    private_dns_zone_ids   = optional(list(string), [])
    virtual_network_rules  = optional(list(string), [])
    backup = optional(object({
      type = string
      tier = optional(string, "Continuous30Days")
    }), {
      type = "Continuous"
      tier = "Continuous30Days"
    })
    sql_databases = optional(list(object({
      name = string
    })), [])
    sql_containers = optional(list(object({
      name               = string
      database_name      = string
      partition_key_path = string
    })), [])
    tags = optional(map(string), {})
  }))
  default = {}
}

# =============================================================================
# Log Analytics Workspace Module Variables (Future Implementation)
# =============================================================================

variable "log_analytics_workspaces" {
  description = "Configuration for Log Analytics Workspaces to be created"
  type = map(object({
    resource_group_name = string
    location           = string
    application_name   = string
    environment        = string
    sku               = optional(string, "PerGB2018")
    retention_in_days = optional(number, 30)
    tags              = optional(map(string), {})
  }))
  default = {}
}

# =============================================================================
# Common Variables
# =============================================================================

variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default     = {}
}