## AI Apps NonProd##

environment = "dev"
application_name = "aiapps"
ainonprod_sub_id = "eed58c8e-f08c-4839-9bfe-469f4705d062"  #- This is sub ID for AI-Apps non-prod

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
    resource_group_name     = "rg-aiapps-nonprod-uaenorth-001"
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
    resource_group_name     = "rg-aiapps-nonprod-uaenorth-001"
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
    resource_group_name            = "rg-aiapps-nonprod-uaenorth-001"
    application_name               = "aiapps"
    environment                    = "dev"
    zone_redundancy_enabled        = false
    key_expiration_date           = null
    sku                           = "Standard"
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
    public_network_access_enabled = true
    data_endpoint_enabled         = false
    encryption_enabled            = false
    private_dns_zone_id           = null
  }
}

#--------------Container App Environment--------------------#

container_app_environments = {
  "aiapps-nonprod-cae" = {
    management_sub_id           = "eed58c8e-f08c-4839-9bfe-469f4705d062"
    resource_location          = "uaenorth"
    resource_group_name        = "rg-aiapps-nonprod-uaenorth-001"
    application_name           = "aiapps"
    environment               = "dev"
    subnet = {
      name           = "snet-ai-apps-uaenorth-001"
      vnet_name      = "vnet-aiapps-nonprod-uaenorth-001"
      resource_group = "rg-aiapps-nonprod-uaenorth-001"
    }
    workload_profile = [{
      name                  = "Consumption"
      workload_profile_type = "Consumption"
    }]
    log_analytics_workspace_id = "/subscriptions/eed58c8e-f08c-4839-9bfe-469f4705d062/resourceGroups/rg-aiapps-nonprod-uaenorth-001/providers/Microsoft.OperationalInsights/workspaces/log-aiapps-nonprod-uaenorth-001"
  }
}

# --------------Container Apps--------------------#
# Container Apps require pre-built container images in the registry
# Commenting out until images are available

container_apps = {
  "aiapps-api-service" = {
    resource_location             = "uaenorth"
    resource_group_name          = "rg-aiapps-nonprod-uaenorth-001"
    application_name             = "aiapps"
    environment                  = "nonprod"
    container_app_environment_name = "aiapps-nonprod-cae"
    ingress = {
      external_enabled = true
      target_port     = 8080
    }
    containers = [{
      name   = "api-service"
      cpu    = "0.5"
      memory = "1Gi"
      image  = "aiapps-nonprod-acr.azurecr.io/api-service:latest"
    }]
    revision_mode = "Single"
    identity = {
      identity_ids = ["/subscriptions/eed58c8e-f08c-4839-9bfe-469f4705d062/resourceGroups/rg-aiapps-nonprod-uaenorth-001/providers/Microsoft.ManagedIdentity/userAssignedIdentities/id-aiapps-api-nonprod-001"]
    }
    tags = {
      Environment = "nonprod"
      Service     = "API"
    }
  }

  "aiapps-processing-service" = {
    resource_location             = "uaenorth"
    resource_group_name          = "rg-aiapps-nonprod-uaenorth-001"
    application_name             = "aiapps"
    environment                  = "nonprod"
    container_app_environment_name = "aiapps-nonprod-cae"
    ingress = {
      external_enabled = false
      target_port     = 8080
    }
    containers = [{
      name   = "processing-service"
      cpu    = "1.0"
      memory = "2Gi"
      image  = "aiapps-nonprod-acr.azurecr.io/processing-service:latest"
    }]
    revision_mode = "Single"
    identity = {
      identity_ids = ["/subscriptions/eed58c8e-f08c-4839-9bfe-469f4705d062/resourceGroups/rg-aiapps-nonprod-uaenorth-001/providers/Microsoft.ManagedIdentity/userAssignedIdentities/id-aiapps-processing-nonprod-001"]
    }
    tags = {
      Environment = "nonprod"
      Service     = "Processing"
    }
  }

  "aiapps-notification-service" = {
    resource_location             = "uaenorth"
    resource_group_name          = "rg-aiapps-nonprod-uaenorth-001"
    application_name             = "aiapps"
    environment                  = "nonprod"
    container_app_environment_name = "aiapps-nonprod-cae"
    ingress = {
      external_enabled = false
      target_port     = 8080
    }
    containers = [{
      name   = "notification-service"
      cpu    = "0.25"
      memory = "0.5Gi"
      image  = "aiapps-nonprod-acr.azurecr.io/notification-service:latest"
    }]
    revision_mode = "Single"
    identity = {
      identity_ids = ["/subscriptions/eed58c8e-f08c-4839-9bfe-469f4705d062/resourceGroups/rg-aiapps-nonprod-uaenorth-001/providers/Microsoft.ManagedIdentity/userAssignedIdentities/id-aiapps-notification-nonprod-001"]
    }
    tags = {
      Environment = "nonprod"
      Service     = "Notification"
    }
  }
}

