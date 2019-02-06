using System.Runtime.Serialization;
using Common.Interfaces;

namespace Offers.Interfaces
{
    [DataContract]
    public sealed class Offer
    {
        public Offer(
            string id,
            string userId,
            GeoLocation location)
        {
            this.Id = id;
            this.UserId = userId;
            this.Location = location;
        }

        [DataMember]
        public string Id { get; private set; }

        [DataMember]
        public string UserId { get; private set; }

        [DataMember]
        public GeoLocation Location { get; private set; }
    }
}
