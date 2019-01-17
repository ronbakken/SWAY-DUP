using System.Fabric;
using System.Threading;
using System.Threading.Tasks;
using API.Services;
using Grpc.Core;
using Grpc.Core.Interceptors;
using Microsoft.ServiceFabric.Services.Communication.Runtime;

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
                    ConfigurationService.BindService(new ConfigurationServiceImpl()).Intercept(new FooInterceptor()),
                    InvitationCodeService.BindService(new InvitationCodeServiceImpl()),
                    UserService.BindService(new UserServiceImpl()),
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
