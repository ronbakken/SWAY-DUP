using System.IO;
using System.Text;
using Microsoft.Azure.Cosmos;
using Newtonsoft.Json;
using Utility.Serialization;

namespace Utility
{
    public sealed class InfCosmosConfiguration : CosmosConfiguration
    {
        public InfCosmosConfiguration(string connectionString)
            : base(connectionString)
        {
            this.UseCustomJsonSerializer(JsonNetCosmosJsonSerializer.Instance);
        }

        private sealed class JsonNetCosmosJsonSerializer : CosmosJsonSerializer
        {
            public static readonly JsonNetCosmosJsonSerializer Instance = new JsonNetCosmosJsonSerializer();
            private static readonly JsonSerializer serializer = JsonSerializer.Create(InfJsonSerializerSettings.Instance);

            private JsonNetCosmosJsonSerializer()
            {
            }

            public override T FromStream<T>(Stream stream)
            {
                using (stream)
                {
                    if (typeof(Stream).IsAssignableFrom(typeof(T)))
                    {
                        return (T)(object)stream;
                    }

                    using (var streamReader = new StreamReader(stream))
                    using (var jsonTextReader = new JsonTextReader(streamReader))
                    {
                        return serializer.Deserialize<T>(jsonTextReader);
                    }
                }
            }

            public override Stream ToStream<T>(T input)
            {
                var streamPayload = new MemoryStream();

                using (var streamWriter = new StreamWriter(streamPayload, encoding: Encoding.Default, bufferSize: 1024, leaveOpen: true))
                using (var writer = new JsonTextWriter(streamWriter))
                {
                    writer.Formatting = Formatting.None;
                    serializer.Serialize(writer, input);
                    writer.Flush();
                    streamWriter.Flush();
                }

                streamPayload.Position = 0;
                return streamPayload;
            }
        }
    }
}
