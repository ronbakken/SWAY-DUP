using Newtonsoft.Json;
using NodaTime;
using Optional;

namespace InvitationCodes
{
    public sealed class InvitationCodeEntity
    {
        public InvitationCodeEntity(
            string code,
            ZonedDateTime expiryTimestamp) : this(1, code, expiryTimestamp, isHonored: false)
        {
        }

        [JsonConstructor]
        public InvitationCodeEntity(
            int version,
            string code,
            ZonedDateTime expiryTimestamp,
            bool isHonored)
        {
            this.Version = version;
            this.Code = code;
            this.ExpiryTimestamp = expiryTimestamp;
            this.IsHonored = isHonored;
        }

        [JsonProperty("id")]
        public string Id => this.Code;

        [JsonProperty("version")]
        public int Version { get; }

        [JsonProperty("code")]
        public string Code { get; }

        [JsonProperty("expiryTimestamp")]
        public ZonedDateTime ExpiryTimestamp { get; }

        [JsonProperty("isHonored")]
        public bool IsHonored { get; }

        public InvitationCodeEntity With(Option<bool> isHonored = default) =>
            new InvitationCodeEntity(
                Version,
                Code,
                ExpiryTimestamp,
                isHonored.ValueOr(IsHonored));
    }
}
