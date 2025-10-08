# Application Landing Zone - Refactored Architecture

## Overview
The Application Landing Zone has been refactored to meet customer requirements:

1. **Modular Structure**: Split main.tf into separate files for better organization
2. **Existing Resources**: Use customer-provided Azure resources instead of creating new ones
3. **Simplified Configuration**: Only deploy application services, reference existing infrastructure

## File Structure

```
applicationLandingZone/
├── main.tf                   # Core terraform configuration and provider setup
├── data-sources.tf          # Data sources for existing Azure resources
├── function-apps.tf         # Function Apps module and RBAC assignments
├── logic-apps.tf           # Logic Apps module
├── container-apps.tf       # Container Apps and Container App Environment modules
├── container-registry.tf   # Container Registry module
├── variables.tf            # All variable definitions
├── outputs.tf              # All output definitions
└── tfvars/
    └── nonprod.tfvars      # Configuration using existing resources
```

## Customer-Provided Resources

The following resources are provided by the customer and referenced via data sources:

### 🔐 **Key Vault**
- **Name**: `kv-aiapps-dev-uan-01avto`
- **Resource Group**: `rg-dev-uan-aiapps`
- **Usage**: Function Apps will get RBAC access for secrets

### 💾 **Storage Account**
- **Name**: `funcsaaiappsdevuan68ydmy`
- **Resource Group**: `rg-dev-uan-aiapps`
- **Usage**: Function Apps storage backend

### 🔍 **AI Search Service**
- **Name**: `srch-aiapps-dev-uan-39e1hk`
- **Resource Group**: `rg-dev-uan-aiapps`
- **Usage**: AI search capabilities for applications

### 📊 **Log Analytics Workspace**
- **Name**: `law-aiapps-dev-uaenorth`
- **Resource Group**: `rg-dev-uan-aiapps`
- **Usage**: Monitoring and diagnostics

### 🌐 **Cosmos DB Account**
- **Name**: `cosmos-aiapps-dev-uan-km-uan-6fr731`
- **Resource Group**: `rg-dev-uan-aiapps`
- **Usage**: Document and knowledge store

## New Resources Deployed

The Terraform will only deploy these application services:

### ⚡ **Function Apps**
- Python-based API functions
- Private networking with VNet integration
- Managed identity with Key Vault access

### 📦 **Container Registry**
- Private container registry for Docker images
- Private endpoint connectivity

### 🏗️ **Container Apps**
- Scalable containerized applications
- Container App Environment for orchestration

### 🔄 **Logic Apps**
- Workflow orchestration services
- Document processing workflows

## Configuration Changes

### 1. **Enable/Disable Flags Updated**
```hcl
# Customer provided resources - use existing
enable_existing_key_vaults              = 1
enable_existing_storage_accounts        = 1
enable_existing_ai_search_services      = 1
enable_existing_log_analytics_workspaces = 1
enable_existing_cosmos_db               = 1

# Only deploy application services
enable_key_vaults                   = 0  # Customer provided
enable_ai_search_services          = 0  # Customer provided
enable_cosmos_db                   = 0  # Customer provided
enable_function_apps               = 1  # Deploy new
enable_container_registries        = 1  # Deploy new
enable_container_app_environments  = 1  # Deploy new
enable_container_apps              = 1  # Deploy new
enable_logic_apps                  = 1  # Deploy new
```

### 2. **Existing Resources Configuration**
```hcl
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

# ... other existing resources
```

### 3. **Legacy Configurations Commented Out**
- `key_vaults = { ... }` ➜ Commented out
- `ai_search_services = { ... }` ➜ Commented out
- `cosmos_db_services = { ... }` ➜ Commented out

## Benefits

✅ **Modular Architecture**: Each service in its own file for better maintainability
✅ **Cost Optimization**: Reuse existing infrastructure instead of duplicating
✅ **Security**: Maintain existing security configurations and policies
✅ **Consistency**: Use established naming conventions and resource groups
✅ **Simplified Deployment**: Only deploy what's needed

## Next Steps

1. **Review Configuration**: Verify all existing resource names and resource groups are correct
2. **Test Plan**: Run `terraform plan` to validate the configuration
3. **Deploy**: Run `terraform apply` to deploy only the new application services
4. **Validate**: Confirm applications can access existing resources via data sources

## RBAC Assignments

The Terraform automatically creates these role assignments:

- **Function App UAI** ➜ **Key Vault Secrets User** (read secrets from existing Key Vault)
- **Function App UAI** ➜ **AcrPull** (pull container images from new Container Registry)

This ensures applications can securely access both existing and new resources as needed.