using System.Fabric;
using System.Threading;
using System.Threading.Tasks;
using Grpc.Core;
using Grpc.Core.Interceptors;
using Microsoft.ServiceFabric.Services.Communication.Runtime;
using Serilog;

namespace Utility
{
    public sealed class gRPCCommunicationListener : ICommunicationListener
    {
        private readonly ILogger logger;
        private readonly ServerServiceDefinition[] services;
        Server server;

        public gRPCCommunicationListener(
            ILogger logger,
            params ServerServiceDefinition[] services)
        {
            this.logger = logger.ForContext<gRPCCommunicationListener>();
            this.services = services;

            this.logger.Information("Constructed gRPCCommunicationListener.");
        }

        public async void Abort()
        {
            if (server != null)
            {
                this.logger.Information("Abort");
                await server
                    .KillAsync()
                    .ContinueOnAnyContext();
            }
        }

        public async Task CloseAsync(CancellationToken cancellationToken)
        {
            if (server != null)
            {
                this.logger.Information("Close");
                await server
                    .ShutdownAsync()
                    .ContinueOnAnyContext();
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

            server = new Server
            {
                Ports =
                {
                    new ServerPort(endpoint.IpAddressOrFqdn, endpoint.Port, ServerCredentials.Insecure),
                },
            };

            foreach (var service in this.services)
            {
                server.Services.Add(service.Intercept(LogContextInterceptor.Instance));
            }

            server.Start();
            this.logger.Information("Server started");

            return Task.FromResult(address);
        }
    }
}
