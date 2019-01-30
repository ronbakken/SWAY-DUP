using System.Collections.Generic;
using System.Fabric;
using Microsoft.ServiceFabric.Services.Communication.Runtime;
using Microsoft.ServiceFabric.Services.Runtime;
using Serilog;
using Utility;

namespace API
{
    internal sealed class API : StatelessService
    {
        private readonly ILogger logger;

        public API(StatelessServiceContext context)
            : base(context)
        {
            var configurationPackage = this.Context.CodePackageActivationContext.GetConfigurationPackageObject("Config");
            var logStorageConnectionString = configurationPackage.Settings.Sections["Logging"].Parameters["StorageConnectionString"].Value;
            this.logger = Logging.GetLogger(this, logStorageConnectionString);
        }

        protected override IEnumerable<ServiceInstanceListener> CreateServiceInstanceListeners() =>
            new[]
            {
                new ServiceInstanceListener(initParams => new gRPCCommunicationListener(this.logger))
            };
    }
}
