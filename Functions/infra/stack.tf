locals {
  diagnostics_to_enable  = ["FunctionAppLogs"]
  diagnostics_to_disable = []
}

resource "random_uuid" "stem" {
}

resource "azurerm_resource_group" "funclogisms" {
  name     = "rg-funclogisms-${random_uuid.stem.result}"
  location = "Australia East"
  tags = {
    stem = "${random_uuid.stem.result}"
  }
}

#
# Log Analytics
#
resource "azurerm_log_analytics_workspace" "funclogisms" {
  name                = "log-funclogisms-${random_uuid.stem.result}"
  location            = azurerm_resource_group.funclogisms.location
  resource_group_name = azurerm_resource_group.funclogisms.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = {
    stem = "${random_uuid.stem.result}"
  }
}

#
# Diagnostic Settings
#
resource "azurerm_storage_account" "funclogisms" {
  name                     = "stfunclogismslogs"
  location                 = "Australia East"
  resource_group_name      = azurerm_resource_group.funclogisms.name
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    stem = "${random_uuid.stem.result}"
  }
}

resource "azurerm_monitor_diagnostic_setting" "funclogisms" {
  name                       = "diag-funclogisms-${random_uuid.stem.result}"
  target_resource_id         = azurerm_function_app.funclogisms.id
  storage_account_id         = azurerm_storage_account.funclogisms.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.funclogisms.id

  dynamic "log" {
    for_each = local.diagnostics_to_enable
    content {
      category = log.value
      enabled  = true

      retention_policy {
        enabled = true
        days    = 7
      }
    }
  }

  dynamic "log" {
    for_each = local.diagnostics_to_disable
    content {
      category = log.value
      enabled  = false

      retention_policy {
        enabled = false
        days    = 0
      }
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }
}


# 
# Function App (Consumption)
# Reference: https://github.com/hashicorp/terraform-provider-azurerm/issues/4658
#
resource "azurerm_app_service_plan" "funclogisms" {
  name                = "asp-funclogisms-${random_uuid.stem.result}"
  location            = azurerm_resource_group.funclogisms.location
  resource_group_name = azurerm_resource_group.funclogisms.name
  kind                = "FunctionApp"
  reserved            = true

  sku {
    tier = "Dynamic"
    size = "Y1"
  }

  tags = {
    stem = "${random_uuid.stem.result}"
  }  
}

resource "azurerm_function_app" "funclogisms" {
  name                       = "func-csharp-speak"
  location                   = azurerm_resource_group.funclogisms.location
  resource_group_name        = azurerm_resource_group.funclogisms.name
  app_service_plan_id        = azurerm_app_service_plan.funclogisms.id
  storage_account_name       = azurerm_storage_account.funclogisms.name
  storage_account_access_key = azurerm_storage_account.funclogisms.primary_access_key
  os_type                    = "linux"
  version                    = "~3"  

  tags = {
    stem = "${random_uuid.stem.result}"
  }  
}

/*
resource "azurerm_application_insights" "funclogisms" {
  name                = "appi-funclogisms-${random_uuid.stem.result}"
  location            = "Australia East"
  resource_group_name = azurerm_resource_group.funclogisms.name
  workspace_id        = azurerm_log_analytics_workspace.funclogisms.id
  application_type    = "web"
}
*/