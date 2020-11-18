using System;
using System.Linq;
using Xunit;

namespace Utility.Search
{
    public sealed class KeywordsUnitTests
    {
        [Theory]
        [InlineData("the quick brown fox jumped over the lazy dog", new[] { "quick", "brown", "fox", "jump", "over", "lazi", "dog" })]
        [InlineData("The Quick, Brown Fox Jumped over the Lazy Dog!", new[] { "quick", "brown", "fox", "jump", "over", "lazi", "dog" })]
        [InlineData("The dude abides", new[] { "dude", "abid" })]
        public void keyword_extraction_works_as_expected(string input, string[] expected)
        {
            var result = Keywords
                .Extract(input)
                .ToArray();

            Assert.True(result.SequenceEqual(expected));
        }

        [Fact]
        public void null_inputs_are_ignored()
        {
            var result = Keywords
                .Extract(null, "something else", null)
                .ToList();
            Assert.True(result.SequenceEqual(new[] { "someth", "els" }));
        }

        [Fact]
        public void null_input_array_is_ignored()
        {
            var result = Keywords.Extract((string[])null);
            Assert.Empty(result);
        }
    }
}
