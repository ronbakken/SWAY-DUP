using Newtonsoft.Json;
using Optional;

namespace Offers
{
    public sealed class OfferEntity
    {
        public OfferEntity(
            string id,
            string userId,
            GeoLocationEntity location) : this(1, id, userId, location)
        {
        }

        [JsonConstructor]
        public OfferEntity(
            int version,
            string id,
            string userId,
            GeoLocationEntity location)
        {
            this.Version = version;
            this.Id = id;
            this.UserId = userId;
            this.Location = location;
        }

        [JsonProperty("id")]
        public string Id { get; }

        [JsonProperty("version")]
        public int Version { get; }

        [JsonProperty("userId")]
        public string UserId { get; }

        [JsonProperty("location")]
        public GeoLocationEntity Location { get; }

        public OfferEntity With(Option<string> id = default, Option<string> userId = default, Option<GeoLocationEntity> location = default) =>
            new OfferEntity(
                Version,
                id.ValueOr(Id),
                userId.ValueOr(UserId),
                location.ValueOr(Location));
    }
}
