using System;
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
        private readonly Action<string, object[]> log;
        Server server;

        public gRPCCommunicationListener(Action<string, object[]> log)
        {
            this.log = log;

            Log("Constructed gRPCCommunicationListener.");
        }

        public async void Abort()
        {
            if (server != null)
            {
                Log("Abort.");
                await server.KillAsync();
            }
        }

        public async Task CloseAsync(CancellationToken cancellationToken)
        {
            if (server != null)
            {
                Log("Close.");
                await server.ShutdownAsync();
            }
        }

        public Task<string> OpenAsync(CancellationToken cancellationToken)
        {
            Log("Open.");

            var endpoint = FabricRuntime
                .GetActivationContext()
                .GetEndpoint("ServiceEndpoint");

            var authorizationInterceptor = new AuthorizationInterceptor(this.log);

            server = new Server
            {
                Services =
                {
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

            var address = $"{endpoint.IpAddressOrFqdn}:{endpoint.Port}";
            Log("Address is '{0}'.", address);

            server.Start();
            Log("Server started.");

            return Task.FromResult(address);
        }

        private void Log(string message, params object[] args) =>
            this.log(message, args);
    }
}
