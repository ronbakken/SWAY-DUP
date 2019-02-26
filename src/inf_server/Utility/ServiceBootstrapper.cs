using System;
using System.Diagnostics;
using System.Fabric;
using System.Threading;
using System.Threading.Tasks;
using Genesis.Ensure;
using Microsoft.ServiceFabric.Services.Runtime;

namespace Utility
{
    /// <summary>
    /// Takes the busy work out of bootstrapping services. After creating a new service, replace the generated code in
    /// Program.cs with a call to <see cref="Bootstrap"/> instead.
    /// </summary>
    public static class ServiceBootstrapper
    {
        private const string configurationPackageObjectName = "Config";
        private const string loggingSectionName = "Logging";
        private const string storageConnectionStringName = "StorageConnectionString";

        // Bootstrap a stateless service using a standardized approach.
        public static async Task Bootstrap(string namePrefix, Func<StatelessServiceContext, StatelessService> createService)
        {
            Ensure.ArgumentNotNull(namePrefix, nameof(namePrefix));
            Ensure.ArgumentNotNull(createService, nameof(createService));

            var configurationPackage = FabricRuntime.GetActivationContext().GetConfigurationPackageObject(configurationPackageObjectName);

            if (configurationPackage == null)
            {
                throw new InvalidOperationException($"No '{configurationPackageObjectName}' configuration configuration package object.");
            }

            if (!configurationPackage.Settings.Sections.Contains(loggingSectionName))
            {
                throw new InvalidOperationException($"No '{loggingSectionName}' configuration section could be found in the '{configurationPackageObjectName}' configuration package.");
            }

            var logStorageSection = configurationPackage.Settings.Sections[loggingSectionName];

            if (!logStorageSection.Parameters.Contains(storageConnectionStringName))
            {
                throw new InvalidOperationException($"No '{storageConnectionStringName}' parameter found in the '{loggingSectionName}' configuration section.");
            }

            var logStorageConnectionString = logStorageSection.Parameters[storageConnectionStringName];

            var logger = Logging.GetLogger($"{namePrefix}-Program", logStorageConnectionString.Value);
            var serviceType = $"{namePrefix}Type";

            logger.Information("Starting service with type {ServiceType}", serviceType);

            try
            {
                await ServiceRuntime
                    .RegisterServiceAsync(serviceType, createService)
                    .ContinueOnAnyContext();

                var processId = Process.GetCurrentProcess().Id;
                logger.Information("Service type {ServiceType} was registered into process {ProcessId}", serviceType, processId);

                // Prevents this host process from terminating so services keep running.
                await Task
                    .Delay(Timeout.Infinite)
                    .ContinueOnAnyContext();
            }
            catch (Exception ex)
            {
                logger.Fatal(ex, "Service type {ServiceType} could not be registered", serviceType);
                Debugger.Break();
                throw;
            }
        }
    }
}
