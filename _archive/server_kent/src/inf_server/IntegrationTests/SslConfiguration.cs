using System;
using System.IO;

namespace IntegrationTests
{
    public sealed class SslConfiguration
    {
        private static readonly Lazy<SslConfiguration> lazyInstance = new Lazy<SslConfiguration>(GetSslConfiguration);

        private SslConfiguration(string serverCertificate)
        {
            this.ServerCertificate = serverCertificate;
        }

        public static SslConfiguration Instance => lazyInstance.Value;

        public string ServerCertificate { get; }

        private static SslConfiguration GetSslConfiguration()
        {
            var serverCertificate = ReadResource("server.crt");

            if (serverCertificate == null)
            {
                return null;
            }

            return new SslConfiguration(serverCertificate);
        }

        private static string ReadResource(string name)
        {
            using (var stream = typeof(SslConfiguration).Assembly.GetManifestResourceStream($"IntegrationTests.{name}"))
            {
                if (stream == null)
                {
                    return null;
                }

                using (var streamReader = new StreamReader(stream))
                {
                    return streamReader.ReadToEnd();
                }
            }
        }
    }
}
