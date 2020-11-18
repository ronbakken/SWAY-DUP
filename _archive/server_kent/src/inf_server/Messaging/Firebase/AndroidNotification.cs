using Newtonsoft.Json;

namespace Messaging.Firebase
{
    public sealed class AndroidNotification
    {
        [JsonProperty("title")]
        public string Title { get; set; }

        [JsonProperty("body")]
        public string Body { get; set; }

        [JsonProperty("icon")]
        public string Icon { get; set; }

        [JsonProperty("color")]
        public string Color { get; set; }

        [JsonProperty("sound")]
        public string Sound { get; set; }

        [JsonProperty("tag")]
        public string Tag { get; set; }

        [JsonProperty("click_action")]
        public string ClickAction { get; set; }

        [JsonProperty("body_loc_key")]
        public string BodyLocalizationKey { get; set; }

        [JsonProperty("body_loc_args")]
        public string[] BodyLocalizationArgs{ get; set; }

        [JsonProperty("title_loc_key")]
        public string TitleLocalizationKey { get; set; }

        [JsonProperty("title_loc_args")]
        public string[] TitleLocalizationArgs { get; set; }

        [JsonProperty("channel_id")]
        public string ChannelId { get; set; }
    }
}
