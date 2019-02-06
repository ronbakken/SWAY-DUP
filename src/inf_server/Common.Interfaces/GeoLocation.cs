using System.Runtime.Serialization;

namespace Common.Interfaces
{
    [DataContract]
    public sealed class GeoLocation
    {
        public GeoLocation(
            double latitude,
            double longitude)
        {
            this.Latitude = latitude;
            this.Longitude = longitude;
        }

        [DataMember]
        public double Latitude { get; private set; }

        [DataMember]
        public double Longitude { get; private set; }
    }
}
