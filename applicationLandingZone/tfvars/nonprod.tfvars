# =============================================================================
# Platform Variables for AI Services NonProd
# =============================================================================

## AI services NonProd ##
environment                 = "dev"
application_name             = "aiapps"
ainonprod_sub_id            = "bb14fef7-35fb-4743-846a-85f6051acb7f"
resource_group_name_dns     = "rg-dns-nonprod-uaenorth"
subnet_id                   = "/subscriptions/bb14fef7-35fb-4743-846a-85f6051acb7f/resourceGroups/rg-dev-uan-aiapps/providers/Microsoft.Network/virtualNetworks/vnet-aiapps-dev-uan/subnets/snet-privatelink"
subnet_id_aifoundry         = "/subscriptions/bb14fef7-35fb-4743-846a-85f6051acb7f/resourceGroups/rg-dev-uan-aiapps/providers/Microsoft.Network/virtualNetworks/vnet-aiapps-dev-uan/subnets/snet-aifoundry"
subscription_id_resources   = "bb14fef7-35fb-4743-846a-85f6051acb7f"
subscription_id_infra       = "bb14fef7-35fb-4743-846a-85f6051acb7f"
location                    = "uaenorth"
existing_vnet_name          = "vnet-aiapps-dev-uan"
existing_vnet_rg            = "rg-dev-uan-aiapps"

# =============================================================================
# Module Enable/Disable Controls
# =============================================================================

# Customer provides these resources - disable creation, enable data sources
enable_existing_key_vaults              = 1
enable_existing_storage_accounts        = 1
enable_existing_ai_search_services      = 1
enable_existing_log_analytics_workspaces = 0  # No existing LAW found, using created resources
enable_existing_cosmos_db               = 0  # No existing Cosmos DB found, using created resources

# Only deploy application services
enable_key_vaults                   = 0  # Customer provided
enable_function_apps               = 1  # Deploy new
enable_container_registries        = 1  # Deploy new
enable_container_app_environments  = 1  # Deploy new
enable_container_apps              = 1  # Deploy new
enable_ai_search_services          = 0  # Customer provided
enable_cosmos_db                   = 1  # Deploy new - customer resource not found
enable_logic_apps                  = 1  # Deploy new

# =============================================================================
# Existing Resources (Customer Provided)
# =============================================================================

existing_key_vaults = {
  "existing-kv" = {
    name                = "kv-aiapps-dev-uan-01avto"
    resource_group_name = "rg-dev-uan-aiapps"
  }
}

existing_storage_accounts = {
  "existing-storage" = {
    name                = "funcsaaiappsdevuan68ydmy"
    resource_group_name = "rg-dev-uan-aiapps"
  }
}

existing_ai_search_services = {
  "existing-search" = {
    name                = "srch-aiapps-dev-uan-39e1hk"
    resource_group_name = "rg-dev-uan-aiapps"
  }
}

# existing_log_analytics_workspaces = {
#   "existing-law" = {
#     name                = "law-aiapps-dev-uaenorth"  # Resource not found
#     resource_group_name = "rg-dev-uan-aiapps"
#   }
# }

# existing_cosmos_db_accounts = {
#   "existing-cosmos" = {
#     name                = "cosmos-aiapps-dev-uan-km-uan-6fr731"  # Resource not found
#     resource_group_name = "rg-dev-uan-aiapps"
#   }
# }

# =============================================================================
# Resource-Specific Configurations (Legacy - commented out, using existing resources)
# =============================================================================

