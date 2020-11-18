using Newtonsoft.Json;

namespace Messaging.Firebase
{
    public sealed class Notification
    {
        [JsonProperty("title")]
        public string Title { get; set; }

        [JsonProperty("body")]
        public string Body { get; set; }
    }
}
