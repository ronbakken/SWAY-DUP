using System;
using Xunit;

namespace Utility.Mapping
{
    public sealed class QuadKeyUnitTests
    {
        [Theory]
        [InlineData(-34.633429521533216, 138.73932122222902, 17, "31122030121030001")]
        [InlineData(51.49681999999999, 0.012860000000012306, 15, "120202020020003")]
        [InlineData(51.49681999999999, 0.012860000000012306, 3, "120")]
        public void quad_keys_calculate_correctly_from_latitude_longitude_and_level(double latitude, double longitude, int level, string expected)
        {
            var quadKey = new QuadKey(latitude, longitude, level);
            Assert.Equal(expected, quadKey.ToString());
        }

        [Theory]
        [InlineData(null)]
        [InlineData("")]
        [InlineData("abc")]
        [InlineData("4")]
        [InlineData("01310172010")]
        public void invalid_quad_key_values_are_rejected(string value)
        {
            Assert.Throws<ArgumentException>(() => new QuadKey(value));
        }

        [Theory]
        [InlineData("0")]
        [InlineData("1")]
        [InlineData("2")]
        [InlineData("3")]
        [InlineData("3102221301001120131023102103100021121202031022113")]
        public void valid_quad_key_values_are_accepted(string value)
        {
            var sut = new QuadKey(value);
            Assert.Equal(value, sut.Value);
        }

        [Theory]
        [InlineData("0", "0", true)]
        [InlineData("0", "1", false)]
        [InlineData("0123", "0123", true)]
        [InlineData("01230", "0123", false)]
        public void equality_works_as_expected(string first, string second, bool expected)
        {
            var firstSut = new QuadKey(first);
            var secondSut = new QuadKey(second);

            Assert.Equal(expected, firstSut.Equals(secondSut));
            Assert.Equal(expected, secondSut.Equals(firstSut));
        }

        [Theory]
        [InlineData("0", "0", true)]
        [InlineData("0", "01", true)]
        [InlineData("0", "1", false)]
        [InlineData("0", "10", false)]
        [InlineData("032", "0", false)]
        [InlineData("032", "03", false)]
        [InlineData("012320123013201231201203120121312312312332323222100", "0123201230132012312012031201213123123123323232221001", true)]
        public void contains_works_as_expected(string first, string second, bool expected)
        {
            var firstSut = new QuadKey(first);
            var secondSut = new QuadKey(second);

            Assert.Equal(expected, firstSut.Contains(secondSut));
        }
    }
}
