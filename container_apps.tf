# Azure Container Apps Environment
resource "azurerm_log_analytics_workspace" "main" {
  name                = "${var.prefix}-logs"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

resource "azurerm_container_app_environment" "main" {
  name                       = "${var.prefix}-environment"
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  infrastructure_subnet_id   = azurerm_subnet.container_apps.id
  tags                       = var.tags
}

# ML Pipeline Container App
resource "azurerm_container_app" "ml_pipeline" {
  name                         = "ml-pipeline"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"
  tags                         = var.tags

  template {
    container {
      name   = "ml-pipeline"
      image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
      cpu    = 2.0
      memory = "4Gi"
      
      env {
        name  = "NVIDIA_VISIBLE_DEVICES"
        value = "all"
      }
      
      env {
        name  = "NVIDIA_DRIVER_CAPABILITIES"
        value = "compute,utility"
      }
    }
    
    min_replicas = 1
    max_replicas = 5
  }
}

# Middleware API Container App
resource "azurerm_container_app" "middleware_api" {
  name                         = "middleware-api"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"
  tags                         = var.tags

  template {
    container {
      name   = "middleware-api"
      image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
      cpu    = 1.0
      memory = "2Gi"
    }
    
    min_replicas = 1
    max_replicas = 10
  }
  
  ingress {
    external_enabled = true
    target_port      = 80
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}

# Media Server Container App
resource "azurerm_container_app" "media_server" {
  name                         = "media-server"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"
  tags                         = var.tags

  template {
    container {
      name   = "media-server"
      image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
      cpu    = 1.0
      memory = "2Gi"
      
      env {
        name  = "ACI_BASE_ENABLED"
        value = "true"
      }
    }
    
    min_replicas = 1
    max_replicas = 5
  }
}