# container_apps = {}

#--------------Function Apps--------------------#

function_apps = {
  "aiapps-data-processor" = {
    resource_location                          = "uaenorth"
    resource_group_name                       = "rg-aiapps-nonprod-uaenorth-001"
    application_name                          = "aiapps"
    environment                               = "nonprod"
    app_service_plan_name                     = "aiapps-function-asp"
    existing_service_plan                     = null
    function_apps = {
      "func-data-processor" = {
        function_app_version = "~4"
        python_version      = "3.12"
        use_32_bit_worker   = false
      }
    }
    app_function_subnet = {
      name           = "snet-fn-app-outbound-uaenorth-001"
      vnet_name      = "vnet-aiapps-nonprod-uaenorth-001"
      resource_group = "rg-aiapps-nonprod-uaenorth-001"
    }
    privatelink_subnet = {
      name           = "snet-private-endpoint-uaenorth-001"
      vnet_name      = "vnet-aiapps-nonprod-uaenorth-001"
      resource_group = "rg-aiapps-nonprod-uaenorth-001"
    }
    privatelink_funcapp_subnet = {
      name           = "snet-private-endpoint-uaenorth-001"
      vnet_name      = "vnet-aiapps-nonprod-uaenorth-001"
      resource_group = "rg-aiapps-nonprod-uaenorth-001"
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
    customer_managed_key_enabled              = false
    kv_name                                   = null
    kv_resource_group_name                    = null
    cmk_name                                  = null
    storage_use                               = "AzureFiles"
    sku_name                                  = "Standard_LRS"
    create_fileshare                          = true
    file_shares                               = []
  }

  "aiapps-ml-inference" = {
    resource_location                          = "uaenorth"
    resource_group_name                       = "rg-aiapps-nonprod-uaenorth-001"
    application_name                          = "aiapps"
    environment                               = "nonprod"
    app_service_plan_name                     = "aiapps-function-asp"
    existing_service_plan                     = null
    function_apps = {
      "func-ml-inference" = {
        function_app_version = "~4"
        python_version      = "3.11"
        use_32_bit_worker   = false
      }
    }
    app_function_subnet = {
      name           = "snet-fn-app-outbound-uaenorth-001"
      vnet_name      = "vnet-aiapps-nonprod-uaenorth-001"
      resource_group = "rg-aiapps-nonprod-uaenorth-001"
    }
    privatelink_subnet = {
      name           = "snet-private-endpoint-uaenorth-001"
      vnet_name      = "vnet-aiapps-nonprod-uaenorth-001"
      resource_group = "rg-aiapps-nonprod-uaenorth-001"
    }
    privatelink_funcapp_subnet = {
      name           = "snet-private-endpoint-uaenorth-001"
      vnet_name      = "vnet-aiapps-nonprod-uaenorth-001"
      resource_group = "rg-aiapps-nonprod-uaenorth-001"
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
    customer_managed_key_enabled              = false
    kv_name                                   = null
    kv_resource_group_name                    = null
    cmk_name                                  = null
    storage_use                               = "AzureFiles"
    sku_name                                  = "Standard_LRS"
    create_fileshare                          = true
    file_shares                               = []
  }

  "aiapps-integration-handler" = {
    resource_location                          = "uaenorth"
    resource_group_name                       = "rg-aiapps-nonprod-uaenorth-001"
    application_name                          = "aiapps"
    environment                               = "nonprod"
    app_service_plan_name                     = "aiapps-function-asp"
    existing_service_plan                     = null
    function_apps = {
      "func-integration-handler" = {
        function_app_version = "~4"
        python_version      = "3.11"
        use_32_bit_worker   = false
      }
    }
    app_function_subnet = {
      name           = "snet-fn-app-outbound-uaenorth-001"
      vnet_name      = "vnet-aiapps-nonprod-uaenorth-001"
      resource_group = "rg-aiapps-nonprod-uaenorth-001"
    }
    privatelink_subnet = {
      name           = "snet-private-endpoint-uaenorth-001"
      vnet_name      = "vnet-aiapps-nonprod-uaenorth-001"
      resource_group = "rg-aiapps-nonprod-uaenorth-001"
    }
    privatelink_funcapp_subnet = {
      name           = "snet-private-endpoint-uaenorth-001"
      vnet_name      = "vnet-aiapps-nonprod-uaenorth-001"
      resource_group = "rg-aiapps-nonprod-uaenorth-001"
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
    customer_managed_key_enabled              = false
    kv_name                                   = null
    kv_resource_group_name                    = null
    cmk_name                                  = null
    storage_use                               = "AzureFiles"
    sku_name                                  = "Standard_LRS"
    create_fileshare                          = true
    file_shares                               = []
  }
}

#--------------Logic Apps--------------------#

logic_apps = {
  "aiapps-workflow-orchestrator" = {
    resource_location                    = "uaenorth"
    resource_group_name                 = "rg-aiapps-nonprod-uaenorth-001"
    application_name                    = "aiapps"
    environment                         = "nonprod"
    storage_account_name               = "staiappsnonproduaen001"
    app_service_plan_name              = "aiapps-logic-asp"
    service_plan_name                   = "asp-aiapps-workflow-nonprod-001"
    user_assigned_identity_ids          = ["/subscriptions/eed58c8e-f08c-4839-9bfe-469f4705d062/resourceGroups/rg-aiapps-nonprod-uaenorth-001/providers/Microsoft.ManagedIdentity/userAssignedIdentities/id-aiapps-workflow-nonprod-001"]
    privatelink_subnet = {
      name           = "snet-private-endpoint-uaenorth-001"
      vnet_name      = "vnet-aiapps-nonprod-uaenorth-001"
      resource_group = "rg-aiapps-nonprod-uaenorth-001"
    }
    private_dns_zone_id                = "/subscriptions/connectivity-sub-id/resourceGroups/rg-connectivity-dns-uaenorth-01/providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net"
    sku_name                           = "Standard_LRS"
    file_shares                        = []
    customer_managed_key_enabled       = false
    kv_name                            = null
    kv_resource_group_name             = null
    cmk_name                           = null
    storage_use                        = "AzureFiles"
    definistion_file_path              = null
    file_share_private_dns_zone_id     = "/subscriptions/connectivity-sub-id/resourceGroups/rg-connectivity-dns-uaenorth-01/providers/Microsoft.Network/privateDnsZones/privatelink.file.core.windows.net"
    create_fileshare                   = true
    existing_service_plan              = null
    uai_required                       = true
    logic_apps = {
      "logic-workflow-orchestrator" = {
        app_settings = {
          # Logic Apps use workflow definitions (JSON), not runtime environments
          # They can call Python Functions but don't run Python code directly
          "AzureWebJobsStorage" = "DefaultEndpointsProtocol=https;AccountName=staiappsnonproduaen001;EndpointSuffix=core.windows.net"
          "WEBSITE_CONTENTAZUREFILECONNECTIONSTRING" = "DefaultEndpointsProtocol=https;AccountName=staiappsnonproduaen001;EndpointSuffix=core.windows.net"
        }
      }
    }
  }
}

#--------------Key Vault Access--------------------#
# Key Vault is created in the same deployment via kv.tf
# RBAC assignments reference module.azure_key_vault directly
# No additional configuration needed here
