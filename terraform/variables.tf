variable "connectivity_sub_id" {
  type    = string
  default = "6fa47cb8-1205-49a2-aa48-e35dfec6d698"
}

variable "ainonprod_sub_id" {
  type    = string
}
variable "management_sub_id" {
  type    = string
  default = "11e455c3-8b37-46b5-b2e9-b528dd408e11"
}

variable "location" {
  type        = string
  description = "location of resource group"
  default     = "uaenorth"
}

variable "environment" {
  type        = string
  description = "Environment where resource to be deployed"
   }

variable "application_name" {
  type        = string
  description = "Name of application project shortcode"
 }

variable "vnet_address_spaces" {
  description = "The address space to be used for the Azure virtual network."
  type        = list(string)
}

variable "connectivity_vnet" {
  description = "Connectivity VNET details"
  type = object({
    vnet_name      = string
    resource_group = string
  })
  default = ({
    vnet_name      = "vnet-connectivity-hub-uaenorth-01"
    resource_group = "rg-connectivity-hub-uaenorth-01"
  })
}
variable "connectivity_dns_zone_rg" {
  description = "Resource group name where the private DNS zone is located"
  type        = string
  default     = "rg-connectivity-dns-uaenorth-01"
}

variable "subnets" {
  description = "For each subnet, create an object that contain fields"
  default = {
  }
  type = map(object({
    subnet_name                                   = string
    subnet_address_prefix                         = list(string)
    service_endpoints                             = optional(list(string))
    service_endpoint_policy_ids                   = optional(list(string))
    private_endpoint_network_policies_enabled     = optional(bool)
    private_endpoint_network_policies             = optional(string)
    nsg_inbound_rules                             = optional(list(list(string)), [])
    nsg_outbound_rules                            = optional(list(list(string)), [])
    route_table_rules                             = optional(list(list(string)), [])

    delegation = optional(object({
      name = string
      service_delegation = object({
        name    = string
        actions = optional(list(string), [])
      })
    }))
  }))
}
variable "privatelink_sql_dns_zone" {
  default = "privatelink.database.windows.net"
  }

############################## AI-Search vars ####################

variable "replica_count" {
  type        = number
  default     = 3 # 3 or more replicas for high availability of read-write workloads (queries and indexing)
  description = "Instances of the search service, used primarily to load balance query operations. Each replica always hosts one copy of an index"
}

variable "aisrch_dns_zone" {
  default = "privatelink.search.windows.net"
}

############################## Cosmos vars ####################

variable "databases" {
  description = "MongoDB Databases"
  type = map(object({
    description    = optional(string)
    throughput     = optional(number)
    max_throughput = optional(number)
    collections = list(object({
      name           = string
      shard_key      = string
      throughput     = optional(number)
      max_throughput = optional(number)
    }))
  }))
}

variable "selected_subnet" {
  type        = string
  description = "Specify the subnet to use"
}

variable "entity_name" {
  type        = string
  description = "Logical name of the entity (e.g., aiapps, aiservices, aihub)"
}

variable "cosmos_dns_zone" {
  default = "privatelink.mongo.cosmos.azure.com"
}

############################## KV vars ####################

variable "kv_dns_zone" {
  description = "Name of the KV DNS Zone"
  type        = string
  default     = "privatelink.vaultcore.azure.net"
}

############################## Storage vars ####################

variable "containername" {
  description = "Name of the container name"
  type        = string
}

variable "sa_dns_zone" {
  default = "privatelink.blob.core.windows.net"
}

############################## App Service Plan vars ####################

variable "app_service_plans" {
  description = "Map of App Service Plans to create for Function Apps and Logic Apps"
  type = map(object({
    resource_location        = optional(string, "uaenorth")
    resource_group_name     = string
    application_name        = string
    environment             = string
    service_plan_sku        = optional(string, "EP1")
    max_elastic_worker_count = optional(number, 20)
    worker_count            = optional(number)
    os_type                 = optional(string, "Linux")
    diagnostic_settings     = optional(map(object({
      name                                     = optional(string)
      metric_categories                        = optional(set(string), ["AllMetrics"])
      log_analytics_destination_type           = optional(string, "Dedicated")
      workspace_resource_id                    = optional(string)
      storage_account_resource_id              = optional(string)
      event_hub_authorization_rule_resource_id = optional(string)
      event_hub_name                           = optional(string)
      marketplace_partner_resource_id          = optional(string)
    })), {})
  }))
  default = {}
}

############################## Function Apps vars ####################

