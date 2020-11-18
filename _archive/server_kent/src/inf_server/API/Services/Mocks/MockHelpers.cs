using System.IO;
using Google.Protobuf;

namespace API.Services.Mocks
{
    internal sealed class MockHelpers
    {
        public static ByteString ReadIconData(string fileName)
        {
            using (var stream = typeof(MockHelpers).Assembly.GetManifestResourceStream($"API.Services.Mocks.icons.{Path.GetFileName(fileName)}"))
            {
                var byteString = ByteString.FromStream(stream);
                return byteString;
            }
        }
    }
}