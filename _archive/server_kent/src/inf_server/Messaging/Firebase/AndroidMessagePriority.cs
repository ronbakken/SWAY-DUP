using System.Runtime.Serialization;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace Messaging.Firebase
{
    [JsonConverter(typeof(StringEnumConverter))]
    public enum AndroidMessagePriority
    {
        [EnumMember(Value = "NORMAL")]
        Normal,
        [EnumMember(Value = "HIGH")]
        High
    }
}