variable "function_apps" {
  description = "Map of function apps to create with comprehensive configuration"
  type = map(object({
    resource_location                          = optional(string, "uaenorth")
    resource_group_name                       = string
    application_name                          = string
    environment                               = string
    app_service_plan_name                     = string
    existing_service_plan                     = optional(string)
    function_apps                             = map(object({
      name            = string
      env_vars        = map(string)
      file_share_name = string
    }))
    app_function_subnet = object({
      name           = string
      vnet_name      = string
      resource_group = string
    })
    privatelink_subnet = object({
      name           = string
      vnet_name      = string
      resource_group = string
    })
    privatelink_funcapp_subnet = object({
      name           = string
      vnet_name      = string
      resource_group = string
    })
    private_dns_zone_id                       = string
    func_app_private_dns_zone_id              = string
    file_share_private_dns_zone_id            = string
    public_network_access_enabled             = optional(bool, false)
    vnet_route_all_enabled                    = optional(bool, true)
    application_insights_enabled              = optional(bool, true)
    application_insights_connection_string    = optional(string)
    application_insights_key                  = optional(string)
    log_analytics_worksapce_id                = optional(string)
    daily_memory_time_quota                   = optional(number, 0)
    customer_managed_key_enabled              = optional(bool, false)
    kv_name                                   = optional(string)
    kv_resource_group_name                    = optional(string)
    cmk_name                                  = optional(string)
    storage_use                               = optional(string, "AzureFiles")
    sku_name                                  = optional(string, "Standard_LRS")
    create_fileshare                          = optional(bool, true)
    enable_versioning                         = optional(bool, false)
    file_shares                               = optional(list(object({ name = string, quota = number })), [])
    uai_required                              = optional(bool, true)
  }))
  default = {}
}

############################## Logic Apps vars ####################

variable "logic_apps" {
  description = "Map of logic apps to create with comprehensive configuration"
  type = map(object({
    resource_location                    = optional(string, "uaenorth")
    resource_group_name                 = string
    application_name                    = string
    environment                         = string
    storage_account_name               = string
    app_service_plan_name              = string
    service_plan_name                   = string
    user_assigned_identity_ids          = optional(list(string), [])
    privatelink_subnet = object({
      name           = string
      vnet_name      = string
      resource_group = string
    })
    private_dns_zone_id                = string
    sku_name                           = optional(string, "Standard_LRS")
    file_shares                        = optional(list(object({ name = string, quota = number })), [])
    customer_managed_key_enabled       = optional(bool, false)
    kv_name                            = optional(string)
    kv_resource_group_name             = optional(string)
    cmk_name                           = optional(string)
    storage_use                        = optional(string, "AzureFiles")
    definistion_file_path              = optional(string)
    file_share_private_dns_zone_id     = string
    create_fileshare                   = optional(bool, true)
    existing_service_plan              = optional(object({
      name                = string
      resource_group_name = string
    }))
    uai_required                       = optional(bool, true)
    logic_apps = map(object({
      name     = string
      env_vars = map(string)
    }))
  }))
  default = {}
}

############################## Map Variables for Resources ####################

variable "container_app_environments" {
  description = "Map of container app environments to create"
  type = map(object({
    management_sub_id           = optional(string)
    resource_location          = optional(string, "uaenorth")
    resource_group_name        = string
    application_name           = string
    environment               = string
    subnet = object({
      name           = string
      vnet_name      = string
      resource_group = string
    })
    workload_profile = optional(object({
      name                  = string
      workload_profile_type = string
    }), {
      name                  = "Consumption"
      workload_profile_type = "Consumption"
    })
    log_analytics_workspace_id = optional(string)
    tags                      = optional(map(string), {})
  }))
  default = {}
}

variable "container_apps" {
  description = "Map of container apps to create"
  type = map(object({
    resource_location                 = optional(string, "uaenorth")
    resource_group_name              = string
    application_name                 = string
    environment                      = string
    container_app_environment_name   = string
    tags                            = optional(map(string), {})
    ingress = optional(object({
      external_enabled = optional(bool, false)
      target_port     = optional(number, 80)
    }))
    containers = optional(list(object({
      name   = string
      cpu    = optional(string, "0.25")
      memory = optional(string, "0.5Gi")
      image  = string
    })), [])
    revision_mode = optional(string, "Single")
    identity = optional(object({
      identity_ids = optional(list(string), [])
    }))
  }))
  default = {}
}

variable "container_registries" {
  description = "Map of container registries to create"
  type = map(object({
    resource_location               = optional(string, "uaenorth")
    resource_group_name            = string
    application_name               = string
    environment                    = string
    zone_redundancy_enabled        = optional(string, "false")
    key_expiration_date           = optional(string, "2027-12-31T23:59:59Z")
    sku                           = optional(string, "Premium")
    azurerm_key_vault_key         = optional(string)
    kv_name                       = optional(string)
    admin_enabled                 = optional(bool, false)
    georeplication_locations      = optional(list(string), [])
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
    }))
    private_dns_zone_id          = string
    tags                          = optional(map(string), {})
  }))
  default = {}
}

# Key Vault is created in the same deployment via kv.tf
# No existing_key_vaults variable needed - RBAC uses module.azure_key_vault directly
