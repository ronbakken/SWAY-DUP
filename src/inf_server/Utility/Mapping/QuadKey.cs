using System;
using System.Text;
using Genesis.Ensure;

namespace Utility.Mapping
{
    public sealed class QuadKey : IEquatable<QuadKey>
    {
        private readonly string value;

        public QuadKey(string value)
        {
            if (string.IsNullOrEmpty(value))
            {
                throw new ArgumentException(nameof(value));
            }

            for (var i = 0; i < value.Length; ++i)
            {
                var ch = value[i];

                if (ch < '0' || ch > '3')
                {
                    throw new ArgumentException(nameof(value));
                }
            }

            this.value = value;
        }

        public QuadKey(double latitude, double longitude, int level)
        {
            GetPixelCoordinatesFromLatLong(latitude, longitude, level, out var pixelX, out var pixelY);
            GetTileCoordinatesFromPixelCoordinates(pixelX, pixelY, out var tileX, out var tileY);
            this.value = GetQuadKeyFromTileCoordinates(tileX, tileY, level);
        }

        public string Value => this.value;

        public bool Contains(QuadKey other)
        {
            Ensure.ArgumentNotNull(other, nameof(other));
            return other.value.StartsWith(this.value);
        }

        public bool Equals(QuadKey other) =>
            string.Equals(this.value, other?.value);

        public override bool Equals(object obj)
        {
            if (obj is QuadKey other)
            {
                return this.Equals(other);
            }

            return false;
        }

        public override int GetHashCode() =>
            this.value.GetHashCode();

        public override string ToString() =>
            this.value;

        // Everything below is largely based on https://docs.microsoft.com/en-us/bingmaps/articles/bing-maps-tile-system.
        private const double earthRadius = 6378137;
        private const double minLatitude = -85.05112878;
        private const double maxLatitude = 85.05112878;
        private const double minLongitude = -180;
        private const double maxLongitude = 180;

        private static double Clamp(double n, double minValue, double maxValue) =>
            Math.Min(Math.Max(n, minValue), maxValue);

        private static uint MapSize(int levelOfDetail) =>
            (uint)256 << levelOfDetail;

        private static void GetPixelCoordinatesFromLatLong(double latitude, double longitude, int levelOfDetail, out int pixelX, out int pixelY)
        {
            latitude = Clamp(latitude, minLatitude, maxLatitude);
            longitude = Clamp(longitude, minLongitude, maxLongitude);

            var x = (longitude + 180) / 360;
            var sinLatitude = Math.Sin(latitude * Math.PI / 180);
            var y = 0.5 - Math.Log((1 + sinLatitude) / (1 - sinLatitude)) / (4 * Math.PI);

            var mapSize = MapSize(levelOfDetail);
            pixelX = (int)Clamp(x * mapSize + 0.5, 0, mapSize - 1);
            pixelY = (int)Clamp(y * mapSize + 0.5, 0, mapSize - 1);
        }

        private static void GetTileCoordinatesFromPixelCoordinates(int pixelX, int pixelY, out int tileX, out int tileY)
        {
            tileX = pixelX / 256;
            tileY = pixelY / 256;
        }

        private static string GetQuadKeyFromTileCoordinates(int tileX, int tileY, int levelOfDetail)
        {
            var quadKey = new StringBuilder();

            for (int i = levelOfDetail; i > 0; i--)
            {
                var digit = '0';
                var mask = 1 << (i - 1);

                if ((tileX & mask) != 0)
                {
                    digit++;
                }

                if ((tileY & mask) != 0)
                {
                    digit++;
                    digit++;
                }

                quadKey.Append(digit);
            }

            return quadKey.ToString();
        }
    }
}
