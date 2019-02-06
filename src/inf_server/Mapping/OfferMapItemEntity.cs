using Newtonsoft.Json;

namespace Mapping
{
    public class OfferMapItemEntity
    {
        public OfferMapItemEntity(
            string quadKey,
            string offerId,
            string userId,
            GeoLocationEntity location) : this(1, quadKey, offerId, userId, location)
        {
        }

        [JsonConstructor]
        public OfferMapItemEntity(
            int version,
            string quadKey,
            string offerId,
            string userId,
            GeoLocationEntity location)
        {
            this.Version = version;
            this.QuadKey = quadKey;
            this.OfferId = offerId;
            this.UserId = userId;
            this.Location = location;
        }

        [JsonProperty("id")]
        public string Id => this.OfferId;

        [JsonProperty("quadKey")]
        public string QuadKey { get; }

        [JsonProperty("offerId")]
        public string OfferId { get; }

        [JsonProperty("version")]
        public int Version { get; }

        [JsonProperty("userId")]
        public string UserId { get; }

        [JsonProperty("location")]
        public GeoLocationEntity Location { get; }
    }
}
