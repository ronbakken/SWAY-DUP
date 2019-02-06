using Newtonsoft.Json;

namespace Mapping
{
    public sealed class GeoLocationEntity
    {
        [JsonConstructor]
        public GeoLocationEntity(
            double latitude,
            double longitude)
        {
            this.Latitude = latitude;
            this.Longitude = longitude;
        }

        [JsonProperty("latitude")]
        public double Latitude { get; }

        [JsonProperty("longitude")]
        public double Longitude { get; }
    }
}
