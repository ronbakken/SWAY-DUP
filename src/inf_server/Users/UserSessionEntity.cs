using Newtonsoft.Json;
using Utility.Tokens;

namespace Users
{
    public sealed class UserSessionEntity
    {
        public UserSessionEntity(
            string id,
            string refreshToken,
            string deviceId) : this(1, id, refreshToken, deviceId)
        {
        }

        [JsonConstructor]
        public UserSessionEntity(
            int version,
            string id,
            string refreshToken,
            string deviceId)
        {
            this.Version = version;
            // ID must be independent of refresh token because IDs have a length limit of 254 characters
            this.Id = id;
            this.RefreshToken = refreshToken;
            this.DeviceId = deviceId;
        }

        [JsonProperty("version")]
        public int Version { get; }

        [JsonProperty("userId")]
        public string UserId
        {
            get
            {
                var validateResults = TokenManager.ValidateRefreshToken(this.RefreshToken);
                return validateResults.UserId;
            }
        }

        [JsonProperty("id")]
        public string Id { get; }

        [JsonProperty("refreshToken")]
        public string RefreshToken { get; }

        [JsonProperty("deviceId")]
        public string DeviceId { get; }
    }
}
