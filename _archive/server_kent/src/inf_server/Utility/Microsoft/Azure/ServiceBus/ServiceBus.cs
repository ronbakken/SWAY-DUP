using System;
using Genesis.Ensure;
using Microsoft.Azure.ServiceBus;
using Serilog;

namespace Utility.Microsoft.Azure.ServiceBus
{
    public static class ServiceBus
    {
        private const string configurationPackageObjectName = "Config";
        private const string serviceBusSectionName = "ServiceBus";
        private const string connectionStringParameterName = "ConnectionString";

        public static TopicClient GetServiceBusTopicClient(ILogger logger, string entityPath)
        {
            Ensure.ArgumentNotNull(logger, nameof(logger));
            Ensure.ArgumentNotNull(entityPath, nameof(entityPath));

            var serviceBusConnectionString = Environment.GetEnvironmentVariable("SERVICE_BUS_CONNECTION_STRING");

            if (string.IsNullOrEmpty(serviceBusConnectionString))
            {
                logger.Warning("Service bus connection string not configured.");
                return null;
            }

            return new TopicClient(
                serviceBusConnectionString,
                entityPath);
        }

        public static SubscriptionClient GetServiceBusSubscriptionClient(ILogger logger, string topicPath, string subscriptionName, ReceiveMode receiveMode)
        {
            Ensure.ArgumentNotNull(logger, nameof(logger));
            Ensure.ArgumentNotNull(topicPath, nameof(topicPath));
            Ensure.ArgumentNotNull(subscriptionName, nameof(subscriptionName));

            var serviceBusConnectionString = Environment.GetEnvironmentVariable("SERVICE_BUS_CONNECTION_STRING");

            if (string.IsNullOrEmpty(serviceBusConnectionString))
            {
                logger.Warning("Service bus connection string not configured.");
                return null;
            }

            return new SubscriptionClient(
                serviceBusConnectionString,
                topicPath,
                subscriptionName,
                receiveMode: receiveMode);
        }
    }
}
