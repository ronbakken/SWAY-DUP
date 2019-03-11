using System.Collections.Generic;
using System.Fabric;
using System.Threading;
using System.Threading.Tasks;
using InvitationCodes.Interfaces;
using Microsoft.Azure.Cosmos;
using Microsoft.ServiceFabric.Services.Communication.Runtime;
using Microsoft.ServiceFabric.Services.Runtime;
using Serilog;
using Utility;
using Utility.gRPC;

namespace InvitationCodes
{
    internal sealed class InvitationCodes : StatelessService
    {
        private readonly ILogger logger;
        private readonly InvitationCodesServiceImpl implementation;

        public InvitationCodes(StatelessServiceContext context)
            : base(context)
        {
            this.logger = Logging.GetLogger(this);
            this.implementation = new InvitationCodesServiceImpl(this.logger);
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
                            InvitationCodeService.BindService(this.implementation))),
            };
    }
}
