﻿using API.Interfaces;
using User.Interfaces;

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

            return new LocationDto
            {
                Description = @this.Description,
                Latitude = @this.Latitude,
                Longitude = @this.Longitude,
                Name = @this.Name,
            };
        }

        public static Location ToService(this LocationDto @this)
        {
            if (@this == null)
            {
                return null;
            }

            return new Location(
                @this.Name,
                @this.Description,
                @this.Latitude,
                @this.Longitude);
        }
    }
}
