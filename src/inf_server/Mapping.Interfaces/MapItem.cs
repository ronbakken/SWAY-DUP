using System.Runtime.Serialization;
using Common.Interfaces;

namespace Mapping.Interfaces
{
    [DataContract]
    [KnownType(typeof(OfferMapItem))]
    public abstract class MapItem
    {
        protected MapItem(
            MapItemStatus status,
            GeoLocation location)
        {
            this.Status = status;
            this.Location = location;
        }

        [DataMember]
        public MapItemStatus Status { get; private set; }

        [DataMember]
        public GeoLocation Location { get; private set; }
    }
}
