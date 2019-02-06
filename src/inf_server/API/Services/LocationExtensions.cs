using API.Interfaces;
using Common.Interfaces;

namespace API.Services
{
    public static class LocationExtensions
    {
        public static LocationDto ToDto(this Location @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new LocationDto();

            if (@this.Name != null)
            {
                result.Name = @this.Name;
            }

            if (@this.GeoLocation != null)
            {
                result.GeoLocation = @this.GeoLocation.ToDto();
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
                @this.GeoLocation.ToServiceObject());
        }
    }
}
