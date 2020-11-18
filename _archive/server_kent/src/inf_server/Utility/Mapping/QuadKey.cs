using System;
using System.Collections.Generic;
using System.Diagnostics;

namespace Utility.Mapping
{
    // See https://docs.microsoft.com/en-us/bingmaps/articles/bing-maps-tile-system.
    public struct QuadKey : IEquatable<QuadKey>
    {
        // A default, invalid, instance of QuadKey.
        public static readonly QuadKey Default = new QuadKey();

        // The maximum level of detail that can be represented by a QuadKey.
        public const int MaximumLevelOfDetail = 23;

        // 6 LSBs hold the level of detail (6 bits is more than enough, but 4 is too few)
        // Bits 7 and 8 hold level 1 value, bits 9 and 10 level 2, etcetera.
        private readonly ulong rawValue;

        public QuadKey(ulong rawValue)
        {
            this.rawValue = rawValue;
        }

        public ulong RawValue => this.rawValue;

        public bool IsValid => this.LevelOfDetail > 0 && this.LevelOfDetail <= MaximumLevelOfDetail &&  (this.LevelOfDetail == MaximumLevelOfDetail || (this.rawValue >> (6 + this.LevelOfDetail * 2) == 0));

        public int LevelOfDetail => (int)(this.rawValue & 0b111111);

        // Gets the parent QuadKey, which will be QuadKey.Default if LevelOfDetail is 1.
        public QuadKey Parent
        {
            get
            {
                if (this.LevelOfDetail == 1)
                {
                    return QuadKey.Default;
                }

                var newRawValue = SetQuadValue(this.rawValue, this.LevelOfDetail - 1, 0);
                newRawValue &= ~0b111111UL;
                newRawValue |= (uint)(this.LevelOfDetail - 1);
                return new QuadKey(newRawValue);
            }
        }

        // Gets the QuadKey to the north of this QuadKey, which will be QuadKey.Default if there is no QuadKey further north.
        public QuadKey North
        {
            get
            {
                var newRawValue = this.rawValue;
                var currentQuadKey = this;

                while (true)
                {
                    var currentQuadValue = GetQuadValue(newRawValue, currentQuadKey.LevelOfDetail - 1);
                    var isOnNorthernEdge = currentQuadValue == 0 || currentQuadValue == 1;

                    if (isOnNorthernEdge)
                    {
                        if (currentQuadKey.LevelOfDetail == 1)
                        {
                            // Can't go any further north
                            return QuadKey.Default;
                        }

                        // For quads on the northern edge, 0s change to 2, 1s change to 3
                        newRawValue = SetQuadValue(newRawValue, currentQuadKey.LevelOfDetail - 1, currentQuadValue == 0 ? 2 : 3);
                        currentQuadKey = currentQuadKey.Parent;
                    }
                    else
                    {
                        // For quads that are not on the northern edge, 2s change to 0, 3s change 1 (and we're done at this point)
                        newRawValue = SetQuadValue(newRawValue, currentQuadKey.LevelOfDetail - 1, currentQuadValue == 2 ? 0 : 1);
                        break;
                    }
                }

                return new QuadKey(newRawValue);
            }
        }

        // Gets the QuadKey to the south of this QuadKey, which will be QuadKey.Default if there is no QuadKey further south.
        public QuadKey South
        {
            get
            {
                var newRawValue = this.rawValue;
                var currentQuadKey = this;

                while (true)
                {
                    var currentQuadValue = GetQuadValue(newRawValue, currentQuadKey.LevelOfDetail - 1);
                    var isOnSouthernEdge = currentQuadValue == 2 || currentQuadValue == 3;

                    if (isOnSouthernEdge)
                    {
                        if (currentQuadKey.LevelOfDetail == 1)
                        {
                            // Can't go any further south
                            return QuadKey.Default;
                        }

                        // For quads on the southern edge, 2s change to 0, 3s change to 1
                        newRawValue = SetQuadValue(newRawValue, currentQuadKey.LevelOfDetail - 1, currentQuadValue == 2 ? 0 : 1);
                        currentQuadKey = currentQuadKey.Parent;
                    }
                    else
                    {
                        // For quads that are not on the southern edge, 0s change to 2, 1s change 3 (and we're done at this point)
                        newRawValue = SetQuadValue(newRawValue, currentQuadKey.LevelOfDetail - 1, currentQuadValue == 0 ? 2 : 3);
                        break;
                    }
                }

                return new QuadKey(newRawValue);
            }
        }

