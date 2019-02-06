using System.Linq;
using API.Interfaces;
using API.Services.Auth;
using Users.Interfaces;

namespace API.Services.Users
{
    public static class SearchFilterExtensions
    {
        public static SearchFilter ToServiceObject(this SearchUsersRequest @this)
        {
            if (@this == null)
            {
                return null;
            }

            SearchLocation searchLocation = null;

            if (@this.Location?.GeoPoint != null && @this.LocationDistanceKms > 0)
            {
                searchLocation = new SearchLocation(@this.Location.GeoPoint.Latitude, @this.Location.GeoPoint.Longitude, @this.LocationDistanceKms);
            }

            var userTypes = UserTypes.All;

            foreach (var userType in @this.UserTypes)
            {
                userTypes |= userType.ToServiceObject().ValueFor();
            }

            return new SearchFilter(
                userTypes,
                @this.Categories.ToList(),
                @this.SocialMediaNetworkIds.ToList(),
                searchLocation,
                @this.MinimumValue == 0 ? (int?)null : @this.MinimumValue,
                @this.Phrase);
        }
    }
}
