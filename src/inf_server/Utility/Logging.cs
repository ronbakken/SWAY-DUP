using Microsoft.ServiceFabric.Services.Runtime;
using Microsoft.WindowsAzure.Storage;
using Serilog;
using Serilog.Core;
using Serilog.Events;

namespace Utility
{
    public static class Logging
    {
        public static ILogger GetLogger<T>(T context = default, string azureTableStorageConnectionString = default)
        {
            var loggerConfiguration = new LoggerConfiguration();

            if (string.IsNullOrEmpty(azureTableStorageConnectionString))
            {
                loggerConfiguration = loggerConfiguration
                    .WriteTo.Debug()
                    .MinimumLevel.Debug();
            }
            else
            {
                var storage = CloudStorageAccount.Parse(azureTableStorageConnectionString);

                // TODO: we may want to enable batch writes in the future (e.g. every minute)
                loggerConfiguration = loggerConfiguration.WriteTo.AzureTableStorage(
                    storage,
                    storageTableName: "Logs");
            }

            loggerConfiguration = loggerConfiguration
                .Enrich.WithProcessId()
                .Enrich.WithProcessName()
                .Enrich.WithThreadId()
                .Enrich.WithMemoryUsage();

            if (context is StatelessService statelessService)
            {
                loggerConfiguration = loggerConfiguration
                    .Enrich.With(new StatelessServiceEnricher(statelessService));
            }

            var logger = loggerConfiguration
                .Enrich.With()
                .CreateLogger()
                .ForContext<T>();

            return logger;
        }

        private sealed class StatelessServiceEnricher : ILogEventEnricher
        {
            public const string InstanceIdPropertyName = "StatelessServiceInstanceId";
            public const string ListenAddressPropertyName = "StatelessServiceListenAddress";
            public const string PartitionIdPropertyName = "StatelessServicePartitionId";
            public const string PublishAddressPropertyName = "StatelessServicePublishAddress";
            public const string ReplicaOrInstanceIdPropertyName = "StatelessServiceReplicaOrInstanceId";
            public const string ServiceNamePropertyName = "StatelessServiceServiceName";
            public const string ServiceTypeNamePropertyName = "StatelessServiceServiceTypeName";
            public const string TraceIdPropertyName = "StatelessServiceTraceId";
            public const string NodeIPAddressOrFQDNPropertyName = "StatelessServiceNodeIPAddressOrFQDN";
            public const string NodeIdPropertyName = "StatelessServiceNodeId";
            public const string NodeInstanceIdPropertyName = "StatelessServiceNodeInstanceId";
            public const string NodeNamePropertyName = "StatelessServiceNodeName";
            public const string NodeTypePropertyName = "StatelessServiceNodeType";
            public const string CodePackageNamePropertyName = "StatelessServiceCodePackageName";
            public const string CodePackageVersionPropertyName = "StatelessServiceCodePackageVersion";
            public const string CodePackageContextIdPropertyName = "StatelessServiceCodePackageContextId";

            private readonly StatelessService statelessService;

            public StatelessServiceEnricher(StatelessService statelessService)
            {
                this.statelessService = statelessService;
            }

            public void Enrich(LogEvent logEvent, ILogEventPropertyFactory propertyFactory)
            {
                var context = this.statelessService.Context;
                var codePackageActivationContext = context.CodePackageActivationContext;
                var nodeContext = context.NodeContext;

                logEvent.AddPropertyIfAbsent(new LogEventProperty(InstanceIdPropertyName, new ScalarValue(context.InstanceId)));
                logEvent.AddPropertyIfAbsent(new LogEventProperty(ListenAddressPropertyName, new ScalarValue(context.ListenAddress)));
                logEvent.AddPropertyIfAbsent(new LogEventProperty(PartitionIdPropertyName, new ScalarValue(context.PartitionId)));
                logEvent.AddPropertyIfAbsent(new LogEventProperty(PublishAddressPropertyName, new ScalarValue(context.PublishAddress)));
                logEvent.AddPropertyIfAbsent(new LogEventProperty(ReplicaOrInstanceIdPropertyName, new ScalarValue(context.ReplicaOrInstanceId)));
                logEvent.AddPropertyIfAbsent(new LogEventProperty(ServiceNamePropertyName, new ScalarValue(context.ServiceName)));
                logEvent.AddPropertyIfAbsent(new LogEventProperty(ServiceTypeNamePropertyName, new ScalarValue(context.ServiceTypeName)));
                logEvent.AddPropertyIfAbsent(new LogEventProperty(TraceIdPropertyName, new ScalarValue(context.TraceId)));
                logEvent.AddPropertyIfAbsent(new LogEventProperty(NodeIPAddressOrFQDNPropertyName, new ScalarValue(nodeContext.IPAddressOrFQDN)));
                logEvent.AddPropertyIfAbsent(new LogEventProperty(NodeIdPropertyName, new ScalarValue(nodeContext.NodeId)));
                logEvent.AddPropertyIfAbsent(new LogEventProperty(NodeInstanceIdPropertyName, new ScalarValue(nodeContext.NodeInstanceId)));
                logEvent.AddPropertyIfAbsent(new LogEventProperty(NodeNamePropertyName, new ScalarValue(nodeContext.NodeName)));
                logEvent.AddPropertyIfAbsent(new LogEventProperty(NodeTypePropertyName, new ScalarValue(nodeContext.NodeType)));
                logEvent.AddPropertyIfAbsent(new LogEventProperty(CodePackageNamePropertyName, new ScalarValue(codePackageActivationContext.CodePackageName)));
                logEvent.AddPropertyIfAbsent(new LogEventProperty(CodePackageVersionPropertyName, new ScalarValue(codePackageActivationContext.CodePackageVersion)));
                logEvent.AddPropertyIfAbsent(new LogEventProperty(CodePackageContextIdPropertyName, new ScalarValue(codePackageActivationContext.ContextId)));
            }
        }
    }
}
