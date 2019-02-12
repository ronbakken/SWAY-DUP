using System.Runtime.Serialization;
using Common.Interfaces;

namespace Mapping.Interfaces
{
    [DataContract]
    public sealed class OfferMapItem : MapItem
    {
        public OfferMapItem(
            MapItemStatus status,
            GeoLocation location,
            string offerId,
            string userId) : base(status, location)
        {
            this.OfferId = offerId;
            this.UserId = userId;
        }

        [DataMember]
        public string OfferId { get; private set; }

        [DataMember]
        public string UserId { get; private set; }
    }
}
