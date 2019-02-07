using Newtonsoft.Json;
using NodaTime;
using Optional;

namespace Offers
{
    public sealed class OfferEntity
    {
        public OfferEntity(
            string id,
            OfferStatusEntity status,
            ZonedDateTime statusTimestamp,
            string userId,
            GeoLocationEntity location) : this(1, id, status, statusTimestamp, userId, location)
        {
        }

        [JsonConstructor]
        public OfferEntity(
            int version,
            string id,
            OfferStatusEntity status,
            ZonedDateTime statusTimestamp,
            string userId,
            GeoLocationEntity location)
        {
            this.Version = version;
            this.Id = id;
            this.Status = status;
            this.StatusTimestamp = statusTimestamp;
            this.UserId = userId;
            this.Location = location;
        }

        [JsonProperty("id")]
        public string Id { get; }

        [JsonProperty("status")]
        public OfferStatusEntity Status { get; }

        [JsonProperty("statusTimestamp")]
        public ZonedDateTime StatusTimestamp { get; }

        [JsonProperty("version")]
        public int Version { get; }

        [JsonProperty("userId")]
        public string UserId { get; }

        [JsonProperty("location")]
        public GeoLocationEntity Location { get; }

        public OfferEntity With(Option<string> id = default, Option<OfferStatusEntity> status = default, Option<ZonedDateTime> statusTimestamp = default, Option<string> userId = default, Option<GeoLocationEntity> location = default) =>
            new OfferEntity(
                Version,
                id.ValueOr(Id),
                status.ValueOr(Status),
                statusTimestamp.ValueOr(StatusTimestamp),
                userId.ValueOr(UserId),
                location.ValueOr(Location));
    }
}
