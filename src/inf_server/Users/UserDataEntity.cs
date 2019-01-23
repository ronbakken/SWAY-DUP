using System.Collections.Immutable;
using Newtonsoft.Json;

namespace Users
{
    public sealed class UserDataEntity
    {
        public UserDataEntity(
            string userId,
            UserTypeEntity type,
            UserStatusEntity status,
            string name,
            string description,
            ImageEntity avatar,
            ImageEntity avatarThumbnail,
            LocationEntity location,
            string locationAsString,
            bool showLocation,
            bool isVerified,
            string websiteUri,
            bool acceptsDirectOffers,
            int accountCompletionInPercent,
            int minimalFee,
            ImmutableList<int> categoryIds,
            ImmutableList<SocialMediaAccountEntity> socialMediaAccounts,
            string loginToken) : this(1, userId, type, status, name, description, avatar, avatarThumbnail, location, locationAsString, showLocation, isVerified, websiteUri, acceptsDirectOffers, accountCompletionInPercent, minimalFee, categoryIds, socialMediaAccounts, loginToken)
        {
        }

        [JsonConstructor]
        public UserDataEntity(
            int version,
            string userId,
            UserTypeEntity type,
            UserStatusEntity status,
            string name,
            string description,
            ImageEntity avatar,
            ImageEntity avatarThumbnail,
            LocationEntity location,
            string locationAsString,
            bool showLocation,
            bool isVerified,
            string websiteUri,
            bool acceptsDirectOffers,
            int accountCompletionInPercent,
            int minimalFee,
            ImmutableList<int> categoryIds,
            ImmutableList<SocialMediaAccountEntity> socialMediaAccounts,
            string loginToken)
        {
            this.Version = version;
            this.UserId = userId;
            this.Type = type;
            this.Status = status;
            this.Name = name;
            this.Description = description;
            this.Avatar = avatar;
            this.AvatarThumbnail = avatarThumbnail;
            this.Location = location;
            this.LocationAsString = locationAsString;
            this.ShowLocation = showLocation;
            this.IsVerified = isVerified;
            this.WebsiteUri = websiteUri;
            this.AcceptsDirectOffers = acceptsDirectOffers;
            this.AccountCompletionInPercent = accountCompletionInPercent;
            this.MinimalFee = minimalFee;
            this.CategoryIds = categoryIds;
            this.SocialMediaAccounts = socialMediaAccounts;
            this.LoginToken = loginToken;
        }

        [JsonProperty("id")]
        public string Id => this.UserId;

        [JsonProperty("version")]
        public int Version { get; }

        [JsonProperty("userId")]
        public string UserId { get; }

        [JsonProperty("type")]
        public UserTypeEntity Type { get; }

        [JsonProperty("status")]
        public UserStatusEntity Status { get; }

        [JsonProperty("name")]
        public string Name { get; }

        [JsonProperty("description")]
        public string Description { get; }

        [JsonProperty("avator")]
        public ImageEntity Avatar { get; }

        [JsonProperty("avatarThumbnail")]
        public ImageEntity AvatarThumbnail { get; }

        [JsonProperty("location")]
        public LocationEntity Location { get; }

        [JsonProperty("locationAsString")]
        public string LocationAsString { get; }

        [JsonProperty("showLocation")]
        public bool ShowLocation { get; }

        [JsonProperty("isVerified")]
        public bool IsVerified { get; }

        [JsonProperty("websiteUri")]
        public string WebsiteUri { get; }

        [JsonProperty("acceptsDirectOffers")]
        public bool AcceptsDirectOffers { get; }

        [JsonProperty("accountCompletionInPercent")]
        public int AccountCompletionInPercent { get; }

        [JsonProperty("minimalFee")]
        public int MinimalFee { get; }

        [JsonProperty("categoryIds")]
        public ImmutableList<int> CategoryIds { get; }

        [JsonProperty("socialMediaAccounts")]
        public ImmutableList<SocialMediaAccountEntity> SocialMediaAccounts { get; }

        [JsonProperty("loginToken")]
        public string LoginToken { get; }
    }
}
