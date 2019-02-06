using API.Interfaces;
using Common.Interfaces;

namespace API.Services
{
    public static class GeoLocationExtensions
    {
        public static GeoLocationDto ToDto(this GeoLocation @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new GeoLocationDto
            {
                Latitude = @this.Latitude,
                Longitude = @this.Longitude,
            };

            return result;
        }

        public static GeoLocation ToServiceObject(this GeoLocationDto @this)
        {
            if (@this == null)
            {
                return null;
            }

            return new GeoLocation(
                @this.Latitude,
                @this.Longitude);
        }
    }
}
