using System.IO;
using Google.Protobuf;

namespace MockServer
{
    internal sealed class MockHelpers
    {
        public static ByteString ReadIconData(string fileName)
        {
            using (var stream = typeof(MockHelpers).Assembly.GetManifestResourceStream($"MockServer.icons.{Path.GetFileName(fileName)}"))
            {
                var byteString = ByteString.FromStream(stream);
                return byteString;
            }
        }
    }
}