using Newtonsoft.Json;

namespace Messaging.Firebase
{
    // Represents a message to be serialized as JSON and sent to the Firebase API.
    // See https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages.
    public sealed class Message
    {
        [JsonProperty("notification")]
        public Notification Notification { get; set; }

        [JsonProperty("android")]
        public AndroidConfiguration AndroidConfiguration { get; set; }

        [JsonProperty("apns")]
        public ApnsConfiguration ApnsConfiguration { get; set; }

        [JsonProperty("token")]
        public string Token { get; set; }

        [JsonProperty("topic")]
        public string Topic { get; set; }

        [JsonProperty("condition")]
        public string Condition { get; set; }
    }
}
