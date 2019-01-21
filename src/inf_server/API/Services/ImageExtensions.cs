using System.Collections.Immutable;
using System.Linq;
using API.Interfaces;
using Google.Protobuf;
using User.Interfaces;

namespace API.Services
{
    public static class ImageExtensions
    {
        public static ImageDto ToDto(this Image @this)
        {
            if (@this == null)
            {
                return null;
            }

            return new ImageDto
            {
                Url = @this.Uri,
                LowResData = @this.LowResData == null ? null : ByteString.CopyFrom(@this.LowResData.ToArray()),
            };
        }

        public static Image ToService(this ImageDto @this)
        {
            if (@this == null)
            {
                return null;
            }

            return new Image(
                @this.Url,
                @this.LowResData?.ToImmutableList());
        }
    }
}