        // Gets the QuadKey to the east of this QuadKey, which will be QuadKey.Default if there is no QuadKey further east.
        public QuadKey East
        {
            get
            {
                var newRawValue = this.rawValue;
                var currentQuadKey = this;

                while (true)
                {
                    var currentQuadValue = GetQuadValue(newRawValue, currentQuadKey.LevelOfDetail - 1);
                    var isOnEasternEdge = currentQuadValue == 1 || currentQuadValue == 3;

                    if (isOnEasternEdge)
                    {
                        if (currentQuadKey.LevelOfDetail == 1)
                        {
                            // Can't go any further east
                            return QuadKey.Default;
                        }

                        // For quads on the eastern edge, 1s change to 0, 3s change to 2
                        newRawValue = SetQuadValue(newRawValue, currentQuadKey.LevelOfDetail - 1, currentQuadValue == 1 ? 0 : 2);
                        currentQuadKey = currentQuadKey.Parent;
                    }
                    else
                    {
                        // For quads that are not on the eastern edge, 0s change to 1, 2s change 3 (and we're done at this point)
                        newRawValue = SetQuadValue(newRawValue, currentQuadKey.LevelOfDetail - 1, currentQuadValue == 0 ? 1 : 3);
                        break;
                    }
                }

                return new QuadKey(newRawValue);
            }
        }

        // Gets the QuadKey to the west of this QuadKey, which will be QuadKey.Default if there is no QuadKey further west.
        public QuadKey West
        {
            get
            {
                var newRawValue = this.rawValue;
                var currentQuadKey = this;

                while (true)
                {
                    var currentQuadValue = GetQuadValue(newRawValue, currentQuadKey.LevelOfDetail - 1);
                    var isOnWesternEdge = currentQuadValue == 0 || currentQuadValue == 2;

                    if (isOnWesternEdge)
                    {
                        if (currentQuadKey.LevelOfDetail == 1)
                        {
                            // Can't go any further west
                            return QuadKey.Default;
                        }

                        // For quads on the western edge, 0s change to 1, 2s change to 3
                        newRawValue = SetQuadValue(newRawValue, currentQuadKey.LevelOfDetail - 1, currentQuadValue == 0 ? 1 : 3);
                        currentQuadKey = currentQuadKey.Parent;
                    }
                    else
                    {
                        // For quads that are not on the western edge, 1s change to 0, 3s change 2 (and we're done at this point)
                        newRawValue = SetQuadValue(newRawValue, currentQuadKey.LevelOfDetail - 1, currentQuadValue == 1 ? 0 : 2);
                        break;
                    }
                }

                return new QuadKey(newRawValue);
            }
        }

        public QuadKey NorthWestChild => GetChild(0);

        public QuadKey NorthEastChild => GetChild(1);

        public QuadKey SouthWestChild => GetChild(2);

        public QuadKey SouthEastChild => GetChild(3);

        private QuadKey GetChild(int quadrant)
        {
            if (this.LevelOfDetail == MaximumLevelOfDetail)
            {
                return QuadKey.Default;
            }

            var newLevelOfDetail = this.LevelOfDetail + 1;
            var newRawValue = this.rawValue;
            newRawValue &= ~0b111111UL;
            newRawValue |= (uint)newLevelOfDetail;

            newRawValue = SetQuadValue(newRawValue, this.LevelOfDetail, quadrant);
            return new QuadKey(newRawValue);
        }

        // Gets the four child QuadKeys for this QuadKey.
        public IEnumerable<QuadKey> GetChildren()
        {
            yield return this.NorthWestChild;
            yield return this.NorthEastChild;
            yield return this.SouthWestChild;
            yield return this.SouthEastChild;
        }

        public QuadKey TruncateTo(int levelOfDetail)
        {
            if (this.LevelOfDetail < levelOfDetail)
            {
                throw new ArgumentException($"Cannot truncate to level of detail {levelOfDetail} because this quad key is at level of detail {this.LevelOfDetail}.", nameof(levelOfDetail));
            }

            var newRawValue = this.rawValue;

            // First, clear out the quad values we don't need.
            var bitShift = 64 - 6 - (levelOfDetail * 2);
            newRawValue = newRawValue << bitShift >> bitShift;

            // Second, update the level.
            newRawValue &= ~0b111111UL;
            newRawValue |= (uint)levelOfDetail;

            return new QuadKey(newRawValue);
        }

        public bool Equals(QuadKey other) =>
            this.rawValue == other.rawValue;

        public override bool Equals(object obj)
        {
            if (obj is QuadKey other)
            {
                return this.Equals(other);
            }

            return false;
        }

