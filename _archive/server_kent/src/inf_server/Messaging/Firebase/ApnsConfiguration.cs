using System.Collections.Generic;
using Newtonsoft.Json;

namespace Messaging.Firebase
{
    public sealed class ApnsConfiguration
    {
        [JsonProperty("headers")]
        public Dictionary<string, string> Headers { get; set; }

        [JsonProperty("payload")]
        public string Payload { get; set; }
    }
}
