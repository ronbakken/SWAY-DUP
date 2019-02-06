using Newtonsoft.Json;

namespace Mapping
{
    public sealed class OfferMapItemQueryEntity : OfferMapItemEntity
    {
        [JsonConstructor]
        public OfferMapItemQueryEntity(
            int version,
            string quadKey,
            string offerId,
            string userId,
            GeoLocationEntity location,
            double distanceFromCenter) : base(version, quadKey, offerId, userId, location)
        {
            this.DistanceFromCenter = distanceFromCenter;
        }

        [JsonProperty("distanceFromCenter")]
        public double DistanceFromCenter { get; }
    }
}
