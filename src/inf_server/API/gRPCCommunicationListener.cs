using System.Fabric;
using System.Threading;
using System.Threading.Tasks;
using API.Interfaces;
using API.Services.Auth;
using API.Services.BlobStorage;
using API.Services.InvitationCodes;
using API.Services.Offers;
using API.Services.System;
using API.Services.Users;
using Grpc.Core;
using Grpc.Core.Interceptors;
using Microsoft.ServiceFabric.Services.Communication.Runtime;
using Serilog;
using Mocks = API.Services.Mocks;

namespace API
{
    public sealed class gRPCCommunicationListener : ICommunicationListener
    {
        private readonly ILogger logger;
        Server server;

        public gRPCCommunicationListener(ILogger logger)
        {
            this.logger = logger.ForContext<gRPCCommunicationListener>();

            this.logger.Information("Constructed gRPCCommunicationListener.");
        }

        public async void Abort()
        {
            if (server != null)
            {
                this.logger.Information("Abort");
                await server.KillAsync();
            }
        }

        public async Task CloseAsync(CancellationToken cancellationToken)
        {
            if (server != null)
            {
                this.logger.Information("Close");
                await server.ShutdownAsync();
            }
        }

        public Task<string> OpenAsync(CancellationToken cancellationToken)
        {
            this.logger.Information("Open");

            var endpoint = FabricRuntime
                .GetActivationContext()
                .GetEndpoint("ServiceEndpoint");
            var address = $"{endpoint.IpAddressOrFqdn}:{endpoint.Port}";
            this.logger.Information("Address is {Address}", address);

            var authorizationInterceptor = new AuthorizationInterceptor(this.logger);

            server = new Server
            {
                Services =
                {
                    InfApi.BindService(new Mocks.InfApiImpl()).Intercept(authorizationInterceptor),
                    InfAuth.BindService(new InfAuthImpl(this.logger)).Intercept(authorizationInterceptor),
                    InfBlobStorage.BindService(new InfBlobStorageImpl(this.logger)).Intercept(authorizationInterceptor),
                    InfConfig.BindService(new Mocks.InfConfigImpl()).Intercept(authorizationInterceptor),
                    InfInvitationCodes.BindService(new InfInvitationCodesImpl(this.logger)).Intercept(authorizationInterceptor),
                    InfOffers.BindService(new InfOffersImpl(this.logger)).Intercept(authorizationInterceptor),
                    InfSystem.BindService(new InfSystemImpl(this.logger)).Intercept(authorizationInterceptor),
                    InfUsers.BindService(new InfUsersImpl(this.logger)).Intercept(authorizationInterceptor),
                },
                Ports =
                {
                    new ServerPort(endpoint.IpAddressOrFqdn, endpoint.Port, ServerCredentials.Insecure),
                },
            };

            server.Start();
            this.logger.Information("Server started");

            return Task.FromResult(address);
        }
    }
}
