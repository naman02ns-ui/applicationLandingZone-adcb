## AI Apps NonProd##

environment = "dev"
application_name = "aiapps"
ainonprod_sub_id = "bb14fef7-35fb-4743-846a-85f6051acb7f"  #- This is sub ID for AI-Apps non-prod

#--------------AI Search--------------------#
# replica_count = 3

#--------------Network--------------------#
vnet_address_spaces = ["10.114.164.0/22"]
subnets = {

aiapps-containerapp-subnet1 = {
  subnet_name = "snet-ai-apps-uaenorth-001"
  subnet_address_prefix = ["10.114.164.0/23"]

  route_table_rules = [
    ["udr-to-fw", "0.0.0.0/0", "VirtualAppliance", "10.115.1.4"]
  ]

  delegation = {
    name = "container-app-delegation"
    service_delegation = {
      name = "Microsoft.App/environments"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}

aiapps-fa-inbound-subnet2 = {
  subnet_name = "snet-fn-app-inbound-uaenorth-001"
  subnet_address_prefix = ["10.114.166.0/25"]

  route_table_rules = [
    ["udr-to-fw", "0.0.0.0/0", "VirtualAppliance", "10.115.1.4"]
  ]

  delegation = {
    name = "function-app-delegation"
    service_delegation = {
      name = "Microsoft.Web/serverFarms"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}

aiapps-fa-outbound-subnet3 = {
  subnet_name = "snet-fn-app-outbound-uaenorth-001"
  subnet_address_prefix = ["10.114.166.128/25"]

  route_table_rules = [
    ["udr-to-fw", "0.0.0.0/0", "VirtualAppliance", "10.115.1.4"]
  ]

  delegation = {
    name = "function-app-delegation"
    service_delegation = {
      name = "Microsoft.Web/serverFarms"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}

aiapps-privatelink-subnet4 = {
  subnet_name = "snet-private-endpoint-uaenorth-001"
  subnet_address_prefix = ["10.114.167.0/26"]

  route_table_rules = [
    ["udr-to-fw", "0.0.0.0/0", "VirtualAppliance", "10.115.1.4"]
  ]
}

aiapps-appservice-subnet5 = {
  subnet_name = "snet-app-services-uaenorth-001"
  subnet_address_prefix = ["10.114.167.64/26"]

  route_table_rules = [
    ["udr-to-fw", "0.0.0.0/0", "VirtualAppliance", "10.115.1.4"]
  ]
}

aiapps-logicapp-subnet6 = {
  subnet_name = "snet-logic-app-uaenorth-001"
  subnet_address_prefix = ["10.114.167.128/25"]

  route_table_rules = [
    ["udr-to-fw", "0.0.0.0/0", "VirtualAppliance", "10.115.1.4"]
  ]

  delegation = {
    name = "logic-app-delegation"
    service_delegation = {
      name = "Microsoft.Web/serverFarms"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}

}
#--------------Network--------------------#

#--------------Cosmos--------------------#

selected_subnet = "snet-private-endpoint-uaenorth-001"

entity_name = "aiapps"

# Cosmos DB - Mongo
databases = {
  ailighthouse-prod-platform-db = {
    description    = "Mongo Database"
    max_throughput = 10000
    collections = [{ name = "application", shard_key = "key1" },
      { name = "payment", shard_key = "key2" },
    { name = "refdata", shard_key = "key3" }]
  }
}

#--------------storage--------------------#

containername = "aifoundry"

#--------------App Service Plans--------------------#

app_service_plans = {
  "aiapps-function-asp" = {
    resource_location        = "uaenorth"
    resource_group_name     = "rg-aiapps-nonprod-uaenorth-8200ys"
    application_name        = "aiapps"
    environment             = "dev"
    service_plan_sku        = "EP1"
    max_elastic_worker_count = 20
    worker_count            = null
    os_type                 = "Linux"
    diagnostic_settings     = {}
  }

  "aiapps-logic-asp" = {
    resource_location        = "uaenorth"
    resource_group_name     = "rg-aiapps-nonprod-uaenorth-8200ys"
    application_name        = "aiapps"
    environment             = "dev"
    service_plan_sku        = "EP1"
    max_elastic_worker_count = 15
    worker_count            = null
    os_type                 = "Linux"
    diagnostic_settings     = {}
  }
}

#--------------Container Registry--------------------#

container_registries = {
  "aiapps-nonprod-acr" = {
    resource_location               = "uaenorth"
    resource_group_name            = "rg-aiapps-nonprod-uaenorth-8200ys"
    application_name               = "aiapps"
    environment                    = "dev"
    zone_redundancy_enabled        = false
    key_expiration_date           = null
    sku                           = "Premium"
    azurerm_key_vault_key         = null
    kv_name                       = null
    admin_enabled                 = true
    georeplication_locations      = []
    images_retention_enabled      = true
    images_retention_days         = 7
    retention_policy_in_days      = 7
    azure_services_bypass_allowed = false
    trust_policy_enabled          = false
    allowed_cidrs                 = []
    allowed_subnets               = []
    public_network_access_enabled = false
    data_endpoint_enabled         = false
    encryption_enabled            = true
    azurerm_key_vault_key         = "cmk-container-registry"
    kv_name                       = "kv-aiapps-dev-uan"
    private_dns_zone_id           = null
  }
}

#--------------Container App Environment--------------------#

container_app_environments = {
  "aiapps-nonprod-cae" = {
    management_sub_id           = "eed58c8e-f08c-4839-9bfe-469f4705d062"
    resource_location          = "uaenorth"
    resource_group_name        = "rg-aiapps-nonprod-uaenorth-8200ys"
    application_name           = "aiapps"
    environment               = "dev"
    subnet = {
      name           = "snet-ai-apps-uaenorth-001"
      vnet_name      = "vnet-aiapps-dev-uan"
      resource_group = "rg-aiapps-nonprod-uaenorth-8200ys"
    }
    workload_profile = {
      name                  = "Consumption"
      workload_profile_type = "Consumption"
    }
    log_analytics_workspace_id = "/subscriptions/eed58c8e-f08c-4839-9bfe-469f4705d062/resourceGroups/rg-aiapps-nonprod-uaenorth-8200ys/providers/Microsoft.OperationalInsights/workspaces/log-aiapps-nonprod-uaenorth-001"
  }
}

# --------------Container Apps--------------------#
# Container Apps require pre-built container images in the registry
# Commenting out until images are available

# container_apps = {
#   "aiapps-api-service" = {
#     resource_location             = "uaenorth"
#     resource_group_name          = "rg-aiapps-nonprod-uaenorth-8200ys"
#     application_name             = "aiapps"
#     environment                  = "dev"
#     container_app_environment_name = "aiapps-nonprod-cae"
#     ingress = {
#       external_enabled = true
#       target_port     = 8080
#     }
#     containers = [{
#       name   = "api-service"
#       cpu    = "0.5"
#       memory = "1Gi"
#       image  = "aiapps-nonprod-acr.azurecr.io/api-service:latest"
#     }]
#     revision_mode = "Single"
#     identity = {
#       identity_ids = ["/subscriptions/eed58c8e-f08c-4839-9bfe-469f4705d062/resourceGroups/rg-aiapps-nonprod-uaenorth-8200ys/providers/Microsoft.ManagedIdentity/userAssignedIdentities/id-aiapps-api-nonprod-001"]
#     }
#     tags = {
#       Environment = "dev"
#       Service     = "API"
#     }
#   }
# }

container_apps = {}

#--------------Function Apps--------------------#

function_apps = {
  "aiagent-data-processor" = {
    resource_location                          = "uaenorth"
    resource_group_name                       = "rg-aiapps-nonprod-uaenorth-8200ys"
    application_name                          = "aiapps"
    environment                               = "dev"
    app_service_plan_name                     = "aiapps-function-asp"
    function_apps = {
      "func-aiagent-data-processor" = {
        name                 = "func-aiagent-data-processor"
        env_vars = {
          "FUNCTIONS_WORKER_RUNTIME" = "python"
          "PYTHON_VERSION"           = "3.12"
        }
        file_share_name     = "func-aiagent-data-processor-share"
      }
    }
    app_function_subnet = {
      name           = "snet-fn-app-outbound-uaenorth-001"
      vnet_name      = "vnet-aiapps-dev-uan"
      resource_group = "rg-aiapps-nonprod-uaenorth-8200ys"
    }
    # Provide subnet references but disable private endpoints via null DNS zones
    privatelink_subnet = {
      name           = "snet-private-endpoint-uaenorth-001"
      vnet_name      = "vnet-aiapps-dev-uan"
      resource_group = "rg-aiapps-nonprod-uaenorth-8200ys"
    }
    privatelink_funcapp_subnet = {
      name           = "snet-private-endpoint-uaenorth-001"
      vnet_name      = "vnet-aiapps-dev-uan"
      resource_group = "rg-aiapps-nonprod-uaenorth-8200ys"
    }
    private_dns_zone_id                       = "/subscriptions/connectivity-sub-id/resourceGroups/rg-connectivity-dns-uaenorth-01/providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net"
    func_app_private_dns_zone_id              = "/subscriptions/connectivity-sub-id/resourceGroups/rg-connectivity-dns-uaenorth-01/providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net"
    file_share_private_dns_zone_id            = "/subscriptions/connectivity-sub-id/resourceGroups/rg-connectivity-dns-uaenorth-01/providers/Microsoft.Network/privateDnsZones/privatelink.file.core.windows.net"
    public_network_access_enabled             = false
    vnet_route_all_enabled                    = true
    application_insights_enabled              = true
    application_insights_connection_string    = null
    application_insights_key                  = null
    log_analytics_worksapce_id                = null
    daily_memory_time_quota                   = 0
    customer_managed_key_enabled              = true
    kv_name                                   = "kv-aiapps-dev-uan"
    kv_resource_group_name                    = "rg-aiapps-nonprod-uaenorth-8200ys"
    cmk_name                                  = "cmk-aiagent-data-processor"
    storage_use                               = "AzureFiles"
    sku_name                                  = "Standard_LRS"
    create_fileshare                          = true
    enable_versioning                         = false
    file_shares                               = [
      {
        name = "func-aiagent-data-processor-share"
        quota = 5120
      }
    ]
  }

  "aiagent-ml-inference" = {
    resource_location                          = "uaenorth"
    resource_group_name                       = "rg-aiapps-nonprod-uaenorth-8200ys"
    application_name                          = "aiapps"
    environment                               = "dev"
    app_service_plan_name                     = "aiapps-function-asp"
    function_apps = {
      "func-aiagent-ml-inference" = {
        name                 = "func-aiagent-ml-inference"
        env_vars = {
          "FUNCTIONS_WORKER_RUNTIME" = "python"
          "PYTHON_VERSION"           = "3.12"
        }
        file_share_name     = "func-aiagent-ml-inference-share"
      }
    }
    app_function_subnet = {
      name           = "snet-fn-app-outbound-uaenorth-001"
      vnet_name      = "vnet-aiapps-dev-uan"
      resource_group = "rg-aiapps-nonprod-uaenorth-8200ys"
    }
    # Provide subnet references but disable private endpoints via null DNS zones
    privatelink_subnet = {
      name           = "snet-private-endpoint-uaenorth-001"
      vnet_name      = "vnet-aiapps-dev-uan"
      resource_group = "rg-aiapps-nonprod-uaenorth-8200ys"
    }
    privatelink_funcapp_subnet = {
      name           = "snet-private-endpoint-uaenorth-001"
      vnet_name      = "vnet-aiapps-dev-uan"
      resource_group = "rg-aiapps-nonprod-uaenorth-8200ys"
    }
    private_dns_zone_id                       = "/subscriptions/connectivity-sub-id/resourceGroups/rg-connectivity-dns-uaenorth-01/providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net"
    func_app_private_dns_zone_id              = "/subscriptions/connectivity-sub-id/resourceGroups/rg-connectivity-dns-uaenorth-01/providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net"
    file_share_private_dns_zone_id            = "/subscriptions/connectivity-sub-id/resourceGroups/rg-connectivity-dns-uaenorth-01/providers/Microsoft.Network/privateDnsZones/privatelink.file.core.windows.net"
    public_network_access_enabled             = false
    vnet_route_all_enabled                    = true
    application_insights_enabled              = true
    application_insights_connection_string    = null
    application_insights_key                  = null
    log_analytics_worksapce_id                = null
    daily_memory_time_quota                   = 0
    customer_managed_key_enabled              = true
    kv_name                                   = "kv-aiapps-dev-uan"
    kv_resource_group_name                    = "rg-aiapps-nonprod-uaenorth-8200ys"
    cmk_name                                  = "cmk-aiagent-ml-inference"
    storage_use                               = "AzureFiles"
    sku_name                                  = "Standard_LRS"
    create_fileshare                          = true
    enable_versioning                         = false
    file_shares                               = [
      {
        name = "func-aiagent-ml-inference-share"
        quota = 5120
      }
    ]
  }

  "aiagent-orchestrator" = {
    resource_location                          = "uaenorth"
    resource_group_name                       = "rg-aiapps-nonprod-uaenorth-8200ys"
    application_name                          = "aiapps"
    environment                               = "dev"
    app_service_plan_name                     = "aiapps-function-asp"
    function_apps = {
      "func-aiagent-orchestrator" = {
        name                 = "func-aiagent-orchestrator"
        env_vars = {
          "FUNCTIONS_WORKER_RUNTIME" = "python"
          "PYTHON_VERSION"           = "3.12"
        }
        file_share_name     = "func-aiagent-orchestrator-share"
      }
    }
    app_function_subnet = {
      name           = "snet-fn-app-outbound-uaenorth-001"
      vnet_name      = "vnet-aiapps-dev-uan"
      resource_group = "rg-aiapps-nonprod-uaenorth-8200ys"
    }
    # Provide subnet references but disable private endpoints via null DNS zones
    privatelink_subnet = {
      name           = "snet-private-endpoint-uaenorth-001"
      vnet_name      = "vnet-aiapps-dev-uan"
      resource_group = "rg-aiapps-nonprod-uaenorth-8200ys"
    }
    privatelink_funcapp_subnet = {
      name           = "snet-private-endpoint-uaenorth-001"
      vnet_name      = "vnet-aiapps-dev-uan"
      resource_group = "rg-aiapps-nonprod-uaenorth-8200ys"
    }
    private_dns_zone_id                       = "/subscriptions/connectivity-sub-id/resourceGroups/rg-connectivity-dns-uaenorth-01/providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net"
    func_app_private_dns_zone_id              = "/subscriptions/connectivity-sub-id/resourceGroups/rg-connectivity-dns-uaenorth-01/providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net"
    file_share_private_dns_zone_id            = "/subscriptions/connectivity-sub-id/resourceGroups/rg-connectivity-dns-uaenorth-01/providers/Microsoft.Network/privateDnsZones/privatelink.file.core.windows.net"
    public_network_access_enabled             = false
    vnet_route_all_enabled                    = true
    application_insights_enabled              = true
    application_insights_connection_string    = null
    application_insights_key                  = null
    log_analytics_worksapce_id                = null
    daily_memory_time_quota                   = 0
    customer_managed_key_enabled              = true
    kv_name                                   = "kv-aiapps-dev-uan"
    kv_resource_group_name                    = "rg-aiapps-nonprod-uaenorth-8200ys"
    cmk_name                                  = "cmk-aiagent-orchestrator"
    storage_use                               = "AzureFiles"
    sku_name                                  = "Standard_LRS"
    create_fileshare                          = true
    enable_versioning                         = false
    file_shares                               = [
      {
        name = "func-aiagent-orchestrator-share"
        quota = 5120
      }
    ]
  }
}

#--------------Logic Apps--------------------#

logic_apps = {
  "aiagent-workflow-orchestrator" = {
    resource_location                    = "uaenorth"
    resource_group_name                 = "rg-aiapps-nonprod-uaenorth-8200ys"
    application_name                    = "aiapps"
    environment                         = "dev"
    storage_account_name               = "staiappsnonproduaen001"
    app_service_plan_name              = "aiapps-logic-asp"
    service_plan_name                   = "asp-aiagent-workflow-nonprod-001"
    user_assigned_identity_ids          = ["/subscriptions/eed58c8e-f08c-4839-9bfe-469f4705d062/resourceGroups/rg-aiapps-nonprod-uaenorth-8200ys/providers/Microsoft.ManagedIdentity/userAssignedIdentities/id-aiagent-workflow-nonprod-001"]
    privatelink_subnet = {
      name           = "snet-private-endpoint-uaenorth-001"
      vnet_name      = "vnet-aiapps-dev-uan"
      resource_group = "rg-aiapps-nonprod-uaenorth-8200ys"
    }
    private_dns_zone_id                = "/subscriptions/connectivity-sub-id/resourceGroups/rg-connectivity-dns-uaenorth-01/providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net"
    sku_name                           = "Standard_LRS"
    file_shares                        = [
      {
        name = "logic-aiagent-workflow-share"
        quota = 5120
      }
    ]
    customer_managed_key_enabled       = true
    kv_name                            = "kv-aiapps-dev-uan"
    kv_resource_group_name             = "rg-aiapps-nonprod-uaenorth-8200ys"
    cmk_name                           = "cmk-aiagent-workflow"
    storage_use                        = true
    definistion_file_path              = null
    file_share_private_dns_zone_id     = "/subscriptions/connectivity-sub-id/resourceGroups/rg-connectivity-dns-uaenorth-01/providers/Microsoft.Network/privateDnsZones/privatelink.file.core.windows.net"
    create_fileshare                   = true
    uai_required                       = true
    logic_apps = {
      "logic-aiagent-workflow-orchestrator" = {
        name = "logic-aiagent-workflow-orchestrator"
        env_vars = {
          "AzureWebJobsStorage" = "DefaultEndpointsProtocol=https;AccountName=staiappsnonproduaen001;EndpointSuffix=core.windows.net"
          "WEBSITE_CONTENTAZUREFILECONNECTIONSTRING" = "DefaultEndpointsProtocol=https;AccountName=staiappsnonproduaen001;EndpointSuffix=core.windows.net"
        }
      }
    }
  }
}