# key_vaults = {
#   "app-dev-kv" = {
#     resource_group_name           = "rg-dev-uan-aiapps"
#     application_name              = "aiapps"
#     environment                   = "dev"
#     resource_location             = "uaenorth"
#     enabled_for_deployment        = true
#     enabled_for_disk_encryption   = true
#     purge_protection_enabled      = true
#     public_network_access_enabled = false
#     rbac_authorization_enabled    = true
#     sku_name                      = "standard"
#     soft_delete_retention_days    = 7
#     network_acls = {
#       bypass         = "AzureServices"
#       default_action = "Allow"
#       ip_rules       = []
#       virtual_network_subnet_ids = []
#     }
#     role_assignments = {
#       # Function App's User-Assigned Managed Identity access to secrets
#       "func-app-secrets-user" = {
#         role_definition_id_or_name = "Key Vault Secrets User"
#         principal_id               = "26940680-91d1-4a89-8caf-ab7693eccc61"
#         description                = "Function App access to Key Vault secrets"
#       }
#     }
#     owners = "DevOps Team"
#     lock = {
#       kind = "None"
#     }
#     diagnostic_settings = {
#       # Commented out until Log Analytics workspace is available
#       # "default" = {
#       #   name                         = "kv-diagnostics-dev"
#       #   log_groups                   = ["allLogs"]
#       #   metric_categories            = ["AllMetrics"]
#       #   log_analytics_destination_type = "Dedicated"
#       #   workspace_resource_id        = "/subscriptions/SUBSCRIPTION_ID/resourceGroups/RESOURCE_GROUP_NAME/providers/Microsoft.OperationalInsights/workspaces/WORKSPACE_NAME"
#       # }
#     }
#     privatelink_subnet = {
#       name           = "snet-privatelink"
#       vnet_name      = "vnet-aiapps-dev-uan"
#       resource_group = "rg-dev-uan-aiapps"
#     }
#     private_dns_zone_name = "privatelink.vaultcore.azure.net"
#     private_dns_zone_id   = "/subscriptions/bb14fef7-35fb-4743-846a-85f6051acb7f/resourceGroups/rg-dev-uan-aiapps/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"
#     tags = {
#       Environment   = "Development"
#       Application   = "MyApp"
#       Owner         = "DevOps Team"
#       CostCenter    = "IT-DEV"
#       Project       = "ApplicationLandingZone"
#       CreatedBy     = "Terraform"
#       CreatedDate   = "2025-09-17"
#     }
#   }
# }

# Function Apps Configuration
function_apps = {
  "app-dev-func" = {
    resource_group_name    = "rg-dev-uan-aiapps"
    application_name       = "aiapps"
    environment           = "dev"
    resource_location     = "uaenorth"
    service_plan_sku      = "EP1"  # Elastic Premium plan - supports VNet integration

    # Function Apps to deploy (for_each loop will create these)
    function_apps = {
      "api" = {
        name            = "api"
        file_share_name = "aiapps-dev-api-content"
        env_vars = {
          "FUNCTIONS_WORKER_RUNTIME" = "python"
          "MyCustomSetting"          = "development"
        }
      }
    }

    # Networking Configuration
    app_function_subnet = {
      name           = "snet-function-apps-outbound"
      vnet_name      = "vnet-aiapps-dev-uan"
      resource_group = "rg-dev-uan-aiapps"
    }

    privatelink_subnet = {
      name           = "snet-privatelink"
      vnet_name      = "vnet-aiapps-dev-uan"
      resource_group = "rg-dev-uan-aiapps"
    }

    privatelink_funcapp_subnet = {
      name           = "snet-privatelink"
      vnet_name      = "vnet-aiapps-dev-uan"
      resource_group = "rg-dev-uan-aiapps"
    }

    # DNS Configuration for Private Links
    private_dns_zone_id             = "/subscriptions/bb14fef7-35fb-4743-846a-85f6051acb7f/resourceGroups/rg-dev-uan-aiapps/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
    func_app_private_dns_zone_id    = "/subscriptions/bb14fef7-35fb-4743-846a-85f6051acb7f/resourceGroups/rg-dev-uan-aiapps/providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net"
    file_share_private_dns_zone_id  = "/subscriptions/bb14fef7-35fb-4743-846a-85f6051acb7f/resourceGroups/rg-dev-uan-aiapps/providers/Microsoft.Network/privateDnsZones/privatelink.file.core.windows.net"

    # Security & Access
    public_network_access_enabled = false
    vnet_route_all_enabled        = true

    # Application Insights
    application_insights_enabled = true

    # Storage Configuration
    storage_use                   = true
    sku_name                     = "Standard_LRS"
    customer_managed_key_enabled = false
    create_fileshare             = false

    # Key Vault Configuration (use existing)
    kv_name                      = "kv-aiapps-dev-uan-01avto"  # Existing Key Vault
    kv_resource_group_name       = "rg-dev-uan-aiapps"
    cmk_name                     = ""

    # Additional module requirements
    file_shares                  = []
    site_config                  = null
    connection_strings           = []
    backup                       = null
    artifact_url                 = null

    tags = {
      Environment   = "Development"
      Application   = "MyApp"
      Owner         = "DevOps Team"
      CostCenter    = "IT-DEV"
      Project       = "ApplicationLandingZone"
      CreatedBy     = "Terraform"
      CreatedDate   = "2025-09-17"
      ResourceType  = "Function App"
    }
  }
}

