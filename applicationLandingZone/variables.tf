# =============================================================================
# Platform-Level Variables for AI Services NonProd
# =============================================================================

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "application_name" {
  description = "Application name used for resource naming"
  type        = string
  default     = "aiapps"
}

variable "ainonprod_sub_id" {
  description = "Subscription ID for AI-Services non-prod environment"
  type        = string
  default     = ""
}

variable "resource_group_name_dns" {
  description = "Resource group name for DNS resources"
  type        = string
  default     = ""
}

variable "subnet_id" {
  description = "Subnet ID for general resources"
  type        = string
  default     = ""
}

variable "subnet_id_aifoundry" {
  description = "Subnet ID specifically for AI Foundry resources"
  type        = string
  default     = ""
}

variable "subscription_id_resources" {
  description = "Subscription ID for deploying resources"
  type        = string
  default     = ""
}

variable "subscription_id_infra" {
  description = "Subscription ID for infrastructure resources"
  type        = string
  default     = ""
}

variable "location" {
  description = "Azure region for resource deployment"
  type        = string
  default     = "uaenorth"
}

variable "existing_vnet_name" {
  description = "Name of existing virtual network"
  type        = string
  default     = ""
}

variable "existing_vnet_rg" {
  description = "Resource group name of existing virtual network"
  type        = string
  default     = ""
}

# =============================================================================
# Module Enable/Disable Count Variables
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
# Legacy Variables (kept for backward compatibility)
# =============================================================================

# Azure Subscription Configuration
variable "subscription_id" {
  description = "Azure subscription ID where resources will be deployed"
  type        = string
  default     = "bb14fef7-35fb-4743-846a-85f6051acb7f"
}

