# log-isms
An experiment with Terraform, Serilog/.Net 5, Azure Monitoring, Log Analytics, AppInsights, AppServices and Diagnostics. 

## Implementations
There are two implementations:

| Implementation | Folder |
| -------------- | ------ |
| AppService     | An experiment with Terraform, Serilog/.Net 5, Azure Monitoring, Log Analytics, AppInsights, AppServices and Diagnostics. |
| Functions      | An experiment with Terraform, Azure Monitoring, Log Analytics, AppInsights and Functions. |

# Getting started
To create the resources using Terraform, add your SubscriptionID to variables.tf and then:

```
cd infra
terraform init
terraform apply
```

## MyLinuxMvcAppService
A Linux AppService that shows using various Serilog providers and publishing custom events to AppInsights. 

Deploy the AppService using Visual Studio: right click the MvcApp, 'Publish' and create a new publish profile. 

### SERILOG_PROFILE_NAME
The 'logging profile' to use for Serilog is specified with the SERILOG_PROFILE_NAME variable: by default, no Serilog settings are loaded. 'Local' and 'Development' are provided as an examples as 'serilogSettings.Local.json' and 'serilogSettings.Development.json'. See 'launchSettings.json' for examples. 

### F5 Experience
To output to the Debug window in Visual Studio via Serilog, you must configure the Trace provider. This is specified in the 'Local' profile. 

### Customize or override single Serilog settings
The default .Net Environment Variable Provider is used to support overriding individual values - such as MinimumalLevel. See 'launchSettings.json' for examples suchas SERILOGSETTINGS_SERILOG__MINIMUMLEVEL=Debug

## Logs captured 
After publishing the AppService to Azure, the following logs are available:

### Console, Http and Platform logs are captured
Terraform is configured to add the Diagnostics Settings to write ConsoleLogs, HttpLogs and PlatformLogs to a storage account:

After starting the AppService, look in the storage account to find the console logs:

![Console Logs in Storage](docs/logs-storage.png)

### Log Analytics Workspace
The 'Development' profile will publish logs to Azure Analytics in a custom log. 

It takes some time (in my case: around 1 hour) for my custom log called 'MvcApp_CL' to turn up in the Log Analytics workspace. But assuming it DOES exist, you can view and query the logs as follows:

![Console Logs in Storage](docs/log-analytics.png)

## AppInsights
A minimalistic AppInsights implementation. 

Smoke test: Once deployed to Azure, navigate between Home and Privacy in the App while looking at the Live Metrics view (Incoming Requests) in Application Insights:

![Console Logs in Storage](docs/app-insights-smoke.png)

### Custom Events
Two endpoints have been created that publish a 'Spoken' event with a word of 'Hello' or 'Howdi'. Navigate to these endpoints in your browser to publish an event:

```
https://as-serilogisms-....azurewebsites.net/howdi
https://as-serilogisms-....azurewebsites.net/hello
```

The number of custom events published will (eventually) turn up in AppInsights (this took around 10-20 minutes initially):

![Console Logs in Storage](docs/app-insights-spoken.png)
