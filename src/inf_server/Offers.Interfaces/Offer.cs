using System.Runtime.Serialization;
using Common.Interfaces;

namespace Offers.Interfaces
{
    [DataContract]
    public sealed class Offer
    {
        public Offer(
            string id,
            OfferStatus status,
            string userId,
            GeoLocation location)
        {
            this.Id = id;
            this.Status = status;
            this.UserId = userId;
            this.Location = location;
        }

        [DataMember]
        public string Id { get; private set; }

        [DataMember]
        public OfferStatus Status { get; private set; }

        [DataMember]
        public string UserId { get; private set; }

        [DataMember]
        public GeoLocation Location { get; private set; }
    }
}
