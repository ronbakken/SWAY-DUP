using System.Collections.Generic;
using System.Runtime.Serialization;

namespace Common.Interfaces
{
    [DataContract]
    public sealed class Image
    {
        public Image(
            string uri,
            List<byte> lowResData)
        {
            this.Uri = uri;
            this.LowResData = lowResData;
        }

        [DataMember]
        public string Uri { get; private set; }

        [DataMember]
        public List<byte> LowResData { get; private set; }
    }
}
