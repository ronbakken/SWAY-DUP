using System.Fabric;
using System.Threading;
using System.Threading.Tasks;
using API.Interfaces;
using API.Services.Auth;
using API.Services.BlobStorage;
using API.Services.InvitationCodes;
using Grpc.Core;
using Grpc.Core.Interceptors;
using Microsoft.ServiceFabric.Services.Communication.Runtime;
using Mocks = API.Services.Mocks;

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

            var authorizationInterceptor = new AuthorizationInterceptor();

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
                    InfApi.BindService(new Mocks.InfApiImpl()).Intercept(authorizationInterceptor),
                    InfAuth.BindService(new InfAuthImpl()).Intercept(authorizationInterceptor),
                    InfBlobStorage.BindService(new InfBlobStorageImpl()).Intercept(authorizationInterceptor),
                    InfConfig.BindService(new Mocks.InfConfigImpl()).Intercept(authorizationInterceptor),
                    InfSystem.BindService(new Mocks.InfSystemImpl()).Intercept(authorizationInterceptor),
                    InfInvitationCodes.BindService(new InfInvitationCodesImpl()).Intercept(authorizationInterceptor),
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
