using System.Collections.Generic;
using System.Linq;
using AutoMapper;
using Google.Protobuf;

namespace Utility.ObjectMapping
{
    public sealed class ByteListValueConverter : IValueConverter<ByteString, List<byte>>
    {
        public static readonly ByteListValueConverter Instance = new ByteListValueConverter();

        private ByteListValueConverter()
        {
        }

        public List<byte> Convert(ByteString sourceMember, ResolutionContext context) =>
            sourceMember?.ToList();
    }
}
