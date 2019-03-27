using System;
using System.IO;
using Serilog;

namespace Utility.gRPC
{
    public sealed class SslConfiguration
    {
        private static readonly Lazy<SslConfiguration> lazyInstance = new Lazy<SslConfiguration>(GetSslConfiguration);
        private static readonly ILogger logger = Logging.GetLogger<SslConfiguration>();

        private SslConfiguration(
            string serverCertificate,
            string serverKey)
        {
            this.ServerCertificate = serverCertificate;
            this.ServerKey = serverKey;
        }

        public static SslConfiguration Instance => lazyInstance.Value;

        public string ServerCertificate { get; }

        public string ServerKey { get; }

        private static SslConfiguration GetSslConfiguration()
        {
            logger.Debug("Attempting to resolve SSL configuration");
            var serverCertificate = ReadResource("server.crt");
            var serverKey = ReadResource("server.key");

            if (serverCertificate == null || serverKey == null)
            {
                return null;
            }

            return new SslConfiguration(serverCertificate, serverKey);
        }

        private static string ReadResource(string name)
        {
            var resourceName = $"Utility.gRPC.{name}";

            logger.Debug("Looking for resource with name {ResourceName} amongst all resources {AllResources}", resourceName, typeof(SslConfiguration).Assembly.GetManifestResourceNames());

            using (var stream = typeof(SslConfiguration).Assembly.GetManifestResourceStream(resourceName))
            {
                if (stream == null)
                {
                    logger.Debug("Could not find resource named {ResourceName}", resourceName);
                    return null;
                }

                logger.Debug("Found resource named {ResourceName}", resourceName);

                using (var streamReader = new StreamReader(stream))
                {
                    return streamReader.ReadToEnd();
                }
            }
        }
    }
}
