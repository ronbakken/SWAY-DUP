using Newtonsoft.Json;

namespace Users
{
    public sealed class LocationEntity
    {
        [JsonConstructor]
        public LocationEntity(
            string name,
            double latitude,
            double longitude)
        {
            this.Name = name;
            this.Latitude = latitude;
            this.Longitude = longitude;
        }

        [JsonProperty("name")]
        public string Name { get; }

        [JsonProperty("latitude")]
        public double Latitude { get; }

        [JsonProperty("longitude")]
        public double Longitude { get; }
    }
}