        public override int GetHashCode() =>
            this.rawValue.GetHashCode();

        public override string ToString()
        {
            if (!this.IsValid)
            {
                return "<<invalid>>";
            }

            var result = new char[this.LevelOfDetail];

            for (var i = 0; i < this.LevelOfDetail; ++i)
            {
                var quadValue = GetQuadValue(rawValue, i);
                var ch = (char)('0' + quadValue);
                result[i] = ch;
            }

            return new string(result);
        }

        public string ToDebugString()
        {
            var binary = Convert
                .ToString((long)this.rawValue, 2)
                .PadLeft(64, '0')
                .Insert(64 - 6, " ");
            return binary + " (" + this.ToString() + ")";
        }

        public static QuadKey From(double latitude, double longitude, int levelOfDetail)
        {
            if (levelOfDetail > MaximumLevelOfDetail)
            {
                return QuadKey.Default;
            }

            // NOTE: the use of the maximum level followed by truncation to desired level is entirely deliberate.
            //       It works around a rounding issue in the tile system logic. See https://social.msdn.microsoft.com/Forums/sqlserver/en-US/42504e3e-e265-49b5-8912-477dbbd6d7f5/what-to-do-about-rounding-errors-in-tilesystem?forum=bingmaps
            GetPixelCoordinatesFromLatLong(latitude, longitude, QuadKey.MaximumLevelOfDetail, out var pixelX, out var pixelY);
            GetTileCoordinatesFromPixelCoordinates(pixelX, pixelY, out var tileX, out var tileY);
            var rawValue = GetRawValueFromTileCoordinates(tileX, tileY, QuadKey.MaximumLevelOfDetail);
            var quadAtMaximumLevelOfDetail = new QuadKey(rawValue);
            var result = quadAtMaximumLevelOfDetail.TruncateTo(levelOfDetail);
            return result;
        }

        public static QuadKey Parse(string input)
        {
            if (!TryParse(input, out var result))
            {
                throw new FormatException();
            }

            return result;
        }

        public static bool TryParse(string input, out QuadKey result)
        {
            if (string.IsNullOrEmpty(input) || input.Length > MaximumLevelOfDetail)
            {
                result = QuadKey.Default;
                return false;
            }

            var rawValue = 0UL;

            for (var i = 0; i < input.Length; ++i)
            {
                var ch = input[i];
                var value = ch - '0';

                if (value < 0 || value > 3)
                {
                    result = QuadKey.Default;
                    return false;
                }

                rawValue = SetQuadValue(rawValue, i, value);
            }

            rawValue |= (uint)input.Length;
            result = new QuadKey(rawValue);
            return result.IsValid;
        }

        // Get all QuadKeys in a 2D range.
        public static IEnumerable<QuadKey> GetRange(QuadKey northWest, QuadKey southEast)
        {
            var nwQuadKeyCoords = (x: northWest.GetDistanceFromWesternEdge(), y: northWest.GetDistanceFromNorthernEdge());
            var seQuadKeyCoords = (x: southEast.GetDistanceFromWesternEdge(), y: southEast.GetDistanceFromNorthernEdge());

            if (nwQuadKeyCoords.x > seQuadKeyCoords.x || nwQuadKeyCoords.y > seQuadKeyCoords.y)
            {
                throw new ArgumentException("northWest must be north-west of southEast.");
            }

            var currentQuadKey = northWest;

            for (var i = nwQuadKeyCoords.y; i <= seQuadKeyCoords.y; ++i)
            {
                var snapshot = currentQuadKey;

                for (var j = nwQuadKeyCoords.x; j <= seQuadKeyCoords.x; ++j)
                {
                    yield return currentQuadKey;
                    currentQuadKey = currentQuadKey.East;
                }

                currentQuadKey = snapshot.South;
            }
        }

        public void GetBoundingGeoPoints(out double northWestLatitude, out double northWestLongitude, out double southEastLatitude, out double southEastLongitude)
        {
            GetTileCoordinatesFromQuadKey(this, out var tileX, out var tileY, out var levelOfDetail);
            GetPixelCoordinatesFromTileCoordinates(tileX, tileY, out var pixelX, out var pixelY);
            GetLatLongFromPixelCoordinates(pixelX, pixelY, levelOfDetail, out northWestLatitude, out northWestLongitude);

            GetPixelCoordinatesFromTileCoordinates(tileX + 1, tileY + 1, out pixelX, out pixelY);
            GetLatLongFromPixelCoordinates(pixelX, pixelY, levelOfDetail, out southEastLatitude, out southEastLongitude);
        }

