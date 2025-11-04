# Function App Module

A robust, enterprise-ready Terraform module for deploying Azure Function Apps with comprehensive features including:

- **Multiple Function Apps**: Deploy multiple function apps from a single module call
- **User-Assigned Managed Identity**: Optional UAI with configurable naming
- **Private Endpoints**: Support for storage account and function app private endpoints
- **Application Insights**: Optional integration with conditional configuration
- **Flexible Service Plans**: Support for existing or new service plans
- **Advanced Networking**: VNet integration and private link support
- **Storage Integration**: Dedicated storage account with optional customer-managed keys
- **Comprehensive Configuration**: Full site_config support with dynamic blocks

## 🚀 Features

### Core Capabilities
- ✅ **Multi-Function App Support**: Deploy multiple function apps with different configurations
- ✅ **Flexible UAI Management**: Optional user-assigned identity with custom naming
- ✅ **Enterprise Security**: Private endpoints, CMK encryption, RBAC ready
- ✅ **Production Ready**: Comprehensive error handling and conditional logic
- ✅ **Scalable Architecture**: Designed for large-scale enterprise deployments

### Enhanced Outputs
- Function app IDs, names, and principal IDs
- User-assigned identity details (ID, principal ID, client ID)
- Storage account information
- Proper null handling for optional resources

## 📁 Module Structure

```
modules/app-service/app-function/
├── function-app.tf    # Main function app resources
├── variables.tf       # All input variables
├── locals.tf          # Local computations and logic
├── data.tf           # Data source definitions
├── uai.tf            # User-assigned identity resource
├── output.tf         # Module outputs
├── versions.tf       # Terraform version constraints
└── README.md         # This file
```

## 🔧 Key Improvements Over Original

### 1. **Fixed UAI References**
- Proper conditional references to UAI resources
- Configurable UAI naming via `uai_name_override`
- Null-safe identity configuration

### 2. **Enhanced Application Insights**
- Conditional references that won't break when disabled
- Proper handling of optional Application Insights module

### 3. **Robust Private Endpoints**
- Conditional creation based on subnet availability
- Improved naming patterns for multiple function apps

### 4. **Better Error Handling**
- Null checks for optional resources
- Conditional resource creation prevents Terraform errors

## 📋 Usage Examples

### Basic Usage
```hcl
module "function_apps" {
  source = "./modules/app-service/app-function"

  resource_location    = "uaenorth"
  resource_group_name  = "my-rg"
  application_name     = "myapp"
  environment          = "prod"
  
  function_apps = {
    "api" = {
      name            = "api-gateway"
      env_vars        = { "API_VERSION" = "v1" }
      file_share_name = "api-share"
    }
    "worker" = {
      name            = "background-worker"
      env_vars        = { "WORKER_THREADS" = "4" }
      file_share_name = "worker-share"
    }
  }

  # Networking
  app_function_subnet = {
    name           = "func-subnet"
    vnet_name      = "my-vnet"
    resource_group = "network-rg"
  }

  # Private endpoints
  privatelink_subnet = {
    name           = "pe-subnet"
    vnet_name      = "my-vnet"
    resource_group = "network-rg"
  }

  privatelink_funcapp_subnet = {
    name           = "pe-func-subnet"
    vnet_name      = "my-vnet"
    resource_group = "network-rg"
  }

  # DNS zones
  private_dns_zone_id          = "/subscriptions/.../privateDnsZones/privatelink.blob.core.windows.net"
  func_app_private_dns_zone_id = "/subscriptions/.../privateDnsZones/privatelink.azurewebsites.net"

  # Storage configuration
  storage_use = "func"
  
  tags = {
    Environment = "Production"
    Project     = "MyProject"
  }
}
```

### Advanced Configuration with Custom UAI
```hcl
module "function_apps" {
  source = "./modules/app-service/app-function"

  # ... basic configuration ...

  # Custom UAI naming
  uai_name_override = "uai-myapp-prod-func-custom"
  
  # Existing service plan
  existing_service_plan = {
    name                = "existing-service-plan"
    resource_group_name = "shared-rg"
  }

  # Application Insights
  application_insights_enabled              = true
  application_insights_connection_string    = "InstrumentationKey=..."
  application_insights_key                  = "your-key"
  log_analytics_worksapce_id                = "/subscriptions/.../workspaces/my-law"

  # Customer managed keys
  customer_managed_key_enabled = true
  kv_name                      = "my-keyvault"
  kv_resource_group_name       = "security-rg"
  cmk_name                     = "storage-cmk"

  # Advanced site configuration
  site_config = {
    always_on         = true
    health_check_path = "/api/health"
    application_stack = {
      python_version = "3.11"
    }
    cors = {
      allowed_origins = ["https://myapp.com"]
    }
  }
}
```

## 📤 Outputs

| Output | Description | Type |
|--------|-------------|------|
| `id` | Function app IDs | `list(string)` |
| `function_app_names` | Function app names by key | `map(string)` |
| `function_app_principal_ids` | System-assigned identity principal IDs | `map(string)` |
| `user_assigned_identity_id` | User-assigned identity ID | `string` |
| `user_assigned_identity_principal_id` | User-assigned identity principal ID | `string` |
| `user_assigned_identity_client_id` | User-assigned identity client ID | `string` |
| `storage_account_name` | Backend storage account name | `string` |

## 🔄 Migration from adcb-iac

This module is based on the `adcb-iac/app-service/app-function` module with the following key improvements:

### Changes Made:
1. **Fixed UAI naming inconsistencies**
2. **Added proper null checks for optional resources**
3. **Enhanced conditional logic for Application Insights**
4. **Improved private endpoint handling**
5. **Added comprehensive outputs**
6. **Made UAI references conditional and safe**

### Migration Steps:
1. Update module source path:
   ```hcl
   # From:
   source = "../adcb-iac/app-service/app-function"
   
   # To:
   source = "./modules/app-service/app-function"
   ```

2. Add UAI naming override if needed:
   ```hcl
   uai_name_override = "uai-${var.application_name}-${var.environment}-func-${each.key}"
   ```

3. Update RBAC assignments to use module outputs:
   ```hcl
   principal_id = module.function_apps.user_assigned_identity_principal_id
   ```

## ⚠️ Important Notes

1. **Dependencies**: This module references other modules (`../../utility/random-identifier`, `../../storage`, etc.). Ensure these are available or update the source paths.

2. **Private Endpoints**: Require proper DNS zone configuration for name resolution.

3. **UAI Permissions**: Remember to assign appropriate RBAC roles to the user-assigned identity.

4. **Storage Account**: Always created with private network access disabled by default.

## 🔐 Security Considerations

- Storage accounts are created with `public_network_access_enabled = false`
- Function apps support both system-assigned and user-assigned identities
- Private endpoints can be configured for both storage and function apps
- Customer-managed key encryption supported for storage accounts
- Key Vault references supported via user-assigned identity

## 📖 Related Documentation

- [Azure Functions Documentation](https://docs.microsoft.com/en-us/azure/azure-functions/)
- [Private Endpoints](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-overview)
- [Managed Identities](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/)