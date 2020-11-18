using System;
using System.Collections.Generic;
using Grpc.Core;
using Grpc.Core.Interceptors;

namespace Utility.gRPC
{
    public static class ServerFactory
    {
        public static Server Create(
            bool useSsl,
            params ServerServiceDefinition[] services)
        {
            var logger = Logging.GetLogger(typeof(ServerFactory));
            var portString = Environment.GetEnvironmentVariable("GRPC_PORT");

            if (portString == null)
            {
                throw new InvalidOperationException("No 'GRPC_PORT' environment variable is set.");
            }

            var port = int.Parse(portString);
            ServerCredentials serverCredentials = ServerCredentials.Insecure;

            if (useSsl)
            {
                var sslConfiguration = SslConfiguration.Instance;

                if (sslConfiguration != null)
                {
                    logger.Debug("Applying SSL configuration to connection");
                    var keyPair = new KeyCertificatePair(sslConfiguration.ServerCertificate, sslConfiguration.ServerKey);
                    serverCredentials = new SslServerCredentials(new List<KeyCertificatePair>() { keyPair });
                }
                else
                {
                    logger.Warning("SSL configuration could not be determined. This is fine if you're running locally or in unofficial deployed environments, but is unexpected elsewhere");
                }
            }

            var host = "0.0.0.0";
            logger.Debug("Creating gRPC server on host {Host}, port {Port}, use SSL {UseSSL}, with {ServiceCount} services", host, port, useSsl, services.Length);

            var server = new Server
            {
                Ports =
                {
                    new ServerPort(host, port, serverCredentials),
                },
            };

            foreach (var service in services)
            {
                server.Services.Add(service.Intercept(LogContextInterceptor.Instance));
            }

            return server;
        }
    }
}
