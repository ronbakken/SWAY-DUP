using System.Collections.Generic;
using System.IO;
using Lucene.Net.Analysis.En;
using Lucene.Net.Analysis.TokenAttributes;
using Lucene.Net.Util;

namespace Utility.Search
{
    public static class Keywords
    {
        public static IEnumerable<string> Extract(string input)
        {
            if (input == null)
            {
                yield break;
            }

            // This is not a thread-safe object.
            var analyzer = new EnglishAnalyzer(LuceneVersion.LUCENE_48);

            using (var stringReader = new StringReader(input))
            {
                var tokenStream = analyzer.GetTokenStream(null, stringReader);
                tokenStream.Reset();

                while (tokenStream.IncrementToken())
                {
                    var termAttribute = tokenStream.GetAttribute<ICharTermAttribute>();
                    var keyword = termAttribute.ToString();
                    yield return keyword;
                }
            }
        }

        public static IEnumerable<string> Extract(params string[] inputs)
        {
            if (inputs == null)
            {
                yield break;
            }

            foreach (var input in inputs)
            {
                foreach (var keyword in Extract(input))
                {
                    yield return keyword;
                }
            }
        }
    }
}
