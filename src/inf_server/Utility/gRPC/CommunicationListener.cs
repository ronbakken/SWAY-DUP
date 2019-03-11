using System.Collections.Generic;
using System.Fabric;
using System.IO;
using System.Threading;
using System.Threading.Tasks;
using Grpc.Core;
using Grpc.Core.Interceptors;
using Microsoft.ServiceFabric.Services.Communication.Runtime;
using Serilog;

namespace Utility.gRPC
{
    public sealed class CommunicationListener : ICommunicationListener
    {
        private readonly ILogger logger;
        private readonly bool useSsl;
        private readonly ServerServiceDefinition[] services;
        Server server;

        public CommunicationListener(
            ILogger logger,
            bool useSsl,
            params ServerServiceDefinition[] services)
        {
            this.logger = logger.ForContext<CommunicationListener>();
            this.useSsl = useSsl;
            this.services = services;

            this.logger.Information("Constructed CommunicationListener.");
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

            ServerCredentials serverCredentials = ServerCredentials.Insecure;

            if (this.useSsl)
            {
                var sslConfiguration = SslConfiguration.Instance;

                if (sslConfiguration != null)
                {
                    this.logger.Debug("Applying SSL configuration to connection");
                    var keyPair = new KeyCertificatePair(sslConfiguration.ServerCertificate, sslConfiguration.ServerKey);
                    serverCredentials = new SslServerCredentials(new List<KeyCertificatePair>() { keyPair });
                }
                else
                {
                    this.logger.Warning("SSL configuration could not be determined. This is fine if you're running locally or in unofficial deployed environments, but is unexpected elsewhere");
                }
            }

            server = new Server
            {
                Ports =
                {
                    new ServerPort("0.0.0.0", endpoint.Port, serverCredentials),
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

        private async Task<string> ReadResource(string name)
        {
            using (var stream = this.GetType().Assembly.GetManifestResourceStream($"Utility.{name}"))
            using (var streamReader = new StreamReader(stream))
            {
                return await streamReader.ReadToEndAsync();
            }
        }
    }
}
