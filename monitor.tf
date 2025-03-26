# Azure Monitor
resource "azurerm_application_insights" "main" {
  name                = "${var.prefix}-appinsights"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.main.id
  tags                = var.tags
}

# Log Analytics Workspace is defined in container_apps.tf since it's also used there

# Azure Monitor Action Group (for alerts)
resource "azurerm_monitor_action_group" "main" {
  name                = "${var.prefix}-actiongroup"
  resource_group_name = azurerm_resource_group.main.name
  short_name          = "mlplatform"

  email_receiver {
    name                    = "admin"
    email_address           = var.alert_email
    use_common_alert_schema = true
  }
}

# Example alert for high CPU in the Container Apps Environment
resource "azurerm_monitor_metric_alert" "container_app_cpu" {
  name                = "${var.prefix}-container-app-cpu-alert"
  resource_group_name = azurerm_resource_group.main.name
  scopes              = [azurerm_container_app_environment.main.id]
  description         = "Alert when CPU usage exceeds 80%"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"

  criteria {
    metric_namespace = "Microsoft.App/containerApps"
    metric_name      = "CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
}