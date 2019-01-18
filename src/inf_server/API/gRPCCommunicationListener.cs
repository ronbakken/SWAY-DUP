using System.Fabric;
using System.Threading;
using System.Threading.Tasks;
using API.Interfaces;
using Mocks=API.Services.Mocks;
using Grpc.Core;
using Microsoft.ServiceFabric.Services.Communication.Runtime;
using API.Services;

namespace API
{
    public sealed class gRPCCommunicationListener : ICommunicationListener
    {
        Server server;

        public async void Abort()
        {
            if (server != null)
                await server.KillAsync();
        }

        public async Task CloseAsync(CancellationToken cancellationToken)
        {
            if (server != null)
            {
                await server.ShutdownAsync();
            }
        }

        public Task<string> OpenAsync(CancellationToken cancellationToken)
        {
            var endpoint = FabricRuntime
                .GetActivationContext()
                .GetEndpoint("ServiceEndpoint");

            server = new Server
            {
                Services =
                {
                    // Mocks
                    //InfApi.BindService(new Mocks.InfApiImpl()),
                    //InfAuth.BindService(new Mocks.InfAuthImpl()),
                    //InfConfig.BindService(new Mocks.InfConfigImpl()),
                    //InfSystem.BindService(new Mocks.InfSystemImpl()),

                    // Real APIs
                    InfApi.BindService(new Mocks.InfApiImpl()),
                    InfAuth.BindService(new InfAuthImpl()),
                    InfConfig.BindService(new Mocks.InfConfigImpl()),
                    InfSystem.BindService(new Mocks.InfSystemImpl()),

                    // Admin APIs
                    InfAdminInvitationCodes.BindService(new InfAdminInvitationCodesImpl()),
                },
                Ports =
                {
                    new ServerPort(endpoint.IpAddressOrFqdn, endpoint.Port, ServerCredentials.Insecure),
                },
            };

            server.Start();

            var address = $"{endpoint.IpAddressOrFqdn}:{endpoint.Port}";
            return Task.FromResult(address);
        }
    }
}