variable "key_vaults" {
  description = "Map of Key Vault configurations"
  type = map(object({
    resource_location              = optional(string, "uaenorth")
    resource_group_name           = string
    application_name              = string
    environment                   = string
    enabled_for_deployment        = optional(bool, false)
    enabled_for_disk_encryption   = optional(bool, false)
    purge_protection_enabled      = optional(bool, true)
    public_network_access_enabled = optional(bool, false)
    rbac_authorization_enabled    = optional(bool, false)
    sku_name                      = optional(string, "standard")
    soft_delete_retention_days    = optional(number, 7)
    network_acls = optional(object({
      bypass                     = optional(string, "None")
      default_action             = optional(string, "Deny")
      ip_rules                   = optional(list(string), [])
      virtual_network_subnet_ids = optional(list(string), [])
    }), {})
    role_assignments = optional(map(object({
      role_definition_id_or_name             = string
      principal_id                           = string
      description                            = optional(string, null)
      skip_service_principal_aad_check       = optional(bool, false)
      condition                              = optional(string, null)
      condition_version                      = optional(string, null)
      delegated_managed_identity_resource_id = optional(string, null)
    })), {})
    owners = optional(string, "")
    lock = optional(object({
      name = optional(string, null)
      kind = optional(string, "None")
    }), {})
    diagnostic_settings = optional(map(object({
      name                                     = optional(string, null)
      log_categories                           = optional(set(string), [])
      log_groups                               = optional(set(string), ["allLogs"])
      metric_categories                        = optional(set(string), ["AllMetrics"])
      log_analytics_destination_type           = optional(string, "Dedicated")
      workspace_resource_id                    = optional(string, null)
      storage_account_resource_id              = optional(string, null)
      event_hub_authorization_rule_resource_id = optional(string, null)
      event_hub_name                           = optional(string, null)
      marketplace_partner_resource_id          = optional(string, null)
    })), {})
    private_dns_zone_name = optional(string, null)
    privatelink_subnet = optional(object({
      name           = string
      vnet_name      = string
      resource_group = string
    }), null)
    tags                  = optional(map(string), {})
    private_dns_zone_id   = optional(string, "")
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.key_vaults : contains(["dev", "qa", "sit", "uat", "preprod", "prod"], v.environment)
    ])
    error_message = "Allowed values for environment: dev, qa, uat, sit, preprod, prod."
  }

  validation {
    condition = alltrue([
      for k, v in var.key_vaults : contains(["CanNotDelete", "ReadOnly", "None"], v.lock.kind)
    ])
    error_message = "The lock level must be one of: 'None', 'CanNotDelete', or 'ReadOnly'."
  }
}

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
    storage_use                          = optional(string, "func")
    sku_name                             = optional(string, "Standard_LRS")
    create_fileshare                     = optional(bool, false)
    file_shares = optional(list(object({
      name  = string
      quota = number
    })), [])
    site_config = optional(object({
      always_on                         = optional(bool)
      app_command_line                  = optional(string)
      default_documents                 = optional(list(string))
      ftps_state                        = optional(string)
      health_check_path                 = optional(string)
      health_check_eviction_time_in_min = optional(string)
      http2_enabled                     = optional(string)
      load_balancing_mode               = optional(string)
      app_scale_limit                   = optional(string)
      elastic_instance_minimum          = optional(string)
      pre_warmed_instance_count         = optional(string)
      application_stack                 = optional(map(string))
      app_service_logs = optional(object({
        disk_quota_mb         = number
        retention_period_days = number
      }))
      cidr_restriction = optional(list(object({
        name     = optional(string)
        priority = optional(number)
        action   = optional(string)
        cidr     = optional(string)
      })), [])
      subnet_restriction = optional(list(object({
        name      = optional(string)
        priority  = optional(number)
        action    = optional(string)
        subnet_id = optional(string)
      })), [])
      service_tags_restriction = optional(list(object({
        name        = optional(string)
        priority    = optional(number)
        action      = optional(string)
        service_tag = optional(string)
      })), [])
      default_ip_restriction_action = optional(string)
      cors = optional(object({
        allowed_origins     = optional(list(string))
        support_credentials = optional(bool)
      }))
    }), {})
    connection_strings = optional(list(object({
      name  = string
      type  = string
      value = string
    })), [])
    backup = optional(object({
      backup_sa = object({
        name           = string
        resource_group = string
      })
      enabled = optional(bool)
      schedule = object({
        frequency_interval       = number
        frequency_unit           = string
        start_time               = optional(string)
        retention_period_days    = optional(number)
        keep_at_least_one_backup = optional(bool)
      })
    }), null)
    artifact_url = optional(string, null)
    tags         = optional(map(string), {})
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
    error_message = "Valid values for service plan sku are: (Y1, EP1, EP2, and EP3)."
  }
}

