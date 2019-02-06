using Common.Interfaces;

namespace Users
{
    public static class LocationEntityExtensions
    {
        public static Location ToServiceObject(this LocationEntity @this)
        {
            if (@this == null)
            {
                return null;
            }

            return new Location(
                @this.Name,
                new GeoLocation(@this.Latitude, @this.Longitude));
        }

        public static LocationEntity ToEntity(this Location @this)
        {
            if (@this == null)
            {
                return null;
            }

            return new LocationEntity(
                @this.Name,
                @this.GeoLocation?.Latitude ?? 0,
                @this.GeoLocation?.Longitude ?? 0);
        }
    }
}