container_registries = {
  "app-dev-acr" = {
    resource_group_name           = "rg-dev-uan-aiapps"
    application_name              = "aiapps"
    environment                   = "dev"
    resource_location             = "uaenorth"
    zone_redundancy_enabled       = "false"
    sku                          = "Premium"
    admin_enabled                = false  # Use managed identity instead
    public_network_access_enabled = false  # Private access only
    data_endpoint_enabled        = true   # Enable for Premium SKU
    encryption_enabled           = false  # Can be enabled if needed

    # Image retention policies
    images_retention_enabled     = true
    images_retention_days        = 30     # Retain for 30 days in dev
    retention_policy_in_days     = 7      # Purge untagged after 7 days

    # Security settings
    azure_services_bypass_allowed = true
    trust_policy_enabled         = false  # Can be enabled for production

    # Network access - allow from VNet subnets
    allowed_cidrs    = []
    allowed_subnets  = []  # Will be populated when VNet is ready

    # Private Link configuration
    privatelink_subnet = {
      name           = "snet-privatelink"
      vnet_name      = "vnet-aiapps-dev-uan"
      resource_group = "rg-dev-uan-aiapps"
    }

    # Private DNS zone for Container Registry
    private_dns_zone_id = "/subscriptions/bb14fef7-35fb-4743-846a-85f6051acb7f/resourceGroups/rg-dev-uan-aiapps/providers/Microsoft.Network/privateDnsZones/privatelink.azurecr.io"

    # Role assignments - Function Apps and other services will get access
    role_assignments = {
      # Function App's managed identity will get AcrPull access
      # This will be added after function apps are deployed
    }

    tags = {
      Environment   = "Development"
      Application   = "MyApp"
      Owner         = "DevOps Team"
      CostCenter    = "IT-DEV"
      Project       = "ApplicationLandingZone"
      CreatedBy     = "Terraform"
      CreatedDate   = "2025-09-22"
      ResourceType  = "Container Registry"
      Purpose       = "Container Images"
    }
  }
}

# Container App Environments Configuration
container_app_environments = {
  "app-dev-cae" = {
    management_sub_id    = "bb14fef7-35fb-4743-846a-85f6051acb7f"
    resource_group_name  = "rg-dev-uan-aiapps"
    application_name     = "aiapps"
    environment         = "dev"
    resource_location   = "uaenorth"

    # Container App Environment subnet (dedicated for container apps)
    subnet = {
      name           = "snet-container-apps"
      vnet_name      = "vnet-aiapps-dev-uan"
      resource_group = "rg-dev-uan-aiapps"
    }

    # Workload profile for container apps
    workload_profile = {
      name                  = "Consumption"
      workload_profile_type = "Consumption"
    }

    # TODO: Replace with actual Log Analytics workspace ID
    log_analytics_workspace_id = "/subscriptions/bb14fef7-35fb-4743-846a-85f6051acb7f/resourceGroups/rg-dev-uan-aiapps/providers/Microsoft.OperationalInsights/workspaces/law-myapp-dev-uan"

    tags = {
      Environment   = "Development"
      Application   = "MyApp"
      Owner         = "DevOps Team"
      CostCenter    = "IT-DEV"
      Project       = "ApplicationLandingZone"
      CreatedBy     = "Terraform"
      CreatedDate   = "2025-09-22"
      ResourceType  = "Container App Environment"
      Purpose       = "Container Hosting"
    }
  }
}

