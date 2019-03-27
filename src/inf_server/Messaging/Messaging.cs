using System.Collections.Generic;
using System.Fabric;
using System.Threading;
using System.Threading.Tasks;
using Messaging.Interfaces;
using Microsoft.Azure.Cosmos;
using Microsoft.Azure.ServiceBus;
using Microsoft.ServiceFabric.Services.Communication.Runtime;
using Microsoft.ServiceFabric.Services.Runtime;
using Serilog;
using Utility;
using Utility.gRPC;

namespace Messaging
{
    internal sealed class Messaging : StatelessService
    {
        private readonly ILogger logger;
        private readonly MessagingServiceImpl implementation;

        public Messaging(StatelessServiceContext context)
            : base(context)
        {
            this.logger = Logging.GetLogger(this);
            var conversationUpdatedTopicClient = this.Context.CodePackageActivationContext.GetServiceBusTopicClient(this.logger, "ConversationUpdated");
            var messageUpdatedTopicClient = this.Context.CodePackageActivationContext.GetServiceBusTopicClient(this.logger, "MessageUpdated");
            this.implementation = new MessagingServiceImpl(this.logger, conversationUpdatedTopicClient, messageUpdatedTopicClient);
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
                        new CommunicationListener(
                            this.logger,
                            useSsl: false,
                            MessagingService.BindService(this.implementation))),
            };
    }
}
