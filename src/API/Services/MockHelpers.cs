using Google.Protobuf;
using System.IO;

namespace API.Services
{
    internal sealed class MockHelpers
    {
        public static ByteString ReadIconData(string fileName)
        {
            using (var stream = typeof(MockHelpers).Assembly.GetManifestResourceStream($"API.Services.icons.{Path.GetFileName(fileName)}"))
            {
                var byteString = ByteString.FromStream(stream);
                return byteString;
            }
        }
    }
}