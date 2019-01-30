using System;
using System.Diagnostics;
using System.Fabric;
using System.Threading;
using Microsoft.ServiceFabric.Services.Runtime;
using Utility;

namespace API
{
    internal static class Program
    {
        /// <summary>
        /// This is the entry point of the service host process.
        /// </summary>
        private static void Main()
        {
            var configurationPackage = FabricRuntime.GetActivationContext().GetConfigurationPackageObject("Config");
            var logStorageConnectionString = configurationPackage.Settings.Sections["Logging"].Parameters["StorageConnectionString"].Value;
            var logger = Logging.GetLogger("API-Program", logStorageConnectionString);
            var serviceType = "APIType";

            try
            {
                // The ServiceManifest.XML file defines one or more service type names.
                // Registering a service maps a service type name to a .NET type.
                // When Service Fabric creates an instance of this service type,
                // an instance of the class is created in this host process.

                ServiceRuntime.RegisterServiceAsync(
                    serviceType,
                    context => new API(context)).GetAwaiter().GetResult();

                var processId = Process.GetCurrentProcess().Id;
                logger.Information("Service type {ServiceType} was registered into process {ProcessId}", serviceType, processId);

                // Prevents this host process from terminating so services keep running.
                Thread.Sleep(Timeout.Infinite);
            }
            catch (Exception ex)
            {
                logger.Fatal(ex, "Service type {ServiceType} could not be registered", serviceType);
                throw;
            }
        }
    }
}
