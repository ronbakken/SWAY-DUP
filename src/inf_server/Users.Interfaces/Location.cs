using System.Runtime.Serialization;

namespace Users.Interfaces
{
    [DataContract]
    public sealed class Location
    {
        public Location(
            string name,
            double latitude,
            double longitude)
        {
            this.Name = name;
            this.Latitude = latitude;
            this.Longitude = longitude;
        }

        [DataMember]
        public string Name { get; private set; }

        [DataMember]
        public double Latitude { get; private set; }

        [DataMember]
        public double Longitude { get; private set; }
    }
}
