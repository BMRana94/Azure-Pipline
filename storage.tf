# Azure Blob Storage
resource "azurerm_storage_account" "main" {
  name                     = "${var.prefix}storage"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  tags                     = var.tags
  
  blob_properties {
    versioning_enabled = true
  }
}

# Container for ML models and images
resource "azurerm_storage_container" "ml_models" {
  name                  = "ml-models"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

# Container for media files
resource "azurerm_storage_container" "media_files" {
  name                  = "media-files"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

# Storage account network rules to restrict access
resource "azurerm_storage_account_network_rules" "main" {
  storage_account_id = azurerm_storage_account.main.id
  default_action     = "Deny"
  virtual_network_subnet_ids = [
    azurerm_subnet.container_apps.id
  ]
  bypass = ["AzureServices"]
}