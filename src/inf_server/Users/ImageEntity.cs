using System.Collections.Immutable;
using Newtonsoft.Json;

namespace Users
{
    public sealed class ImageEntity
    {
        [JsonConstructor]
        public ImageEntity(
            string uri,
            ImmutableList<byte> lowResData)
        {
            this.Uri = uri;
            this.LowResData = lowResData;
        }

        [JsonProperty("uri")]
        public string Uri { get; }

        [JsonProperty("lowResData")]
        public ImmutableList<byte> LowResData { get; }
    }
}
