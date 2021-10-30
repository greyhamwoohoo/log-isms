using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Serilog;
using System.IO;

namespace MvcApp
{
    public class Program
    {
        public static void Main(string[] args)
        {
            InitializeLogger();

            Log.Information($"For Information: Serilog has been initialized. Alle-yoo-lee-ah!");
            Log.Debug($"For Debug: Serilog has been initialized. Alle-yoo-lee-ah!");
            Log.Verbose($"For Verbose: Serilog has been initialized. Alle-yoo-lee-ah!");

            CreateHostBuilder(args).Build().Run();
        }

        public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .UseSerilog()
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.UseStartup<Startup>();
                });

        /// <summary>
        /// We initialize this real early so if anything goes wrong during DI set up, we can log why. 
        /// </summary>
        private static void InitializeLogger()
        {
            var configurationBuilder = new ConfigurationBuilder()
                .SetBasePath(Directory.GetCurrentDirectory());

            // The traditional way of loading and 'layering' settings files (general; then environment specific) does not work too well with complex structures like Serilog. 
            // Therefore: If a serilogSettings file exists for an environment, it is exclusively loaded. No layering is done from a base configuration. 
            var candidateEnvironmentSettingsPath = $"serilogSettings.{System.Environment.GetEnvironmentVariable("SERILOG_PROFILE_NAME")}.json";
            if(System.IO.File.Exists(candidateEnvironmentSettingsPath))
            {
                configurationBuilder.AddJsonFile(candidateEnvironmentSettingsPath, optional: false);
            } 
            else
            {
                configurationBuilder.AddJsonFile("serilogSettings.json", optional: false);
            };
    
            var configuration = configurationBuilder
                .AddEnvironmentVariables("SERILOGSETTING_")
                .Build();

            var loggerConfiguration = new LoggerConfiguration()
                .ReadFrom
                .Configuration(configuration);

            Log.Logger = loggerConfiguration
                .CreateLogger();
        }
    }
}
