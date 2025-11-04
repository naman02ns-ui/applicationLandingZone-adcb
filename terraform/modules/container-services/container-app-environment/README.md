# Container App Environment Module

This module creates an Azure Container App Environment with a critical bug fix to prevent recreation issues.

## Bug Fix Applied

**Fixed Recreation Issue**: Added stable seed value to the random identifier module to prevent the container app environment from being recreated on every terraform run.

## Key Change

- **Original Issue**: Random identifier had `null` keepers causing instability
- **Fix Applied**: Provides stable seed value: `"${var.application_name}-${var.environment}-${var.resource_location}"`
- **Result**: Container app environment maintains stable naming across deployments

## Usage

```hcl
module "container_app_environment" {
  source = "./modules/container-services/container-app-environment"

  management_sub_id       = "your-subscription-id"
  resource_location       = "uaenorth"
  resource_group_name     = "rg-example"
  application_name        = "myapp"
  environment            = "dev"

  subnet = {
    name           = "subnet-container-apps"
    vnet_name      = "vnet-example"
    resource_group = "rg-network"
  }

  workload_profile = {
    name                  = "Consumption"
    workload_profile_type = "Consumption"
  }

  log_analytics_workspace_id = "/subscriptions/.../workspaces/log-analytics"

  tags = {
    Project = "ContainerApps"
    Owner   = "Platform Team"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| management_sub_id | Management subscription ID | `string` | n/a | yes |
| resource_location | location of ACE | `string` | `"uaenorth"` | no |
| resource_group_name | resource group name of key vault | `string` | n/a | yes |
| application_name | The application that requires this resource | `string` | n/a | yes |
| environment | Environment to provision resources | `string` | n/a | yes |
| subnet | Subnet for the container app environment | `object` | `null` | no |
| workload_profile | Workload Profile for container app environment | `object` | n/a | yes |
| log_analytics_workspace_id | Log Analytics workspace for container app environment | `string` | n/a | yes |
| tags | User defined extra tags to be added to all resources created in the module | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| container_app_env_id | The id of the container app environment |
| container_app_env_name | The name of the container app environment |

## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 1.6.3 |
| azurerm | >= 3.70, < 5.0 |

### 🔧 Bug Fixes
- **Fixed Recreation Issue**: Stable random identifier prevents environment from being recreated on each run
- **Stable Naming**: Consistent naming across deployments
- **Lifecycle Management**: Ignores minor changes that would force recreation

### 🚀 Enhanced Features
- **Multiple Workload Profiles**: Support for multiple workload profiles
- **Default Consumption Profile**: Automatically adds Consumption profile if none specified
- **Enhanced Location Mapping**: Support for more Azure regions
- **Name Override Option**: Ability to override auto-generated names
- **Better Validation**: Input validation for critical parameters
- **Enhanced Outputs**: Comprehensive outputs including static IP, default domain
- **Improved Tagging**: Better tagging strategy with metadata

## Usage

```hcl
module "container_app_environment" {
  source = "./modules/container-services/container-app-environment"

  management_sub_id       = "your-subscription-id"
  resource_location       = "uaenorth"
  resource_group_name     = "rg-example"
  application_name        = "myapp"
  environment            = "dev"

  subnet = {
    name           = "subnet-container-apps"
    vnet_name      = "vnet-example"
    resource_group = "rg-network"
  }

  workload_profiles = [
    {
      name                  = "Consumption"
      workload_profile_type = "Consumption"
    },
    {
      name                  = "GeneralPurpose"
      workload_profile_type = "D4"
      maximum_count         = 10
      minimum_count         = 3
    }
  ]

  log_analytics_workspace_id = "/subscriptions/.../workspaces/log-analytics"

  tags = {
    Project = "ContainerApps"
    Owner   = "Platform Team"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| management_sub_id | Management subscription ID | `string` | n/a | yes |
| resource_location | Azure region for the container app environment | `string` | `"uaenorth"` | no |
| resource_group_name | Resource group name for the container app environment | `string` | n/a | yes |
| application_name | The application that requires this resource | `string` | n/a | yes |
| environment | Environment to provision resources | `string` | n/a | yes |
| subnet | Subnet configuration for the container app environment | `object` | `null` | no |
| workload_profiles | List of workload profiles for container app environment | `list(object)` | `null` | no |
| log_analytics_workspace_id | Log Analytics workspace ID | `string` | `null` | no |
| internal_load_balancer_enabled | Enable internal load balancer | `bool` | `true` | no |
| tags | Tags to be applied to the resources | `map(string)` | `{}` | no |
| name_override | Override the default naming convention | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| container_app_env_id | The ID of the container app environment |
| container_app_env_name | The name of the container app environment |
| container_app_env_location | The location of the container app environment |
| container_app_env_resource_group_name | The resource group name of the container app environment |
| container_app_env_default_domain | The default domain of the container app environment |
| container_app_env_static_ip_address | The static IP address of the container app environment |
| workload_profiles | The workload profiles configured for the container app environment |

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5 |
| azurerm | >= 3.80.0 |
| random | >= 3.1 |

## Differences from Original Module

### Fixed Issues
1. **Random ID Stability**: Added stable seed value to prevent recreation
2. **Lifecycle Management**: Added lifecycle block to ignore certain changes
3. **Better Error Handling**: Added validation and better defaults

### Enhanced Features
1. **Multiple Workload Profiles**: Original only supported single profile
2. **Enhanced Location Support**: More Azure regions supported
3. **Name Override**: Ability to override auto-generated names
4. **Better Tagging**: Enhanced tagging with metadata
5. **Comprehensive Outputs**: More detailed outputs for integration

### Example Migration

**Original Call:**
```hcl
module "container_app_environments" {
  source = "../adcb-iac/container-services/container-app-environment"

  # ... other variables
  workload_profile = {
    name                  = "Consumption"
    workload_profile_type = "Consumption"
  }
}
```

**New Enhanced Call:**
```hcl
module "container_app_environments" {
  source = "./modules/container-services/container-app-environment"

  # ... other variables
  workload_profiles = [
    {
      name                  = "Consumption"
      workload_profile_type = "Consumption"
    }
  ]
}
```

## Notes

- The module automatically provides a stable seed value to the random identifier to prevent recreation
- If no workload profiles are specified, a default Consumption profile is automatically added
- The module supports both single and multiple workload profiles for flexibility
- Enhanced validation ensures proper input values and prevents common errors