using Newtonsoft.Json;

namespace Mapping
{
    public sealed class MapItemEntity
    {
        public MapItemEntity(
            string quadKey,
            string id,
            MapItemStatusEntity status,
            string userId,
            GeoLocationEntity location) : this(1, quadKey, id, status, userId, location)
        {
        }

        [JsonConstructor]
        public MapItemEntity(
            int version,
            string quadKey,
            string id,
            MapItemStatusEntity status,
            string userId,
            GeoLocationEntity location)
        {
            this.Version = version;
            this.QuadKey = quadKey;
            this.Id = id;
            this.Status = status;
            this.UserId = userId;
            this.Location = location;
        }

        [JsonProperty("version")]
        public int Version { get; }

        [JsonProperty("quadKey")]
        public string QuadKey { get; }

        [JsonProperty("id")]
        public string Id { get; }

        [JsonProperty("status")]
        public MapItemStatusEntity Status { get; }

        [JsonProperty("userId")]
        public string UserId { get; }

        [JsonProperty("location")]
        public GeoLocationEntity Location { get; }
    }
}
