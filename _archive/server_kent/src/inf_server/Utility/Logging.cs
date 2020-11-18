using System;
using Microsoft.Azure.Cosmos;
using Serilog;
using Utility.Mapping;

namespace Utility
{
    public static class Logging
    {
        private const string configurationPackageObjectName = "Config";
        private const string sectionName = "Logging";
        private const string environmentParameterName = "Environment";
        private const string resourceGroupParameterName = "ResourceGroup";
        private const string seqServerUrlParameterName = "SeqServerUrl";
        private const string seqApiKeyParameterName = "SeqApiKey";

        public static ILogger GetLogger<T>() =>
            GetLogger(typeof(T));

        public static ILogger GetLogger(Type type)
        {
            var loggerConfiguration = new LoggerConfiguration();
            var loggingConfiguration = GetLoggingConfiguration();

            loggerConfiguration = loggerConfiguration
                .WriteTo.Seq(loggingConfiguration.SeqServerUrl, apiKey: loggingConfiguration.SeqApiKey)
                .WriteTo.Console()
#if DEBUG
                .WriteTo.Debug()
                .MinimumLevel.Verbose()
#else
                .MinimumLevel.Debug()
#endif
                .Destructure.ByTransforming<CosmosResponseMessageHeaders>(
                    r =>
                    {
                        return new
                        {
                            r.ActivityId,
                            r.ContentLength,
                            r.ContentType,
                            r.Continuation,
                            r.ETag,
                            r.Location,
                            r.RequestCharge,
                        };
                    })
                .Enrich.WithProcessId()
                .Enrich.WithProcessName()
                .Enrich.WithThreadId()
                .Enrich.WithMemoryUsage()
                .Enrich.FromLogContext()
                .Destructure.ByTransforming<QuadKey>(quadKey => quadKey.ToString());

            var logger = loggerConfiguration
                .CreateLogger()
                .ForContext("Environment", loggingConfiguration.Environment)
                .ForContext("ResourceGroup", loggingConfiguration.ResourceGroup)
                .ForContext("ServiceName", loggingConfiguration.ServiceName)
                .ForContext(type);

            return logger;
        }

        private static LoggingConfiguration GetLoggingConfiguration()
        {
            var environment = Environment.GetEnvironmentVariable("ENVIRONMENT");
            var resourceGroup = Environment.GetEnvironmentVariable("RESOURCE_GROUP");
            var serviceName = Environment.GetEnvironmentVariable("SERVICE_NAME");
            var seqServerUrl = Environment.GetEnvironmentVariable("SEQ_SERVER_URL");
            var seqApiKey = Environment.GetEnvironmentVariable("SEQ_API_KEY");

            return new LoggingConfiguration(
                environment,
                resourceGroup,
                serviceName,
                seqServerUrl,
                seqApiKey);
        }

        private sealed class LoggingConfiguration
        {
            public LoggingConfiguration(
                string environment,
                string resourceGroup,
                string serviceName,
                string seqServerUrl,
                string seqApiKey)
            {
                this.Environment = environment;
                this.ResourceGroup = resourceGroup;
                this.ServiceName = serviceName;
                this.SeqServerUrl = seqServerUrl;
                this.SeqApiKey = seqApiKey;
            }

            public string Environment { get; }

            public string ResourceGroup { get; }

            public string ServiceName { get; }

            public string SeqServerUrl { get; }

            public string SeqApiKey { get; }
        }
    }
}