        private void EnsureValid()
        {
            if (!this.IsValid)
            {
                throw new InvalidOperationException("QuadKey is not valid.");
            }
        }

        // Get a level-of-detail-sensitive distance from the western edge for this QuadKey. For example, a return value of 0 means it is on
        // the western edge, a value of 2 means it is the third QuadKey from the western edge.
        private int GetDistanceFromWesternEdge()
        {
            var distance = 0;

            for (var i = 0; i < this.LevelOfDetail; ++i)
            {
                var currentQuadValue = GetQuadValue(this.rawValue, i);

                if (currentQuadValue == 1 || currentQuadValue == 3)
                {
                    distance += (int)Math.Pow(2, this.LevelOfDetail - i - 1);
                }
            }

            return distance;
        }

        // Get a level-of-detail-sensitive distance from the northern edge for this QuadKey. For example, a return value of 0 means it is on
        // the northern edge, a value of 2 means it is the third QuadKey from the northern edge.
        private int GetDistanceFromNorthernEdge()
        {
            var distance = 0;

            for (var i = 0; i < this.LevelOfDetail; ++i)
            {
                var currentQuadValue = GetQuadValue(this.rawValue, i);

                if (currentQuadValue == 2 || currentQuadValue == 3)
                {
                    distance += (int)Math.Pow(2, this.LevelOfDetail - i - 1);
                }
            }

            return distance;
        }

        // Get the value (0, 1, 2, or 3) for an individual quad. Quad numbers start at 0 (the most significant) and run up to LevelOfDetail - 1.
        private static ulong GetQuadValue(ulong rawValue, int quadNumber)
        {
            Debug.Assert(quadNumber >= 0 && quadNumber <= MaximumLevelOfDetail);
            var maskedValue = rawValue & (0b11UL << (6 + quadNumber * 2));
            return maskedValue >> (6 + quadNumber * 2);
        }

        // Sets the value (0, 1, 2, 3) for an individual quad.
        private static ulong SetQuadValue(ulong rawValue, int quadNumber, int value)
        {
            Debug.Assert(quadNumber >= 0 && quadNumber < MaximumLevelOfDetail);
            Debug.Assert(value >= 0 && value <= 3);
            var newRawValue = rawValue;
            newRawValue &= ~(0b11UL << (6 + quadNumber * 2));
            newRawValue |= (ulong)value << (6 + quadNumber * 2);
            return newRawValue;
        }

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

        private static void GetPixelCoordinatesFromTileCoordinates(int tileX, int tileY, out int pixelX, out int pixelY)
        {
            pixelX = tileX * 256;
            pixelY = tileY * 256;
        }

        private static void GetLatLongFromPixelCoordinates(int pixelX, int pixelY, int levelOfDetail, out double latitude, out double longitude)
        {
            var mapSize = MapSize(levelOfDetail);
            var x = (Clamp(pixelX, 0, mapSize - 1) / mapSize) - 0.5;
            var y = 0.5 - (Clamp(pixelY, 0, mapSize - 1) / mapSize);

            latitude = 90 - 360 * Math.Atan(Math.Exp(-y * 2 * Math.PI)) / Math.PI;
            longitude = 360 * x;
        }

        private static ulong GetRawValueFromTileCoordinates(int tileX, int tileY, int levelOfDetail)
        {
            var rawValue = 0UL;

            for (int i = levelOfDetail; i > 0; i--)
            {
                var value = 0UL;
                var mask = 1 << (i - 1);

                if ((tileX & mask) != 0)
                {
                    value++;
                }

                if ((tileY & mask) != 0)
                {
                    value++;
                    value++;
                }

                var invertI = levelOfDetail - i;
                rawValue |= (value << (6 + invertI * 2));
            }

            rawValue |= (uint)levelOfDetail;

            return rawValue;
        }

        public static void GetTileCoordinatesFromQuadKey(QuadKey quadKey, out int tileX, out int tileY, out int levelOfDetail)
        {
            tileX = 0;
            tileY = 0;
            levelOfDetail = quadKey.LevelOfDetail;

            for (int i = levelOfDetail; i > 0; i--)
            {
                var mask = 1 << (i - 1);
                var quadValue = GetQuadValue(quadKey.rawValue, levelOfDetail - i);

                switch (quadValue)
                {
                    case 0:
                        break;
                    case 1:
                        tileX |= mask;
                        break;
                    case 2:
                        tileY |= mask;
                        break;
                    case 3:
                        tileX |= mask;
                        tileY |= mask;
                        break;
                }
            }
        }
    }
}
