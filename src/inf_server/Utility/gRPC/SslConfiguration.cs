using System;
using System.IO;

namespace Utility.gRPC
{
    public sealed class SslConfiguration
    {
        private static readonly Lazy<SslConfiguration> lazyInstance = new Lazy<SslConfiguration>(GetSslConfiguration);

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
            using (var stream = typeof(SslConfiguration).Assembly.GetManifestResourceStream($"Utility.gRPC.{name}"))
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
