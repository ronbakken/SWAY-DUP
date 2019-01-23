using System.Collections.Immutable;
using System.Runtime.Serialization;

namespace Users.Interfaces
{
    [DataContract]
    public sealed class Image
    {
        public Image(
            string uri,
            ImmutableList<byte> lowResData)
        {
            this.Uri = uri;
            this.LowResData = lowResData;
        }

        [DataMember]
        public string Uri { get; private set; }

        [DataMember]
        public ImmutableList<byte> LowResData { get; private set; }
    }
}