# Container Apps Configuration
container_apps = {
  "app-dev-api" = {
    resource_group_name = "rg-dev-uan-aiapps"
    application_name    = "aiappsapi"
    environment        = "dev"
    resource_location  = "uaenorth"
    container_app_environment_name = "app-dev-cae"
    revision_mode = "Single"

    containers = [
      {
        name   = "myapp-api"
        image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
        cpu    = "0.25"
        memory = "0.5Gi"
        env = [
          {
            name  = "ENVIRONMENT"
            value = "development"
          },
          {
            name  = "LOG_LEVEL"
            value = "Debug"
          }
        ]
      }
    ]

    ingress = {
      external_enabled = false
      target_port     = 8080
    }

    tags = {
      Environment   = "Development"
      Application   = "MyApp"
      Owner         = "DevOps Team"
      CostCenter    = "IT-DEV"
      Project       = "ApplicationLandingZone"
      CreatedBy     = "Terraform"
      CreatedDate   = "2025-09-22"
      ResourceType  = "Container App"
      Purpose       = "API Service"
    }
  }

  "app-dev-worker" = {
    resource_group_name = "rg-dev-uan-aiapps"
    application_name    = "aiappsworker"
    environment        = "dev"
    resource_location  = "uaenorth"
    container_app_environment_name = "app-dev-cae"
    revision_mode = "Single"

    containers = [
      {
        name   = "myapp-worker"
        image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
        cpu    = "0.5"
        memory = "1.0Gi"
        env = [
          {
            name  = "ENVIRONMENT"
            value = "development"
          },
          {
            name  = "LOG_LEVEL"
            value = "Info"
          },
          {
            name  = "WORKER_TYPE"
            value = "background"
          }
        ]
      }
    ]

    tags = {
      Environment   = "Development"
      Application   = "MyApp"
      Owner         = "DevOps Team"
      CostCenter    = "IT-DEV"
      Project       = "ApplicationLandingZone"
      CreatedBy     = "Terraform"
      CreatedDate   = "2025-09-22"
      ResourceType  = "Container App"
      Purpose       = "Background Processing"
    }
  }
}

# =============================================================================
# AI Services Configurations
# =============================================================================

# ai_search_services = {
#   "app-dev-search" = {
#     resource_group_name    = "rg-dev-uan-aiapps"
#     location              = "uaenorth"
#     application_name      = "aiapps"
#     environment           = "dev"
#     location_shortcode    = "uan"
#     sku                   = "standard"
#     partition_count       = 1
#     replica_count         = 1
#     hosting_mode          = "default"
#     public_network_access_enabled = false
#     allowed_ips           = []
#     authentication_failure_mode = "http401WithBearerChallenge"
#     customer_managed_key_enforcement_enabled = false
#     enable_system_assigned_identity = true

#     # Private Endpoint Configuration
#     private_endpoint_enabled = true
#     private_endpoint_subnet_name = "snet-privatelink"
#     virtual_network_name = "vnet-aiapps-dev-uan"
#     network_resource_group_name = "rg-dev-uan-aiapps"
#     private_dns_zone_id = "/subscriptions/bb14fef7-35fb-4743-846a-85f6051acb7f/resourceGroups/rg-dev-uan-aiapps/providers/Microsoft.Network/privateDnsZones/privatelink.search.windows.net"

#     # Monitoring Configuration
#     log_analytics_workspace_id = "/subscriptions/bb14fef7-35fb-4743-846a-85f6051acb7f/resourceGroups/rg-dev-uan-aiapps/providers/Microsoft.OperationalInsights/workspaces/law-aiapps-dev-uaenorth"
#     diagnostic_logs_retention_days = 30
#     diagnostic_metrics_retention_days = 30

#     # RBAC Configuration
#     contributor_principal_ids = []
#     index_data_contributor_principal_ids = []
#     index_data_reader_principal_ids = []

#     tags = {
#       Environment   = "dev"
#       Application   = "aiapps"
#       Owner         = "AI Team"
#       CostCenter    = "AI-DEV"
#       Project       = "AI Services"
#       CreatedBy     = "Terraform"
#       CreatedDate   = "2025-10-07"
#     }
#     cost_center = "AI-DEV"
#     owner = "AI Team"
#     project = "AI Services"
#   }
# }

