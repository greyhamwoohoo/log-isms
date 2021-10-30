# serilog-isms
Serilog implemented in Linux .Net 5 MVC App Service with various sinks. After running this, you will be able see the logs in storage and view them in Log Analytics:

![Console Logs in Storage](docs/log-analytics.png)

## Getting started
To create the resources using Terraform, add your SubscriptionID to variables.tf and then:

```
terraform apply
```

Deploy the AppService using Visual Studio: right click the MvcApp, 'Publish' and choose your AppService. 

## MyLinuxMvcAppService
An AppService that is hosted on Linux that shows using various Serilog providers.

### SERILOG_PROFILE_NAME
The 'logging profile' to use for Serilog is specified with the SERILOG_PROFILE_NAME variable: by default, no Serilog settings are loaded. 'Local' and 'Development' are provided as an examples as 'serilogSettings.Local.json' and 'serilogSettings.Development.json'. See 'launchSettings.json' for examples. 

### F5 Experience
To output to the Debug window in Visual Studio via Serilog, you must configure the Trace provider. This is specified in the 'Local' profile. 

### Customize or override single Serilog settings
The default .Net Environment Variable Provider is used to support overriding individual values - such as MinimumalLevel. See 'launchSettings.json' for examples suchas SERILOGSETTINGS_SERILOG__MINIMUMLEVEL=Debug

## Logs captured 
After publishing the logs, the following logs are available:

### Console, Http and Platform logs are captured
Terraform is configured to add the Diagnostics Settings to write ConsoleLogs, HttpLogs and PlatformLogs to a storage account:

After starting the AppService, look in the storage account to find the console logs:

![Console Logs in Storage](docs/logs-storage.png)

### Log Analytics Workspace
The 'Development' profile will publish logs to Azure Analytics in a custom log. 

It takes some time (in my case: around 1 hour) for my custom log called 'MvcApp_CL' to turn up in the Log Analytics workspace. But assuming it DOES exist, you can view and query the logs as follows:

![Console Logs in Storage](docs/log-analytics.png)

# References
| Link | Description | 
| ---- | ----------- | 
| https://codewithmukesh.com/blog/serilog-in-aspnet-core-3-1/ | Setting up Serilog with 3.1 |
| https://docs.microsoft.com/en-us/aspnet/core/fundamentals/configuration/?view=aspnetcore-5.0 |Environment variable / configuration providers | 
| https://github.com/saleem-mirza/serilog-sinks-azure-analytics | The Log Analytics Sink / Provider |
