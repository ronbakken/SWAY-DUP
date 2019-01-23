using Newtonsoft.Json;

namespace Users
{
    public sealed class LocationEntity
    {
        [JsonConstructor]
        public LocationEntity(
            string name,
            string description,
            double latitude,
            double longitude)
        {
            this.Name = name;
            this.Description = description;
            this.Latitude = latitude;
            this.Longitude = longitude;
        }

        [JsonProperty("name")]
        public string Name { get; }

        [JsonProperty("description")]
        public string Description { get; }

        [JsonProperty("latitude")]
        public double Latitude { get; }

        [JsonProperty("longitude")]
        public double Longitude { get; }
    }
}
