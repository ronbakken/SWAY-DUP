using System.IO;
using System.Runtime.Serialization;

namespace Utility.Serialization
{
    public static class DataContractSerializerExtensions
    {
        public static byte[] ToSerializedDataContract<T>(this T @this)
        {
            if (@this == null)
            {
                return null;
            }

            var memoryStream = new MemoryStream();
            var serializer = new DataContractSerializer(typeof(T));
            serializer.WriteObject(memoryStream, @this);
            var result = memoryStream.ToArray();
            return result;
        }

        public static T FromSerializedDataContract<T>(this byte[] @this)
        {
            if (@this == null)
            {
                return default;
            }

            var memoryStream = new MemoryStream(@this);
            var serializer = new DataContractSerializer(typeof(T));
            var result = (T)serializer.ReadObject(memoryStream);
            return result;
        }
    }
}
