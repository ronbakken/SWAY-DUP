using System.Collections.Generic;
using System.Runtime.Serialization;

namespace Users.Interfaces
{
    [DataContract]
    public sealed class SearchResults
    {
        public SearchResults(
            int count,
            List<UserData> results)
        {
            this.Count = count;
            this.Results = results;
        }

        [DataMember]
        public int Count { get; private set; }

        [DataMember]
        public List<UserData> Results { get; private set; }
    }
}
