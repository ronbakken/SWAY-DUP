using System.IO;
using System.Reflection;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Google.Protobuf;
using Google.Protobuf.Reflection;
using Microsoft.Azure.Cosmos;
using Newtonsoft.Json.Linq;
using Serilog;

namespace Utility
{
    public sealed class InfCosmosConfiguration : CosmosConfiguration
    {
        public InfCosmosConfiguration(string connectionString)
            : base(connectionString)
        {
            this.UseCustomJsonSerializer(JsonNetCosmosJsonSerializer.Instance);
            this.AddCustomHandlers(LoggingHandler.Instance);
        }

        // TODO: HACK: exists only to get around https://github.com/Azure/azure-cosmos-dotnet-v3/issues/19
        public static T Transform<T>(JObject jobject) where T : IMessage, new() =>
            JsonNetCosmosJsonSerializer.Instance.FromJObject<T>(jobject);

        private sealed class JsonNetCosmosJsonSerializer : CosmosJsonSerializer
        {
            public static readonly JsonNetCosmosJsonSerializer Instance = new JsonNetCosmosJsonSerializer();

            private static readonly JsonFormatter jsonFormatter = new JsonFormatter(new JsonFormatter.Settings(formatDefaultValues: false));
            private static readonly JsonParser jsonParser = new JsonParser(JsonParser.Settings.Default.WithIgnoreUnknownFields(true));

            private JsonNetCosmosJsonSerializer()
            {
            }

            // TODO: HACK: exists only to get around https://github.com/Azure/azure-cosmos-dotnet-v3/issues/19
            public T FromJObject<T>(JObject jobject) where T : IMessage, new() =>
                jsonParser.Parse<T>(jobject.ToString());

            public override T FromStream<T>(Stream stream)
            {
                using (stream)
                {
                    if (typeof(Stream).IsAssignableFrom(typeof(T)))
                    {
                        return (T)(object)stream;
                    }

                    var descriptor = (MessageDescriptor)typeof(T).GetProperty("Descriptor", BindingFlags.Public | BindingFlags.Static)?.GetValue(null);

                    if (descriptor == null)
                    {
                        return default;
                    }

                    using (var streamReader = new StreamReader(stream))
                    {
                        return (T)jsonParser.Parse(streamReader, descriptor);
                    }
                }
            }

            public override Stream ToStream<T>(T input)
            {
                var streamPayload = new MemoryStream();

                using (var streamWriter = new StreamWriter(streamPayload, encoding: Encoding.Default, bufferSize: 1024, leaveOpen: true))
                {
                    jsonFormatter.WriteValue(streamWriter, input);
                    streamWriter.Flush();
                }

                streamPayload.Position = 0;
                return streamPayload;
            }
        }

        private sealed class LoggingHandler : CosmosRequestHandler
        {
            public static readonly LoggingHandler Instance = new LoggingHandler();

            private static readonly ILogger logger = Logging.GetLogger<InfCosmosConfiguration>();

            private LoggingHandler()
            {
            }

            public override async Task<CosmosResponseMessage> SendAsync(CosmosRequestMessage request, CancellationToken cancellationToken)
            {
                using (var performanceBlock = logger.Performance("Cosmos DB request: method {Method}, URI {Uri}, headers {@Headers}, properties {@Properties}", request.Method, request.RequestUri, request.Headers, request.Properties))
                {
                    var response = await base.SendAsync(request, cancellationToken);

                    performanceBlock.ReplaceMessage(
                        "Cosmos DB request: method {Method}, URI {Uri}, headers {@Headers}, properties {@Properties}. Response: status code {StatusCode} (is success {IsSuccess}), error message {ErrorMessage}, headers {@Headers}",
                        request.Method,
                        request.RequestUri,
                        request.Headers,
                        request.Properties,
                        response.StatusCode,
                        response.IsSuccessStatusCode,
                        response.ErrorMessage,
                        response.Headers);

                    return response;
                }
            }
        }
    }
}