variable "container_registries" {
  description = "Map of Container Registry configurations"
  type = map(object({
    resource_location               = optional(string, "uaenorth")
    resource_group_name            = string
    application_name               = string
    environment                    = string
    zone_redundancy_enabled        = optional(string, "false")
    key_expiration_date           = optional(string, "2027-12-31T23:59:59Z")
    sku                           = optional(string, "Premium")
    azurerm_key_vault_key         = optional(string, null)
    kv_name                       = optional(string, null)
    admin_enabled                 = optional(bool, false)
    georeplication_locations      = optional(list(any), [])
    images_retention_enabled      = optional(bool, false)
    images_retention_days         = optional(number, 90)
    retention_policy_in_days      = optional(number, 7)
    azure_services_bypass_allowed = optional(bool, true)
    trust_policy_enabled          = optional(bool, false)
    allowed_cidrs                 = optional(list(string), [])
    allowed_subnets               = optional(list(string), [])
    public_network_access_enabled = optional(bool, false)
    data_endpoint_enabled         = optional(bool, false)
    encryption_enabled            = optional(bool, false)
    privatelink_subnet = optional(object({
      name           = string
      vnet_name      = string
      resource_group = string
    }), null)
    private_dns_zone_id = optional(string, null)
    role_assignments = optional(map(object({
      role_definition_id_or_name             = string
      principal_id                           = string
      description                            = optional(string, null)
      skip_service_principal_aad_check       = optional(bool, false)
      condition                              = optional(string, null)
      condition_version                      = optional(string, null)
      delegated_managed_identity_resource_id = optional(string, null)
    })), {})
    tags = optional(map(string), {})
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
    error_message = "Valid values for Container Registry SKU are: Basic, Standard, Premium."
  }
}

variable "container_app_environments" {
  description = "Map of Container App Environment configurations"
  type = map(object({
    management_sub_id           = string
    resource_location          = optional(string, "uaenorth")
    resource_group_name        = string
    application_name           = string
    environment               = string
    subnet = optional(object({
      name           = string
      vnet_name      = string
      resource_group = string
    }), null)
    workload_profile = object({
      name                  = string
      workload_profile_type = string
    })
    log_analytics_workspace_id = string
    tags                      = optional(map(string), {})
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
    resource_location             = optional(string, "uaenorth")
    resource_group_name          = string
    application_name             = string
    environment                  = string
    tags                        = optional(map(string), {})
    registry = object({
      name                = string
      resource_group_name = string
    })
    container_app_environment_key = string  # Reference to container_app_environments key
    ingress_external_enabled     = optional(bool, false)
    ingress_target_port         = number
    ingress_transport           = optional(string, "auto")
    environment_variables       = optional(map(string), {})
    workload_profile_name       = optional(string, "Consumption")
    container_config = object({
      name   = string
      cpu    = string
      memory = string
      image  = string
    })
    revision_mode            = optional(string, "Single")
    external_identity_ids   = optional(list(string), [])
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.container_apps : contains(["dev", "qa", "sit", "uat", "preprod", "prod"], v.environment)
    ])
    error_message = "Allowed values for environment: dev, qa, uat, sit, preprod, prod."
  }
}

variable "ai_search_services" {
  description = "Map of AI Search service configurations"
  type = map(object({
    resource_group_name    = string
    location              = optional(string, "uaenorth")
    application_name      = string
    environment           = string
    location_shortcode    = optional(string, "uan")
    sku                   = optional(string, "standard")
    partition_count       = optional(number, 1)
    replica_count         = optional(number, 1)
    hosting_mode          = optional(string, "default")
    public_network_access_enabled = optional(bool, false)
    allowed_ips           = optional(list(string), [])
    authentication_failure_mode = optional(string, "http403")
    customer_managed_key_enforcement_enabled = optional(bool, false)
    enable_system_assigned_identity = optional(bool, true)

    # Private Endpoint Configuration
    private_endpoint_enabled = optional(bool, true)
    private_endpoint_subnet_name = optional(string, "")
    virtual_network_name = optional(string, "")
    network_resource_group_name = optional(string, "")
    private_dns_zone_id = optional(string, "")

    # Monitoring Configuration
    log_analytics_workspace_id = optional(string, "")
    diagnostic_logs_retention_days = optional(number, 30)
    diagnostic_metrics_retention_days = optional(number, 30)

    # RBAC Configuration
    contributor_principal_ids = optional(list(string), [])
    index_data_contributor_principal_ids = optional(list(string), [])
    index_data_reader_principal_ids = optional(list(string), [])

    # Tagging
    tags = optional(map(string), {})
    cost_center = optional(string, "")
    owner = optional(string, "")
    project = optional(string, "")
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.ai_search_services : contains(["dev", "qa", "sit", "uat", "preprod", "prod"], v.environment)
    ])
    error_message = "Allowed values for environment: dev, qa, uat, sit, preprod, prod."
  }

  validation {
    condition = alltrue([
      for k, v in var.ai_search_services : contains([
        "free", "basic", "standard", "standard2", "standard3",
        "storage_optimized_l1", "storage_optimized_l2"
      ], v.sku)
    ])
    error_message = "SKU must be one of: free, basic, standard, standard2, standard3, storage_optimized_l1, storage_optimized_l2."
  }
}

# ==============================================
# Cosmos DB Services Configuration
# ==============================================
variable "cosmos_db_services" {
  description = "Map of Cosmos DB service configurations"
  type = map(object({
    # Basic Configuration
    application_name     = string
    environment         = string
    resource_group_name = string
    location           = string
    cosmosdb_account_name = string

    # Account Configuration
    offer_type              = optional(string, "Standard")
    kind                    = optional(string, "GlobalDocumentDB")
    enable_automatic_failover = optional(bool, false)
    enable_multiple_write_locations = optional(bool, false)
    public_network_access_enabled = optional(bool, false)

    # Consistency Policy
    consistency_policy = optional(object({
      consistency_level       = string
      max_interval_in_seconds = optional(number)
      max_staleness_prefix    = optional(number)
    }), {
      consistency_level = "Session"
    })

    # Capabilities
    capabilities = optional(list(string), ["EnableServerless"])

    # Geo Location
    geo_location = optional(list(object({
      location          = string
      failover_priority = number
      zone_redundant    = optional(bool)
    })), [])

    # Virtual Network Rules
    virtual_network_rules = optional(list(object({
      subnet_id                               = string
      ignore_missing_vnet_service_endpoint    = optional(bool)
    })), null)

    # Backup Configuration
    backup = optional(object({
      type                = string
      tier                = optional(string)
      interval_in_minutes = optional(number)
      retention_in_hours  = optional(number)
      storage_redundancy  = optional(string)
    }), null)

    # SQL Databases
    sql_databases = optional(list(object({
      name = string
      autoscale_settings = optional(object({
        max_throughput = number
      }))
      throughput = optional(number)
    })), [])

    # SQL Containers
    sql_containers = optional(list(object({
      name               = string
      database_name      = string
      partition_key_path = string
      autoscale_settings = optional(object({
        max_throughput = number
      }))
      throughput = optional(number)
    })), [])

    # Tagging
    tags = optional(map(string), {})
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.cosmos_db_services : contains(["dev", "qa", "sit", "uat", "preprod", "prod"], v.environment)
    ])
    error_message = "Allowed values for environment: dev, qa, uat, sit, preprod, prod."
  }

  validation {
    condition = alltrue([
      for k, v in var.cosmos_db_services : contains(["GlobalDocumentDB", "MongoDB", "Parse"], v.kind)
    ])
    error_message = "Kind must be one of: GlobalDocumentDB, MongoDB, Parse."
  }
}

# ==============================================
# Logic Apps Services Configuration
# ==============================================
variable "logic_apps_services" {
  description = "Map of Logic Apps service configurations"
  type = map(object({
    # Basic Configuration
    application_name     = string
    environment         = string
    resource_group_name = string
    resource_location   = optional(string, "uaenorth")

    # Service Plan Configuration
    service_plan_name = string
    service_plan_sku  = optional(string, "WS1")
    existing_service_plan = optional(object({
      name                = string
      resource_group_name = string
    }), null)

    # Identity Configuration
    uai_required = optional(bool, true)
    user_assigned_identity_ids = optional(list(string), [])

    # Storage Configuration
    storage_account_name = optional(string, null)
    sku_name            = optional(string, "Standard_LRS")
    file_shares         = optional(list(object({
      name = string
      quota = number
    })), [])
    create_fileshare    = optional(bool, false)

    # Security & Keys
    customer_managed_key_enabled = optional(bool, false)
    kv_name                      = optional(string, null)
    kv_resource_group_name       = optional(string, null)
    cmk_name                     = optional(string, null)
    storage_use                  = optional(bool, false)

    # Private Endpoint Configuration
    privatelink_subnet = optional(object({
      name           = string
      vnet_name      = string
      resource_group = string
    }), null)
    private_dns_zone_id = string
    file_share_private_dns_zone_id = optional(string, null)

    # Logic Apps Configuration
    logic_apps = map(object({
      name     = string
      env_vars = map(string)
    }))
    definistion_file_path = optional(string, "path to the Logic App workflow definistion JSON")

    # Tagging
    tags = optional(map(string), {})
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