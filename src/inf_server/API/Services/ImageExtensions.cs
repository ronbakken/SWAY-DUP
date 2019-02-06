using System.Linq;
using API.Interfaces;
using Common.Interfaces;
using Google.Protobuf;

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

            var result = new ImageDto();

            if (@this.Uri != null)
            {
                result.Url = @this.Uri;
            }

            if (@this.LowResData != null)
            {
                result.LowResData = ByteString.CopyFrom(@this.LowResData.ToArray());
            }

            return result;
        }

        public static Image ToServiceObject(this ImageDto @this)
        {
            if (@this == null)
            {
                return null;
            }

            return new Image(
                @this.Url,
                @this.LowResData?.ToList());
        }
    }
}
