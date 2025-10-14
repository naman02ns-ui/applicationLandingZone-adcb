# Cosmos DB Module

This Terraform module creates and manages an Azure Cosmos DB account with comprehensive configuration options including databases, containers, private endpoints, and advanced settings.

## Features

- ✅ **Comprehensive Configuration**: Full support for Cosmos DB account settings
- ✅ **Multiple APIs**: Support for SQL API, MongoDB, etc.
- ✅ **Private Endpoints**: Secure connectivity through private endpoints
- ✅ **Databases & Containers**: Automated creation of SQL databases and containers
- ✅ **Backup & CORS**: Advanced backup and CORS configuration
- ✅ **Geo-Replication**: Multi-region setup with automatic failover
- ✅ **Serverless Support**: Built-in serverless capability
- ✅ **Enterprise Security**: Identity, VNet rules, and access controls

## Usage

```hcl
module "cosmos_db" {
  source = "../cosmosDB"

  # Basic Configuration
  application_name     = "myapp"
  environment         = "dev"
  resource_group_name = "rg-myapp-dev"
  location           = "uaenorth"
  cosmosdb_account_name = "cosmos-myapp"

  # Advanced Configuration
  public_network_access_enabled = false
  enable_automatic_failover     = true

  # Private Endpoint
  enable_private_endpoint = true
  privatelink_subnet = {
    name                = "snet-privatelink"
    vnet_name          = "vnet-myapp"
    resource_group     = "rg-myapp-dev"
  }

  # Databases
  sql_databases = [
    {
      name = "myapp-db"
      autoscale_settings = {
        max_throughput = 4000
      }
    }
  ]

  # Containers
  sql_containers = [
    {
      name               = "users"
      database_name      = "myapp-db"
      partition_key_path = "/userId"
      autoscale_settings = {
        max_throughput = 1000
      }
    }
  ]

  tags = {
    Project = "MyApplication"
    Owner   = "DevOps Team"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 1.6.3 |
| azurerm | >= 3.70, < 5.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 3.70, < 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| res-id | ../utility/random-identifier | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_cosmosdb_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_account) | resource |
| [azurerm_private_endpoint.cosmosdb_pe](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_cosmosdb_sql_database.database](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_sql_database) | resource |
| [azurerm_cosmosdb_sql_container.container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_sql_container) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| application_name | Name of the application | `string` | n/a | yes |
| resource_group_name | Resource group name for Cosmos DB | `string` | n/a | yes |
| location | Azure region for Cosmos DB | `string` | n/a | yes |
| cosmosdb_account_name | Name of the Cosmos DB account | `string` | n/a | yes |
| environment | Environment Variable used as a prefix | `string` | `"dev"` | no |
| kind | The kind of CosmosDB to create | `string` | `"GlobalDocumentDB"` | no |
| offer_type | The offer type for Cosmos DB | `string` | `"Standard"` | no |
| capabilities | List of capabilities to enable | `list(string)` | `["EnableServerless"]` | no |
| enable_private_endpoint | Enable private endpoint for Cosmos DB | `bool` | `false` | no |
| sql_databases | List of SQL databases to create | `list(object)` | `[]` | no |
| sql_containers | List of SQL containers to create | `list(object)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| cosmosdb_account_id | The ID of the Cosmos DB account |
| cosmosdb_account_name | The name of the Cosmos DB account |
| cosmosdb_account_endpoint | The endpoint of the Cosmos DB account |
| cosmosdb_account_primary_key | The primary key of the Cosmos DB account |
| cosmosdb_databases | The list of created databases |
| cosmosdb_containers | The list of created containers |
| private_endpoint_id | The ID of the private endpoint |

## Examples

### Basic Cosmos DB with Serverless

```hcl
module "cosmos_basic" {
  source = "../cosmosDB"

  application_name      = "myapp"
  environment          = "dev"
  resource_group_name  = "rg-myapp-dev"
  location            = "uaenorth"
  cosmosdb_account_name = "cosmos-myapp-basic"
}
```

### Enterprise Cosmos DB with Private Endpoint

```hcl
module "cosmos_enterprise" {
  source = "../cosmosDB"

  application_name     = "enterprise-app"
  environment         = "prod"
  resource_group_name = "rg-enterprise-prod"
  location           = "uaenorth"
  cosmosdb_account_name = "cosmos-enterprise"

  # Security & Networking
  public_network_access_enabled = false
  enable_private_endpoint       = true
  enable_virtual_network_filter = true

  privatelink_subnet = {
    name           = "snet-privatelink"
    vnet_name      = "vnet-enterprise"
    resource_group = "rg-enterprise-prod"
  }

  # High Availability
  enable_automatic_failover = true
  geo_location = [
    {
      location          = "uaenorth"
      failover_priority = 0
      zone_redundant    = true
    },
    {
      location          = "uaecentral"
      failover_priority = 1
      zone_redundant    = false
    }
  ]

  # Backup
  backup = {
    type               = "Periodic"
    interval_in_minutes = 240
    retention_in_hours  = 720
    storage_redundancy  = "Geo"
  }
}
```

## License

This module is licensed under the MIT License.