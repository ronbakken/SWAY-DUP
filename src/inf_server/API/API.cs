using Microsoft.ServiceFabric.Services.Communication.Runtime;
using Microsoft.ServiceFabric.Services.Runtime;
using System.Collections.Generic;
using System.Fabric;
using System.Fabric.Health;
using System.Threading;
using System.Threading.Tasks;

namespace API
{
    internal sealed class API : StatelessService
    {
        public API(StatelessServiceContext context)
            : base(context)
        {
        }

        protected override IEnumerable<ServiceInstanceListener> CreateServiceInstanceListeners() =>
            new[]
            {
                new ServiceInstanceListener(initParams => new gRPCCommunicationListener(Log))
            };

        private static void Log(string message, params object[] args) =>
            ServiceEventSource.Current.Message(message, args);
    }
}
