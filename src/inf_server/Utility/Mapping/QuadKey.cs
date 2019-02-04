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

        // 6 LSBs hold the level of detail (6 bits is more than enough, but 5 is too few)
        // Bits 7 and 8 hold level 1 value, bits 9 and 10 level 2, etcetera.
        private readonly ulong rawValue;

        public QuadKey(ulong rawValue)
        {
            this.rawValue = rawValue;
        }

        public ulong RawValue => this.rawValue;

        public bool IsValid => this.LevelCount > 0 && this.LevelCount <= 29 &&  (this.LevelCount == 29 || (this.rawValue >> (6 + this.LevelCount * 2) == 0));

        public int LevelCount => (int)(this.rawValue & 0b111111);

        // Gets the parent QuadKey, which will be QuadKey.Default if LevelCount is 1.
        public QuadKey Parent
        {
            get
            {
                EnsureValid();

                if (this.LevelCount == 1)
                {
                    return QuadKey.Default;
                }

                var newRawValue = SetQuadValue(this.rawValue, this.LevelCount - 1, 0);
                newRawValue &= ~0b111111UL;
                newRawValue |= (uint)(this.LevelCount - 1);
                return new QuadKey(newRawValue);
            }
        }

        // Gets the QuadKey to the north of this QuadKey, which will be QuadKey.Default if there is no QuadKey further north.
        public QuadKey North
        {
            get
            {
                EnsureValid();

                var newRawValue = this.rawValue;
                var currentQuadKey = this;

                while (true)
                {
                    var currentQuadValue = GetQuadValue(newRawValue, currentQuadKey.LevelCount - 1);
                    var isOnNorthernEdge = currentQuadValue == 0 || currentQuadValue == 1;

                    if (isOnNorthernEdge)
                    {
                        if (currentQuadKey.LevelCount == 1)
                        {
                            // Can't go any further north
                            return QuadKey.Default;
                        }

                        // For quads on the northern edge, 0s change to 2, 1s change to 3
                        newRawValue = SetQuadValue(newRawValue, currentQuadKey.LevelCount - 1, currentQuadValue == 0 ? 2 : 3);
                        currentQuadKey = currentQuadKey.Parent;
                    }
                    else
                    {
                        // For quads that are not on the northern edge, 2s change to 0, 3s change 1 (and we're done at this point)
                        newRawValue = SetQuadValue(newRawValue, currentQuadKey.LevelCount - 1, currentQuadValue == 2 ? 0 : 1);
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
                EnsureValid();

                var newRawValue = this.rawValue;
                var currentQuadKey = this;

                while (true)
                {
                    var currentQuadValue = GetQuadValue(newRawValue, currentQuadKey.LevelCount - 1);
                    var isOnSouthernEdge = currentQuadValue == 2 || currentQuadValue == 3;

                    if (isOnSouthernEdge)
                    {
                        if (currentQuadKey.LevelCount == 1)
                        {
                            // Can't go any further south
                            return QuadKey.Default;
                        }

                        // For quads on the southern edge, 2s change to 0, 3s change to 1
                        newRawValue = SetQuadValue(newRawValue, currentQuadKey.LevelCount - 1, currentQuadValue == 2 ? 0 : 1);
                        currentQuadKey = currentQuadKey.Parent;
                    }
                    else
                    {
                        // For quads that are not on the southern edge, 0s change to 2, 1s change 3 (and we're done at this point)
                        newRawValue = SetQuadValue(newRawValue, currentQuadKey.LevelCount - 1, currentQuadValue == 0 ? 2 : 3);
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
                EnsureValid();

                var newRawValue = this.rawValue;
                var currentQuadKey = this;

                while (true)
                {
                    var currentQuadValue = GetQuadValue(newRawValue, currentQuadKey.LevelCount - 1);
                    var isOnEasternEdge = currentQuadValue == 1 || currentQuadValue == 3;

                    if (isOnEasternEdge)
                    {
                        if (currentQuadKey.LevelCount == 1)
                        {
                            // Can't go any further east
                            return QuadKey.Default;
                        }

                        // For quads on the eastern edge, 1s change to 0, 3s change to 2
                        newRawValue = SetQuadValue(newRawValue, currentQuadKey.LevelCount - 1, currentQuadValue == 1 ? 0 : 2);
                        currentQuadKey = currentQuadKey.Parent;
                    }
                    else
                    {
                        // For quads that are not on the eastern edge, 0s change to 1, 2s change 3 (and we're done at this point)
                        newRawValue = SetQuadValue(newRawValue, currentQuadKey.LevelCount - 1, currentQuadValue == 0 ? 1 : 3);
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
                EnsureValid();

                var newRawValue = this.rawValue;
                var currentQuadKey = this;

                while (true)
                {
                    var currentQuadValue = GetQuadValue(newRawValue, currentQuadKey.LevelCount - 1);
                    var isOnWesternEdge = currentQuadValue == 0 || currentQuadValue == 2;

                    if (isOnWesternEdge)
                    {
                        if (currentQuadKey.LevelCount == 1)
                        {
                            // Can't go any further west
                            return QuadKey.Default;
                        }

                        // For quads on the western edge, 0s change to 1, 2s change to 3
                        newRawValue = SetQuadValue(newRawValue, currentQuadKey.LevelCount - 1, currentQuadValue == 0 ? 1 : 3);
                        currentQuadKey = currentQuadKey.Parent;
                    }
                    else
                    {
                        // For quads that are not on the western edge, 1s change to 0, 3s change 2 (and we're done at this point)
                        newRawValue = SetQuadValue(newRawValue, currentQuadKey.LevelCount - 1, currentQuadValue == 1 ? 0 : 2);
                        break;
                    }
                }

                return new QuadKey(newRawValue);
            }
        }

        // Gets the four child QuadKeys for this QuadKey.
        public IEnumerable<QuadKey> GetChildren()
        {
            EnsureValid();

            var newLevel = this.LevelCount + 1;
            var newRawValue = this.rawValue;
            newRawValue &= ~0b111111UL;
            newRawValue |= (uint)newLevel;

            // 0
            newRawValue = SetQuadValue(newRawValue, this.LevelCount, 0);
            yield return new QuadKey(newRawValue);

            // 1
            newRawValue = SetQuadValue(newRawValue, this.LevelCount, 1);
            yield return new QuadKey(newRawValue);

            // 2
            newRawValue = SetQuadValue(newRawValue, this.LevelCount, 2);
            yield return new QuadKey(newRawValue);

            // 3
            newRawValue = SetQuadValue(newRawValue, this.LevelCount, 3);
            yield return new QuadKey(newRawValue);
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

            var result = new char[this.LevelCount];

            for (var i = 0; i < this.LevelCount; ++i)
            {
                var quadValue = GetQuadValue(rawValue, i);
                var ch = (char)('0' + quadValue);
                result[i] = ch;
            }

            return new string(result);
        }

        public static QuadKey From(double latitude, double longitude, int level)
        {
            GetPixelCoordinatesFromLatLong(latitude, longitude, level, out var pixelX, out var pixelY);
            GetTileCoordinatesFromPixelCoordinates(pixelX, pixelY, out var tileX, out var tileY);
            var rawValue = GetRawValueFromTileCoordinates(tileX, tileY, level);
            return new QuadKey(rawValue);
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
            if (string.IsNullOrEmpty(input))
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
            northWest.EnsureValid();
            southEast.EnsureValid();

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

        private void EnsureValid()
        {
            if (!this.IsValid)
            {
                throw new InvalidOperationException("QuadKey is not valid.");
            }
        }

        // Get a level-sensitive distance from the western edge for this QuadKey. For example, a return value of 0 means it is on
        // the western edge, a value of 2 means it is the third QuadKey from the western edge.
        private int GetDistanceFromWesternEdge()
        {
            var distance = 0;

            for (var i = 0; i < this.LevelCount; ++i)
            {
                var currentQuadValue = GetQuadValue(this.rawValue, i);

                if (currentQuadValue == 1 || currentQuadValue == 3)
                {
                    distance += (int)Math.Pow(2, this.LevelCount - i - 1);
                }
            }

            return distance;
        }

        // Get a level-sensitive distance from the northern edge for this QuadKey. For example, a return value of 0 means it is on
        // the northern edge, a value of 2 means it is the third QuadKey from the northern edge.
        private int GetDistanceFromNorthernEdge()
        {
            var distance = 0;

            for (var i = 0; i < this.LevelCount; ++i)
            {
                var currentQuadValue = GetQuadValue(this.rawValue, i);

                if (currentQuadValue == 2 || currentQuadValue == 3)
                {
                    distance += (int)Math.Pow(2, this.LevelCount - i - 1);
                }
            }

            return distance;
        }

        // Get the value (0, 1, 2, or 3) for an individual quad. Quad numbers start at 0 (the most significant) and run up to Level - 1.
        private static ulong GetQuadValue(ulong rawValue, int quadNumber)
        {
            Debug.Assert(quadNumber >= 0 && quadNumber <= 29);
            var maskedValue = rawValue & (0b11UL << (6 + quadNumber * 2));
            return maskedValue >> (6 + quadNumber * 2);
        }

        // Sets the value (0, 1, 2, 3) for an individual quad.
        private static ulong SetQuadValue(ulong rawValue, int quadNumber, int value)
        {
            Debug.Assert(quadNumber >= 0 && quadNumber <= 29);
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
    }
}
