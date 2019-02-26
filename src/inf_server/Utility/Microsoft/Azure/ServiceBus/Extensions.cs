using System;
using System.Fabric;
using Genesis.Ensure;
using Serilog;

namespace Microsoft.Azure.ServiceBus
{
    public static class Extensions
    {
        private const string configurationPackageObjectName = "Config";
        private const string serviceBusSectionName = "ServiceBus";
        private const string connectionStringParameterName = "ConnectionString";

        public static TopicClient GetServiceBusTopicClient(this ICodePackageActivationContext @this, ILogger logger, string entityPath)
        {
            Ensure.ArgumentNotNull(@this, nameof(@this));
            Ensure.ArgumentNotNull(logger, nameof(logger));
            Ensure.ArgumentNotNull(entityPath, nameof(entityPath));

            var configurationPackage = @this.GetConfigurationPackageObject(configurationPackageObjectName);

            if (configurationPackage == null)
            {
                throw new InvalidOperationException($"No configuration package object named '{configurationPackageObjectName}' could be found.");
            }

            if (!configurationPackage.Settings.Sections.Contains(serviceBusSectionName))
            {
                throw new InvalidOperationException($"Section '{serviceBusSectionName}' was not found in the '{configurationPackageObjectName}' configuration package.");
            }

            var serviceBusSection = configurationPackage.Settings.Sections[serviceBusSectionName];

            if (!serviceBusSection.Parameters.Contains(connectionStringParameterName))
            {
                throw new InvalidOperationException($"Parameter '{connectionStringParameterName}' was not found in the '{serviceBusSectionName}' section.");
            }

            var serviceBusConnectionString = serviceBusSection.Parameters[connectionStringParameterName].Value;

            if (string.IsNullOrEmpty(serviceBusConnectionString))
            {
                logger.Warning("Service bus connection string not configured.");
                return null;
            }
            else
            {
                return new TopicClient(
                    serviceBusConnectionString,
                    entityPath);
            }
        }

        public static SubscriptionClient GetServiceBusSubscriptionClient(this ICodePackageActivationContext @this, ILogger logger, string topicPath, string subscriptionName, ReceiveMode receiveMode)
        {
            Ensure.ArgumentNotNull(@this, nameof(@this));
            Ensure.ArgumentNotNull(logger, nameof(logger));
            Ensure.ArgumentNotNull(topicPath, nameof(topicPath));
            Ensure.ArgumentNotNull(subscriptionName, nameof(subscriptionName));

            var configurationPackage = @this.GetConfigurationPackageObject(configurationPackageObjectName);

            if (configurationPackage == null)
            {
                throw new InvalidOperationException($"No configuration package object named '{configurationPackageObjectName}' could be found.");
            }

            if (!configurationPackage.Settings.Sections.Contains(serviceBusSectionName))
            {
                throw new InvalidOperationException($"Section '{serviceBusSectionName}' was not found in the '{configurationPackageObjectName}' configuration package.");
            }

            var serviceBusSection = configurationPackage.Settings.Sections[serviceBusSectionName];

            if (!serviceBusSection.Parameters.Contains(connectionStringParameterName))
            {
                throw new InvalidOperationException($"Parameter '{connectionStringParameterName}' was not found in the '{serviceBusSectionName}' section.");
            }

            var serviceBusConnectionString = serviceBusSection.Parameters[connectionStringParameterName].Value;

            if (string.IsNullOrEmpty(serviceBusConnectionString))
            {
                logger.Warning("Service bus connection string not configured.");
                return null;
            }
            else
            {
                return new SubscriptionClient(
                    serviceBusConnectionString,
                    topicPath,
                    subscriptionName,
                    receiveMode: receiveMode);
            }
        }
    }
}
