using System.Runtime.Serialization;
using Utility.Mapping;

namespace Mapping.Interfaces
{
    [DataContract]
    public sealed class SearchFilter
    {
        public SearchFilter(
            MapItemTypes itemTypes,
            string quadKey)
        {
            this.ItemTypes = itemTypes;
            this.QuadKey = quadKey;
        }

        [DataMember]
        public MapItemTypes ItemTypes { get; private set; }

        [DataMember]
        public string QuadKey { get; private set; }
    }
}
