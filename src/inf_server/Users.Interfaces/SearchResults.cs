using System.Collections.Immutable;
using System.Runtime.Serialization;

namespace Users.Interfaces
{
    [DataContract]
    public sealed class SearchResults
    {
        public SearchResults(
            int count,
            ImmutableList<UserData> results)
        {
            this.Count = count;
            this.Results = results;
        }

        [DataMember]
        public int Count { get; private set; }

        [DataMember]
        public ImmutableList<UserData> Results { get; private set; }
    }
}