cosmos_db_services = {
  "app-dev-cosmos" = {
    application_name     = "aiapps"
    environment         = "dev"
    resource_group_name = "rg-dev-uan-aiapps"
    location            = "uaenorth"
    cosmosdb_account_name = "cosmos-aiapps-dev-uan-km"

    # Account Configuration
    offer_type              = "Standard"
    kind                    = "GlobalDocumentDB"
    enable_automatic_failover = true
    enable_multiple_write_locations = false
    public_network_access_enabled = false

    # Consistency Policy
    consistency_policy = {
      consistency_level       = "Session"
      max_interval_in_seconds = 300
      max_staleness_prefix    = 100000
    }

    # Capabilities (Serverless mode)
    capabilities = ["EnableServerless"]

    # Geo Location
    geo_location = [
      {
        location          = "uaenorth"
        failover_priority = 0
        zone_redundant    = false
      }
    ]

    # Private Endpoint Configuration
    enable_private_endpoint = true
    privatelink_subnet = {
      name           = "snet-privatelink"
      vnet_name      = "vnet-aiapps-dev-uan"
      resource_group = "rg-dev-uan-aiapps"
    }
    private_dns_zone_ids   = [
      "/subscriptions/bb14fef7-35fb-4743-846a-85f6051acb7f/resourceGroups/rg-dev-uan-aiapps/providers/Microsoft.Network/privateDnsZones/privatelink.documents.azure.com"
    ]
    virtual_network_rules  = []

    # Backup Configuration - Continuous backup for enterprise requirements
    backup = {
      type = "Continuous"
      tier = "Continuous30Days"
    }

    # Database and Container Configuration
    sql_databases = [
      {
        name = "KnowledgeBase"
      },
      {
        name = "DocumentStore"
      },
      {
        name = "UserProfiles"
      }
    ]

    sql_containers = [
      {
        name               = "Documents"
        database_name      = "KnowledgeBase"
        partition_key_path = "/tenantId"
      },
      {
        name               = "Embeddings"
        database_name      = "KnowledgeBase"
        partition_key_path = "/documentId"
      },
      {
        name               = "Files"
        database_name      = "DocumentStore"
        partition_key_path = "/categoryId"
      },
      {
        name               = "Profiles"
        database_name      = "UserProfiles"
        partition_key_path = "/userId"
      }
    ]

    tags = {
      Environment   = "Development"
      Application   = "AIApps"
      Owner         = "DevOps Team"
      CostCenter    = "IT-DEV"
      Project       = "ApplicationLandingZone"
      CreatedBy     = "Terraform"
      CreatedDate   = "2025-09-24"
      ResourceType  = "Cosmos DB"
      Purpose       = "Knowledge Management Data Store"
    }
  }
}

logic_apps_services = {
  "app-dev-logic" = {
    application_name     = "aiapps"
    environment         = "dev"
    resource_group_name = "rg-dev-uan-aiapps"
    resource_location   = "uaenorth"

    # Service Plan Configuration
    service_plan_name = "aiapps-dev-logic-plan"
    service_plan_sku  = "WS1"
    existing_service_plan = null

    # Identity Configuration
    uai_required = true
    user_assigned_identity_ids = []

    # Storage Configuration
    storage_account_name = "aiappsdevlogicstore"
    sku_name            = "Standard_LRS"
    file_shares         = []
    create_fileshare    = false

    # Security & Keys
    customer_managed_key_enabled = false
    kv_name                      = ""
    kv_resource_group_name       = ""
    cmk_name                     = ""
    storage_use                  = false

    # Private Endpoint Configuration
    privatelink_subnet = {
      name           = "snet-privatelink"
      vnet_name      = "vnet-aiapps-dev-uan"
      resource_group = "rg-dev-uan-aiapps"
    }
    private_dns_zone_id = "/subscriptions/bb14fef7-35fb-4743-846a-85f6051acb7f/resourceGroups/rg-dev-uan-aiapps/providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net"
    file_share_private_dns_zone_id = "/subscriptions/bb14fef7-35fb-4743-846a-85f6051acb7f/resourceGroups/rg-dev-uan-aiapps/providers/Microsoft.Network/privateDnsZones/privatelink.file.core.windows.net"

    # Logic Apps Configuration - Document processing workflows
    workflow_apps = {
      "DocumentProcessor" = {
        name = "logic-docprocess-aiapps-dev-uan"
      },
      "WorkflowOrchestrator" = {
        name = "logic-orchestrator-aiapps-dev-uan"
      }
    }
    definistion_file_path    = ""

    tags = {
      Environment   = "Development"
      Application   = "AIApps"
      Owner         = "DevOps Team"
      CostCenter    = "IT-DEV"
      Project       = "ApplicationLandingZone"
      CreatedBy     = "Terraform"
      CreatedDate   = "2025-09-24"
      Purpose       = "Workflow Orchestration"
      ResourceType  = "Logic Apps Standard"
    }
  }
}
