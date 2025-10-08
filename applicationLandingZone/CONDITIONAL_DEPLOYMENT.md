# Conditional Module Deployment Guide

## Overview
The Terraform configuration now supports conditional deployment of modules using enable/disable variables. Each module can be individually controlled using numeric variables where:
- `1` = Deploy the module
- `0` = Skip the module deployment

## Enable/Disable Variables

The following variables control module deployment:

```hcl
# Module Enable/Disable Variables (1 = deploy, 0 = skip)
variable "enable_key_vaults" {
  description = "Enable Key Vault module deployment"
  type        = number
  default     = 1
}

variable "enable_function_apps" {
  description = "Enable Function Apps module deployment"
  type        = number
  default     = 1
}

variable "enable_container_registries" {
  description = "Enable Container Registry module deployment"
  type        = number
  default     = 1
}

variable "enable_container_app_environments" {
  description = "Enable Container App Environment module deployment"
  type        = number
  default     = 1
}

variable "enable_container_apps" {
  description = "Enable Container Apps module deployment"
  type        = number
  default     = 1
}

variable "enable_ai_search" {
  description = "Enable AI Search module deployment"
  type        = number
  default     = 1
}

variable "enable_cosmos_db" {
  description = "Enable Cosmos DB module deployment"
  type        = number
  default     = 1
}

variable "enable_logic_apps" {
  description = "Enable Logic Apps module deployment"
  type        = number
  default     = 1
}
```

## How It Works

Each module uses a conditional `for_each` expression:

```hcl
module "key_vaults" {
  source = "../kv"

  for_each = var.enable_key_vaults > 0 ? var.key_vaults : {}

  # ... module configuration
}
```

### Logic Explanation:
- `var.enable_key_vaults > 0` - Checks if the enable variable is greater than 0
- `? var.key_vaults : {}` - If true, use the key_vaults configuration; if false, use an empty map
- Empty map `{}` means no instances will be created (module is skipped)

## Usage Examples

### Example 1: Deploy Only Key Vaults and Function Apps
```hcl
# In your .tfvars file
enable_key_vaults = 1
enable_function_apps = 1
enable_container_registries = 0
enable_container_app_environments = 0
enable_container_apps = 0
enable_ai_search = 0
enable_cosmos_db = 0
enable_logic_apps = 0
```

### Example 2: Deploy Everything (Default)
```hcl
# All variables default to 1, so no need to specify unless changing
enable_key_vaults = 1
enable_function_apps = 1
enable_container_registries = 1
enable_container_app_environments = 1
enable_container_apps = 1
enable_ai_search = 1
enable_cosmos_db = 1
enable_logic_apps = 1
```

### Example 3: Skip All Modules (Testing Configuration)
```hcl
enable_key_vaults = 0
enable_function_apps = 0
enable_container_registries = 0
enable_container_app_environments = 0
enable_container_apps = 0
enable_ai_search = 0
enable_cosmos_db = 0
enable_logic_apps = 0
```

## Role Assignments

Role assignments between modules are automatically handled and will only be created when both related modules are enabled:

```hcl
# This role assignment only creates when both Key Vaults and Function Apps are enabled
resource "azurerm_role_assignment" "function_app_kv_secrets_user" {
  for_each = {
    for combo in flatten([
      for kv_key, kv_config in (var.enable_key_vaults > 0 && var.enable_function_apps > 0) ? var.key_vaults : {} : [
        # ... role assignment logic
      ]
    ]) : "${combo.kv_key}-${combo.fa_key}" => combo
  }
  # ... role assignment configuration
}
```

## Benefits

1. **Flexible Deployment**: Deploy only the resources you need for specific environments
2. **Cost Optimization**: Skip expensive resources in development/testing environments
3. **Gradual Rollout**: Enable modules incrementally during deployment phases
4. **Environment-Specific**: Different configurations for dev, staging, and production
5. **Dependency Management**: Role assignments automatically handle module dependencies

## Terraform Commands

```bash
# Plan with conditional deployment
terraform plan -var-file="nonprod.tfvars"

# Apply with conditional deployment
terraform apply -var-file="nonprod.tfvars"

# Override specific modules via command line
terraform plan -var="enable_cosmos_db=0" -var="enable_logic_apps=0"
```

## Notes

- All enable variables default to `1` (deploy) for backward compatibility
- When a module is disabled (set to `0`), its configuration variables are still required in the .tfvars file but will be ignored
- Role assignments automatically respect module enable/disable settings
- Use `terraform plan` to verify which resources will be created before applying