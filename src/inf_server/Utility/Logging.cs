using System;
using System.Fabric;
using Microsoft.Azure.Cosmos;
using Microsoft.ServiceFabric.Services.Runtime;
using Serilog;
using Serilog.Core;
using Serilog.Events;
using Utility.Mapping;

namespace Utility
{
    public static class Logging
    {
        private const string configurationPackageObjectName = "Config";
        private const string sectionName = "Logging";
        private const string seqServerUrlStringName = "SeqServerUrl";
        private const string seqApiKeyStringName = "SeqApiKey";

        public static ILogger GetLogger<T>(T context = default)
        {
            var loggerConfiguration = new LoggerConfiguration();
            var seqConfiguration = GetSeqConfiguration();

            loggerConfiguration = loggerConfiguration
                .WriteTo.Seq(seqConfiguration.seqServerUrl, apiKey: seqConfiguration.seqApiKey)
#if DEBUG
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

            if (context is StatelessService statelessService)
            {
                loggerConfiguration = loggerConfiguration
                    .Enrich.With(new StatelessServiceEnricher(statelessService));
            }

            var logger = loggerConfiguration
                .CreateLogger()
                .ForContext<T>();

            return logger;
        }

        private static (string seqServerUrl, string seqApiKey) GetSeqConfiguration()
        {
            var configurationPackage = FabricRuntime.GetActivationContext().GetConfigurationPackageObject(configurationPackageObjectName);

            if (configurationPackage == null)
            {
                throw new InvalidOperationException($"No '{configurationPackageObjectName}' configuration configuration package object.");
            }

            if (!configurationPackage.Settings.Sections.Contains(sectionName))
            {
                throw new InvalidOperationException($"No '{sectionName}' configuration section could be found in the '{configurationPackageObjectName}' configuration package.");
            }

            var section = configurationPackage.Settings.Sections[sectionName];

            if (!section.Parameters.Contains(seqServerUrlStringName))
            {
                throw new InvalidOperationException($"No '{seqServerUrlStringName}' parameter found in the '{sectionName}' configuration section.");
            }

            if (!section.Parameters.Contains(seqApiKeyStringName))
            {
                throw new InvalidOperationException($"No '{seqApiKeyStringName}' parameter found in the '{sectionName}' configuration section.");
            }

            var result = (section.Parameters[seqServerUrlStringName].Value, section.Parameters[seqApiKeyStringName].Value);

            return result;
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