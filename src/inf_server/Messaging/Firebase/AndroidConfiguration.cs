using System.Collections.Generic;
using Newtonsoft.Json;

namespace Messaging.Firebase
{
    public sealed class AndroidConfiguration
    {
        [JsonProperty("collapse_key")]
        public string CollapseKey { get; set; }

        [JsonProperty("priority")]
        public AndroidMessagePriority Priority { get; set; }

        [JsonProperty("ttl")]
        public string TimeToLive { get; set; }

        [JsonProperty("restricted_package_name")]
        public string RestrictedPackageName { get; set; }

        [JsonProperty("data")]
        public Dictionary<string, string> Data { get; set; }

        [JsonProperty("notification")]
        public AndroidNotification Notification { get; set; }
    }
}
