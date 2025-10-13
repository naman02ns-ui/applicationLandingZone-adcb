locals {
  environment = lower(var.environment)
  tags = {
    Environment         = var.environment
    ApplicationName     = var.application_name
    DataClassification  = "Business"
    BusinessCriticality = "High"
    BusinessUnit        = "ArtificialIntelligence"
    CostCenter          = "428"
    RequestReference    = "PO28344"
    DeployedBy          = "Terraform"
  }

  location = lower(var.location)
  location_shortcode_map = {
    "uaenorth"   = "uan"
    "uaecentral" = "uac"
  }
  location_shortcode = lookup(local.location_shortcode_map, var.location, substr(local.location, 0, 4))

}

locals {
  privatelink_subnet = {
    name           = module.base-infra.subnet_map[var.selected_subnet].name
    vnet_name      = module.base-infra.vnet_name
    resource_group = module.resource_group.rg_name
  }
}

