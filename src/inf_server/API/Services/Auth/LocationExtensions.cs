using API.Interfaces;
using Users.Interfaces;

namespace API.Services.Auth
{
    public static class LocationExtensions
    {
        public static LocationDto ToDto(this Location @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new LocationDto
            {
                Latitude = @this.Latitude,
                Longitude = @this.Longitude,
            };

            if (@this.Name != null)
            {
                result.Name = @this.Name;
            }

            return result;
        }

        public static Location ToServiceObject(this LocationDto @this)
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
    }
}
