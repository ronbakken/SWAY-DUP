using System.Collections.Generic;
using System.Runtime.Serialization;

namespace Offers.Interfaces
{
    [DataContract]
    public sealed class ListOffersResult
    {
        public ListOffersResult(
            List<Offer> items,
            string continuationToken)
        {
            this.Items = items;
            this.ContinuationToken = continuationToken;
        }

        [DataMember]
        public List<Offer> Items { get; private set; }

        [DataMember]
        public string ContinuationToken { get; private set; }
    }
}
