﻿using API.Interfaces;
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

            return new LocationDto
            {
                Latitude = @this.Latitude,
                Longitude = @this.Longitude,
                Name = @this.Name,
            };
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
