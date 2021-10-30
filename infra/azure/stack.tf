resource "random_uuid" "stem" {
}

resource "azurerm_resource_group" "serilogisms" {
  name     = "rg-serilogisms-${random_uuid.stem.result}"
  location = "Australia East"
  tags     = {}
}

resource "azurerm_app_service_plan" "serilogisms" {
  name                = "asp-serilogisms-${random_uuid.stem.result}"
  location            = "Australia East"
  resource_group_name = azurerm_resource_group.serilogisms.name
  kind                = "Linux"
  reserved            = true

  tags = {}

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "serilogisms" {
  name                = "as-serilogisms-${random_uuid.stem.result}"
  location            = "Australia East"
  resource_group_name = azurerm_resource_group.serilogisms.name
  app_service_plan_id = azurerm_app_service_plan.serilogisms.id

  site_config {
    dotnet_framework_version = "v5.0"
  }

  app_settings = {
    "ASPNETCORE_ENVIRONMENT" = "Development",
    "SERILOG_PROFILE_NAME" = "Development"
    "SERILOGSETTING_SERILOG__MINIMUMLEVEL__DEFAULT" = "Verbose"
    "SERILOGSETTING_SERILOG__MINIMUMLEVEL__OVERRIDE__MICROSOFT": "Verbose",
    "SERILOGSETTING_SERILOG__MINIMUMLEVEL__OVERRIDE__SYSTEM": "Verbose"
    "SERILOGSETTING_SERILOG__WRITETO__0__ARGS__WORKSPACEID": azurerm_log_analytics_workspace.serilogisms.workspace_id,
    "SERILOGSETTING_SERILOG__WRITETO__0__ARGS__AUTHENTICATIONID": azurerm_log_analytics_workspace.serilogisms.primary_shared_key
  }
}

#
# Log Analytics
#
resource "azurerm_log_analytics_workspace" "serilogisms" {
  name                = "log-serilogisms-${random_uuid.stem.result}"
  location            = azurerm_resource_group.serilogisms.location
  resource_group_name = azurerm_resource_group.serilogisms.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

#
# Diagnostic Settings
#
resource "azurerm_storage_account" "serilogisms" {
  name                     = "stserilogismslogs"
  location                 = "Australia East"
  resource_group_name      = azurerm_resource_group.serilogisms.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_monitor_diagnostic_setting" "serilogisms" {
  name               = "diag-serilogisms-${random_uuid.stem.result}"
  target_resource_id = azurerm_app_service.serilogisms.id
  storage_account_id = azurerm_storage_account.serilogisms.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.serilogisms.id

  log {
    category = "AppServiceConsoleLogs"
    enabled  = true

    retention_policy {
      enabled = true
      days = 7
    }
  }
  log {
    category = "AppServiceHTTPLogs"
    enabled  = true

    retention_policy {
      enabled = true
      days = 7
    }
  }  
  log {
    category = "AppServicePlatformLogs"
    enabled  = true

    retention_policy {
      enabled = true
      days = 7
    }
  }    
}

/*
// To show the logging categories and how they relate to the UI:
data "azurerm_monitor_diagnostic_categories" "example" {
  resource_id = azurerm_app_service.serilogisms.id
}

output "theoutput" {
  value = data.azurerm_monitor_diagnostic_categories.example
}

// It will show something like this:
//       + "AppServiceAppLogs",
//          + "AppServiceAuditLogs",
//          + "AppServiceConsoleLogs",
//          + "AppServiceHTTPLogs",
//          + "AppServiceIPSecAuditLogs",
//          + "AppServicePlatformLogs",
*/
