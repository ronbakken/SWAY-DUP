using System.Collections.Generic;
using System.Fabric;
using Microsoft.ServiceFabric.Services.Communication.Runtime;
using Microsoft.ServiceFabric.Services.Runtime;

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
                new ServiceInstanceListener(initParams => new gRPCCommunicationListener(ServiceEventSource.Current.Message))
            };
    }
}
