using System.Runtime.Serialization;
using Common.Interfaces;

namespace Mapping.Interfaces
{
    [DataContract]
    public sealed class OfferSearchFilter
    {
        public OfferSearchFilter(
            int mapLevel,
            GeoLocation northWest,
            GeoLocation southEast)
        {
            this.MapLevel = mapLevel;
            this.NorthWest = northWest;
            this.SouthEast = southEast;
        }

        [DataMember]
        public int MapLevel { get; private set; }

        [DataMember]
        public GeoLocation NorthWest { get; private set; }

        [DataMember]
        public GeoLocation SouthEast { get; private set; }
    }
}
