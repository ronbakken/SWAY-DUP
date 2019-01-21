using System.Collections.Immutable;
using System.Runtime.Serialization;

namespace User.Interfaces
{
    [DataContract]
    public sealed class Avatar
    {
        public Avatar(
            string uri,
            string thumbnailUri,
            ImmutableList<byte> lowRes,
            ImmutableList<byte> thumbnailLowRes)
        {
            this.Uri = uri;
            this.ThumbnailUri = thumbnailUri;
            this.LowRes = lowRes;
            this.ThumbnailLowRes = thumbnailLowRes;
        }

        [DataMember]
        public string Uri { get; private set; }

        [DataMember]
        public string ThumbnailUri { get; private set; }

        [DataMember]
        public ImmutableList<byte> LowRes { get; private set; }

        [DataMember]
        public ImmutableList<byte> ThumbnailLowRes { get; private set; }
    }
}
