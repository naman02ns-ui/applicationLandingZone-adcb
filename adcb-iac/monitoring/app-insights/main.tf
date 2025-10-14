resource "azurerm_application_insights" "this" {
  name                = "ai-${var.application_name}-${var.environment}"
  location            = var.resource_location
  resource_group_name = var.resource_group_name
  application_type    = var.application_type
  workspace_id        = var.workspace_id

  tags = var.tags
}