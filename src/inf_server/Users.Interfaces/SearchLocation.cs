using System.Runtime.Serialization;

namespace Users.Interfaces
{
    [DataContract]
    public sealed class SearchLocation
    {
        public SearchLocation(
            double latitude,
            double longitude,
            double radiusKms)
        {
            this.Latitude = latitude;
            this.Longitude = longitude;
            this.RadiusKms = radiusKms;
        }

        [DataMember]
        public double Latitude { get; private set; }

        [DataMember]
        public double Longitude { get; private set; }

        [DataMember]
        public double RadiusKms { get; private set; }
    }
}
