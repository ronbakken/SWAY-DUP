using System.Runtime.Serialization;

namespace User.Interfaces
{
    [DataContract]
    public sealed class SocialMediaAccount
    {
        public SocialMediaAccount(
            SocialNetworkProviderType type,
            string displayName,
            string profileUri,
            string description,
            string email,
            string userId,
            int audienceSize,
            int postCount,
            bool verified,
            string accessToken,
            string accessTokenSecret,
            string refreshToken)
        {
            this.Type = type;
            this.DisplayName = displayName;
            this.ProfileUri = profileUri;
            this.Description = description;
            this.Email = email;
            this.UserId = userId;
            this.AudienceSize = audienceSize;
            this.PostCount = postCount;
            this.Verified = verified;
            this.AccessToken = accessToken;
            this.AccessTokenSecret = accessTokenSecret;
            this.RefreshToken = refreshToken;
        }

        [DataMember]
        public SocialNetworkProviderType Type { get; private set; }

        [DataMember]
        public string DisplayName { get; private set; }

        [DataMember]
        public string ProfileUri { get; private set; }

        [DataMember]
        public string Description { get; private set; }

        [DataMember]
        public string Email { get; private set; }

        [DataMember]
        public string UserId { get; private set; }

        [DataMember]
        public int AudienceSize { get; private set; }

        [DataMember]
        public int PostCount { get; private set; }

        [DataMember]
        public bool Verified { get; private set; }

        [DataMember]
        public string AccessToken { get; private set; }

        [DataMember]
        public string AccessTokenSecret { get; private set; }

        [DataMember]
        public string RefreshToken { get; private set; }
    }
}
