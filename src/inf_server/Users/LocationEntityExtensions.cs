using Users.Interfaces;

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
                @this.Latitude,
                @this.Longitude);
        }

        public static LocationEntity ToEntity(this Location @this)
        {
            if (@this == null)
            {
                return null;
            }

            return new LocationEntity(
                @this.Name,
                @this.Latitude,
                @this.Longitude);
        }
    }
}
