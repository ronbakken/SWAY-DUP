using System.Collections.Generic;
using System.Linq;
using AutoMapper;
using Google.Protobuf;

namespace Utility.ObjectMapping
{
    public sealed class ByteStringValueConverter : IValueConverter<IEnumerable<byte>, ByteString>
    {
        public static readonly ByteStringValueConverter Instance = new ByteStringValueConverter();

        private ByteStringValueConverter()
        {
        }

        public ByteString Convert(IEnumerable<byte> sourceMember, ResolutionContext context) =>
            sourceMember == null ? ByteString.Empty : ByteString.CopyFrom(sourceMember.ToArray());
    }
}
