﻿using Users.Interfaces;

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
                @this.LowResData);
        }

        public static ImageEntity ToEntity(this Image @this)
        {
            if (@this == null)
            {
                return null;
            }

            return new ImageEntity(
                @this.Uri,
                @this.LowResData);
        }
    }
}
