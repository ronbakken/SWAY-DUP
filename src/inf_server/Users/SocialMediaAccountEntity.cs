using Newtonsoft.Json;

namespace Users
{
    public sealed class SocialMediaAccountEntity
    {
        [JsonConstructor]
        public SocialMediaAccountEntity(
            int socialNetworkProviderId,
            string displayName,
            string profileUri,
            string description,
            string email,
            string userId,
            int audienceSize,
            int postCount,
            bool isVerified,
            string accessToken,
            string accessTokenSecret,
            string refreshToken)
        {
            this.SocialNetworkProviderId = socialNetworkProviderId;
            this.DisplayName = displayName;
            this.ProfileUri = profileUri;
            this.Description = description;
            this.Email = email;
            this.UserId = userId;
            this.AudienceSize = audienceSize;
            this.PostCount = postCount;
            this.IsVerified = isVerified;
            this.AccessToken = accessToken;
            this.AccessTokenSecret = accessTokenSecret;
            this.RefreshToken = refreshToken;
        }

        [JsonProperty("socialNetworkProviderId", DefaultValueHandling = DefaultValueHandling.Include)]
        public int SocialNetworkProviderId { get; }

        [JsonProperty("displayName")]
        public string DisplayName { get; }

        [JsonProperty("profileUri")]
        public string ProfileUri { get; }

        [JsonProperty("description")]
        public string Description { get; }

        [JsonProperty("email")]
        public string Email { get; }

        [JsonProperty("userId")]
        public string UserId { get; }

        [JsonProperty("audienceSize")]
        public int AudienceSize { get; }

        [JsonProperty("postCount")]
        public int PostCount { get; }

        [JsonProperty("isVerified")]
        public bool IsVerified { get; }

        [JsonProperty("accessToken")]
        public string AccessToken { get; }

        [JsonProperty("accessTokenSecret")]
        public string AccessTokenSecret { get; }

        [JsonProperty("refreshToken")]
        public string RefreshToken { get; }
    }
}
