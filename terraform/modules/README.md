# Modules Directory

This directory contains enterprise-ready Terraform modules that are improved versions of the modules from `adcb-iac/`. These modules have been enhanced for better robustness, error handling, and production readiness.

## 📁 Directory Structure

```
modules/
└── app-service/
    └── app-function/          # Enhanced Function App module
        ├── function-app.tf    # Main resources
        ├── variables.tf       # Input variables
        ├── locals.tf          # Local computations
        ├── data.tf           # Data sources
        ├── uai.tf            # User-assigned identity
        ├── output.tf         # Module outputs
        ├── versions.tf       # Version constraints
        └── README.md         # Documentation
```

## 🎯 Key Improvements

### 1. **Enhanced Function App Module**
- **Fixed UAI naming inconsistencies** between calling and base modules
- **Added comprehensive outputs** for better integration
- **Improved conditional logic** for optional resources
- **Better error handling** with null checks
- **Enhanced private endpoint handling** with proper conditions

### 2. **Production-Ready Features**
- Proper dependency management
- Comprehensive error handling
- Flexible configuration options
- Enterprise security patterns
- Detailed documentation

## 🔄 Migration Guide

### From adcb-iac to modules

1. **Update module source paths:**
   ```hcl
   # Old
   source = "../adcb-iac/app-service/app-function"
   
   # New
   source = "./modules/app-service/app-function"
   ```

2. **Add UAI naming override:**
   ```hcl
   module "function_apps" {
     source = "./modules/app-service/app-function"
     
     # Add this line for consistent naming
     uai_name_override = "uai-${var.application_name}-${var.environment}-func-${each.key}"
     
     # ... rest of configuration
   }
   ```

3. **Update RBAC assignments:**
   ```hcl
   # Old (using data source)
   principal_id = data.azurerm_user_assigned_identity.function_app_identity[each.key].principal_id
   
   # New (using module output)
   principal_id = module.function_apps[each.key].user_assigned_identity_principal_id
   ```

## 🚀 Benefits

### Reliability
- Proper null checks prevent runtime errors
- Conditional resource creation prevents Terraform failures
- Better dependency management

### Maintainability
- Clean, well-documented code
- Consistent naming patterns
- Modular design

### Security
- Enterprise security patterns
- Private endpoint support
- Managed identity best practices

### Scalability
- Support for multiple function apps
- Flexible configuration options
- Enterprise-ready architecture

## 📋 Usage Examples

### Basic Function App Deployment
```hcl
module "my_function_apps" {
  source = "./modules/app-service/app-function"

  resource_location   = "uaenorth"
  resource_group_name = "my-rg"
  application_name    = "myapp"
  environment         = "prod"
  
  function_apps = {
    "api" = {
      name            = "api-service"
      env_vars        = { "API_VERSION" = "v1" }
      file_share_name = "api-share"
    }
  }

  storage_use                = "func"
  private_dns_zone_id        = var.blob_dns_zone_id
  func_app_private_dns_zone_id = var.sites_dns_zone_id
  
  tags = local.tags
}
```

### RBAC Assignment Example
```hcl
resource "azurerm_role_assignment" "function_app_kv_access" {
  for_each = var.function_apps

  scope                = module.key_vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.my_function_apps.user_assigned_identity_principal_id
  description          = "Grant Function App access to Key Vault"

  depends_on = [module.my_function_apps]
}
```

## 🛠️ Dependencies

These modules may reference other modules that need to be available:

- `../../utility/random-identifier` - For generating unique identifiers
- `../../storage` - For storage account creation
- `../../monitoring/app-insights` - For Application Insights (optional)
- `../app-service-plan` - For service plan creation (if not using existing)

Make sure these modules are available or update the source paths accordingly.

## 📖 Module Documentation

Each module contains its own detailed README.md with:
- Feature overview
- Usage examples
- Input variables
- Outputs
- Migration guidance
- Security considerations

## 🔐 Security Best Practices

- Use private endpoints for network isolation
- Enable managed identities for secure authentication
- Implement least privilege access with RBAC
- Use customer-managed keys where appropriate
- Follow Azure security baselines

## 📊 Monitoring and Observability

- Application Insights integration
- Proper tagging strategy
- Health check endpoints
- Logging configuration
- Metrics collection

## 🎯 Future Enhancements

Planned improvements for future versions:
- Additional Azure service modules
- Enhanced networking options
- More comprehensive monitoring
- Advanced security features
- Performance optimizations