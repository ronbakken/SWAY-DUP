using System.Collections.Generic;
using System.Fabric;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Azure.Cosmos;
using Microsoft.Azure.ServiceBus;
using Microsoft.ServiceFabric.Services.Communication.Runtime;
using Microsoft.ServiceFabric.Services.Runtime;
using Serilog;
using Users.Interfaces;
using Utility;

namespace Users
{
    internal sealed class Users : StatelessService
    {
        private readonly ILogger logger;
        private readonly UsersServiceImpl implementation;

        public Users(StatelessServiceContext context)
            : base(context)
        {
            this.logger = Logging.GetLogger(this);
            var userUpdatedTopicClient = this.Context.CodePackageActivationContext.GetServiceBusTopicClient(this.logger, "UserUpdated");
            this.implementation = new UsersServiceImpl(this.logger, userUpdatedTopicClient);
        }

        protected override async Task RunAsync(CancellationToken cancellationToken)
        {
            await implementation
                .Initialize(this.Context.CodePackageActivationContext.GetCosmosClient(), cancellationToken)
                .ContinueOnAnyContext();
        }

        protected override IEnumerable<ServiceInstanceListener> CreateServiceInstanceListeners() =>
            new[]
            {
                new ServiceInstanceListener(
                    initParams =>
                        new gRPCCommunicationListener(
                            this.logger,
                            UsersService.BindService(this.implementation))),
            };
    }
}
