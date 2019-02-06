using Common.Interfaces;

namespace Offers
{
    public static class GeoLocationEntityExtensions
    {
        public static GeoLocationEntity ToEntity(this GeoLocation @this)
        {
            if (@this == null)
            {
                return null;
            }

            return new GeoLocationEntity(
                @this.Latitude,
                @this.Longitude);
        }

        public static GeoLocation ToServiceObject(this GeoLocationEntity @this)
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
