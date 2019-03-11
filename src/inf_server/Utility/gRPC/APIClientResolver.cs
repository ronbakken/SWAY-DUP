using System;
using System.Fabric;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Grpc.Core;
using Grpc.Core.Interceptors;
using Microsoft.ServiceFabric.Services.Client;

namespace Utility.gRPC
{
    public static class APIClientResolver
    {
        private static readonly Random random = new Random();

        public static async Task<T> Resolve<T>(string serviceName)
            where T : ClientBase<T>
        {
            var partitionResolver = ServicePartitionResolver.GetDefault();
            var uri = $"{FabricRuntime.GetActivationContext().ApplicationName}/{serviceName}";
            var cancellationTokenSource = new CancellationTokenSource(TimeSpan.FromSeconds(5));
            var partition = await partitionResolver
                .ResolveAsync(
                    new Uri(uri),
                    ServicePartitionKey.Singleton,
                    cancellationTokenSource.Token)
                .ContinueOnAnyContext();
            var endpoint = partition
                .Endpoints
                .ElementAt(random.Next(0, partition.Endpoints.Count));

            var address = endpoint.Address.Substring(endpoint.Address.IndexOf("\"\":\"") + 4);
            address = address.Substring(0, address.IndexOf("\""));

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
