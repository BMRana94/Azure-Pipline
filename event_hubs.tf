# Azure Event Hubs
resource "azurerm_eventhub_namespace" "main" {
  name                = "${var.prefix}-eventhub-ns"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "Standard"
  capacity            = 1
  auto_inflate_enabled = true
  maximum_throughput_units = 5
  tags                = var.tags
}

resource "azurerm_eventhub" "main" {
  name                = "${var.prefix}-eventhub"
  namespace_name      = azurerm_eventhub_namespace.main.name
  resource_group_name = azurerm_resource_group.main.name
  partition_count     = 2
  message_retention   = 1
}

# Event Hub Authorization Rule (for accessing the Event Hub)
resource "azurerm_eventhub_namespace_authorization_rule" "main" {
  name                = "${var.prefix}-eventhub-auth-rule"
  namespace_name      = azurerm_eventhub_namespace.main.name
  resource_group_name = azurerm_resource_group.main.name
  listen              = true
  send                = true
  manage              = true
}