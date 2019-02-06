using System.Collections.Immutable;
using System.Linq;
using Common.Interfaces;

namespace Users
{
    public static class ImageEntityExtensions
    {
        public static Image ToServiceObject(this ImageEntity @this)
        {
            if (@this == null)
            {
                return null;
            }

            return new Image(
                @this.Uri,
                @this.LowResData?.ToList());
        }

        public static ImageEntity ToEntity(this Image @this)
        {
            if (@this == null)
            {
                return null;
            }

            return new ImageEntity(
                @this.Uri,
                @this.LowResData?.ToImmutableList());
        }
    }
}
