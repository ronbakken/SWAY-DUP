using System.Runtime.Serialization;
using Common.Interfaces;

namespace Mapping.Interfaces
{
    [DataContract]
    public sealed class OfferMapItem
    {
        public OfferMapItem(
            string offerId,
            string userId,
            GeoLocation location)
        {
            this.OfferId = offerId;
            this.UserId = userId;
            this.Location = location;
        }

        [DataMember]
        public string OfferId { get; private set; }

        [DataMember]
        public string UserId { get; private set; }

        [DataMember]
        public GeoLocation Location { get; private set; }
    }
}
