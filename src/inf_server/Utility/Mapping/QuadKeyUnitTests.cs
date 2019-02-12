using System;
using System.Linq;
using Xunit;

namespace Utility.Mapping
{
    public sealed class QuadKeyUnitTests
    {
        [Theory]
        [InlineData(0UL)]
        [InlineData(1UL)]
        [InlineData(348772231245300630UL)]
        public void raw_value_returns_raw_value(ulong rawValue)
        {
            var sut = new QuadKey(rawValue);
            Assert.Equal(rawValue, sut.RawValue);
        }

        [Theory]
        [InlineData(0b0, false)]
        [InlineData(0b1, true)]
        [InlineData(0b011000, false)]
        [InlineData(0b010111, true)]
        [InlineData(0b1011000001, false)]
        public void is_valid_returns_true_only_for_valid_quad_keys(ulong rawValue, bool expected)
        {
            var sut = new QuadKey(rawValue);
            Assert.Equal(expected, sut.IsValid);
        }

        [Theory]
        [InlineData(0b000001, 1)]
        [InlineData(0b000010, 2)]
        [InlineData(0b1111000001, 1)]
        [InlineData(0b000111, 7)]
        public void level_of_detail_returns_the_level_of_detail(ulong rawValue, int expected)
        {
            var sut = new QuadKey(rawValue);
            Assert.Equal(expected, sut.LevelOfDetail);
        }

        [Theory]
        [InlineData("01", "0")]
        [InlineData("10", "1")]
        [InlineData("2", "<<invalid>>")]
        [InlineData("320121", "32012")]
        public void parent_returns_the_parent_quad_key(string current, string expected)
        {
            var sut = QuadKey.Parse(current);
            var parent = sut.Parent;

            Assert.Equal(expected, parent.ToString());
        }

        [Theory]
        [InlineData("0", new[] { "00", "01", "02", "03" })]
        [InlineData("1", new[] { "10", "11", "12", "13" })]
        [InlineData("3102", new[] { "31020", "31021", "31022", "31023" })]
        public void get_children_returns_all_child_quad_keys(string current, string[] expected)
        {
            var sut = QuadKey.Parse(current);
            var children = sut.GetChildren();

            Assert.True(children.Select(child => child.ToString()).SequenceEqual(expected));
        }

        [Theory]
        [InlineData("0", "<<invalid>>")]
        [InlineData("2", "0")]
        [InlineData("3", "1")]
        [InlineData("32", "30")]
        [InlineData("33", "31")]
        [InlineData("30", "12")]
        [InlineData("211", "033")]
        [InlineData("313", "311")]
        [InlineData("111", "<<invalid>>")]
        public void north_returns_the_quad_key_to_the_north(string current, string expected)
        {
            var sut = QuadKey.Parse(current);
            Assert.Equal(expected, sut.North.ToString());
        }

        [Theory]
        [InlineData("2", "<<invalid>>")]
        [InlineData("0", "2")]
        [InlineData("1", "3")]
        [InlineData("30", "32")]
        [InlineData("31", "33")]
        [InlineData("12", "30")]
        [InlineData("033", "211")]
        [InlineData("311", "313")]
        [InlineData("333", "<<invalid>>")]
        public void south_returns_the_quad_key_to_the_south(string current, string expected)
        {
            var sut = QuadKey.Parse(current);
            Assert.Equal(expected, sut.South.ToString());
        }

        [Theory]
        [InlineData("1", "<<invalid>>")]
        [InlineData("0", "1")]
        [InlineData("2", "3")]
        [InlineData("30", "31")]
        [InlineData("32", "33")]
        [InlineData("03", "12")]
        [InlineData("033", "122")]
        [InlineData("332", "333")]
        [InlineData("311", "<<invalid>>")]
        public void east_returns_the_quad_key_to_the_east(string current, string expected)
        {
            var sut = QuadKey.Parse(current);
            Assert.Equal(expected, sut.East.ToString());
        }

        [Theory]
        [InlineData("0", "<<invalid>>")]
        [InlineData("1", "0")]
        [InlineData("3", "2")]
        [InlineData("31", "30")]
        [InlineData("33", "32")]
        [InlineData("12", "03")]
        [InlineData("122", "033")]
        [InlineData("333", "332")]
        [InlineData("222", "<<invalid>>")]
        public void west_returns_the_quad_key_to_the_west(string current, string expected)
        {
            var sut = QuadKey.Parse(current);
            Assert.Equal(expected, sut.West.ToString());
        }

