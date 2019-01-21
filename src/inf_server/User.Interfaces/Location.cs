using System.Runtime.Serialization;

namespace User.Interfaces
{
    [DataContract]
    public sealed class Location
    {
        public Location(
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

        [DataMember]
        public string Name { get; private set; }

        [DataMember]
        public string Description { get; private set; }

        [DataMember]
        public double Latitude { get; private set; }

        [DataMember]
        public double Longitude { get; private set; }
    }
}
