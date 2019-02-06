using System.Runtime.Serialization;

namespace Common.Interfaces
{
    [DataContract]
    public sealed class Location
    {
        public Location(
            string name,
            GeoLocation geoLocation)
        {
            this.Name = name;
            this.GeoLocation = geoLocation;
        }

        [DataMember]
        public string Name { get; private set; }

        [DataMember]
        public GeoLocation GeoLocation { get; private set; }
    }
}