        [Theory]
        [InlineData("0", "0", new[] { "0" })]
        [InlineData("1", "1", new[] { "1" })]
        [InlineData("00", "00", new[] { "00" })]
        [InlineData("0", "3", new[] { "0", "1", "2", "3" })]
        [InlineData("030", "312", new[] { "030", "031", "120", "121", "130", "032", "033", "122", "123", "132", "210", "211", "300", "301", "310", "212", "213", "302", "303", "312" })]
        public void get_range_gets_all_quad_keys_in_a_range(string northWest, string southEast, string[] expected)
        {
            var results = QuadKey.GetRange(QuadKey.Parse(northWest), QuadKey.Parse(southEast));
            Assert.True(results.Select(result => result.ToString()).SequenceEqual(expected));
        }

        [Theory]
        [InlineData("0", new[] { 85.051128779806589, -180d, 0d, 0d })]
        [InlineData("1", new[] { 85.051128779806589, 0, 0, 179.296875 })]
        [InlineData("213101", new[] { -40.979898069620134, -16.875, -45.089035564831022, -11.25 })]
        public void get_bounding_geo_points_returns_correct_boundary(string quadKey, double[] expected)
        {
            var sut = QuadKey.Parse(quadKey);
            sut.GetBoundingGeoPoints(out var northWestLatitude, out var northWestLongitude, out var southEastLatitude, out var southEastLongitude);

            Assert.True(expected.SequenceEqual(new[] { northWestLatitude, northWestLongitude, southEastLatitude, southEastLongitude }));
        }

        [Theory]
        [InlineData(0b0, "<<invalid>>")]
        [InlineData(0b1, "0")]
        [InlineData(0b000100_10000100, "2010")]
        public void to_string_returns_a_string_representation_of_the_quad_key(ulong rawValue, string expected)
        {
            var sut = new QuadKey(rawValue);
            Assert.Equal(expected, sut.ToString());
        }

        [Theory]
        [InlineData(0, 0, true)]
        [InlineData(0, 1, false)]
        [InlineData(0123, 0123, true)]
        [InlineData(01230, 0123, false)]
        public void equality_works_as_expected(ulong first, ulong second, bool expected)
        {
            var firstSut = new QuadKey(first);
            var secondSut = new QuadKey(second);

            Assert.Equal(expected, firstSut.Equals(secondSut));
            Assert.Equal(expected, secondSut.Equals(firstSut));
        }

        [Theory]
        [InlineData(-34.633429521533216, 138.73932122222902, 17, "31122030121030001")]
        [InlineData(51.49681999999999, 0.012860000000012306, 15, "120202020020003")]
        [InlineData(51.49681999999999, 0.012860000000012306, 3, "120")]
        [InlineData(51.49681999999999, 0.012860000000012306, 30, "<<invalid>>")]
        public void from_works_as_expected(double latitude, double longitude, int levelOfDetail, string expected)
        {
            var sut = QuadKey.From(latitude, longitude, levelOfDetail);
            Assert.Equal(expected, sut.ToString());
        }

        [Fact]
        public void from_does_not_suffer_from_rounding_errors()
        {
            // These specific parameters were triggering a rounding error such that the second quad was not within
            // the first, which breaks expectations of client code. To combat this, the From method resolves the quad
            // to the highest level of detail and then truncates it.
            var latitude = 41;
            var longitude = 116;
            var firstLevel = 4;
            var secondLevel = 5;
            var first = QuadKey.From(latitude, longitude, firstLevel);
            var second = QuadKey.From(latitude, longitude, secondLevel);

            Assert.StartsWith(first.ToString(), second.ToString());
        }

        [Theory]
        [InlineData("120", true, 0b0010_01000011)]
        [InlineData("3210", true, 0b000110_11000100)]
        [InlineData("4", false, 0)]
        [InlineData("222222222222222222222222222222", false, 0)]
        public void try_parse_works_as_expected(string input, bool expectedIsValid, ulong expectedRawValue)
        {
            QuadKey.TryParse(input, out var result);
            Assert.Equal(expectedIsValid, result.IsValid);
            Assert.Equal(expectedRawValue, result.RawValue);
        }
    }
}
