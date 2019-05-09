using System;
using Grpc.Core;
using Grpc.Core.Interceptors;

namespace Utility.gRPC
{
    public static class APIClientResolver
    {
        private static readonly Random random = new Random();

        public static T Resolve<T>(string serviceName, int port)
            where T : ClientBase<T>
        {
            var address = $"{serviceName}:{port}";

            ChannelCredentials channelCredentials = ChannelCredentials.Insecure;
            var sslConfiguration = SslConfiguration.Instance;

            // TODO: do we want to use SSL for intra-service comms? If so, it'll need to be a separate certificate that wildcards appropriately
            // based on the cluster host names. We'd need to log to see what the pattern is for those names.
            //if (sslConfiguration != null)
            //{
            //    channelCredentials = new SslCredentials(sslConfiguration.ServerCertificate);
            //}

            var channel = new Channel(address, channelCredentials);
            var callInvoker = channel.Intercept(LogContextInterceptor.Instance);

            var client = Activator.CreateInstance(typeof(T), callInvoker);
            var result = (T)client;

            return result;
        }
    }
}
