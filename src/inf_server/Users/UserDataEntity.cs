﻿using System.Collections.Immutable;
using Newtonsoft.Json;

namespace Users
{
    public sealed class UserDataEntity
    {
        public UserDataEntity(
            string id,
            string email,
            UserTypeEntity type,
            UserStatusEntity status,
            string name,
            string description,
            ImageEntity avatar,
            ImageEntity avatarThumbnail,
            LocationEntity location,
            bool showLocation,
            bool isVerified,
            string websiteUri,
            bool acceptsDirectOffers,
            int accountCompletionInPercent,
            int minimalFee,
            ImmutableList<int> categoryIds,
            ImmutableList<SocialMediaAccountEntity> socialMediaAccounts,
            ImmutableList<string> keywords,
            string loginToken) : this(1, id, email, type, status, name, description, avatar, avatarThumbnail, location, showLocation, isVerified, websiteUri, acceptsDirectOffers, accountCompletionInPercent, minimalFee, categoryIds, socialMediaAccounts, keywords, loginToken)
        {
        }

        [JsonConstructor]
        public UserDataEntity(
            int version,
            string id,
            string email,
            UserTypeEntity type,
            UserStatusEntity status,
            string name,
            string description,
            ImageEntity avatar,
            ImageEntity avatarThumbnail,
            LocationEntity location,
            bool showLocation,
            bool isVerified,
            string websiteUri,
            bool acceptsDirectOffers,
            int accountCompletionInPercent,
            int minimalFee,
            ImmutableList<int> categoryIds,
            ImmutableList<SocialMediaAccountEntity> socialMediaAccounts,
            ImmutableList<string> keywords,
            string loginToken)
        {
            this.Version = version;
            this.Id = id;
            this.Email = email;
            this.Type = type;
            this.Status = status;
            this.Name = name;
            this.Description = description;
            this.Avatar = avatar;
            this.AvatarThumbnail = avatarThumbnail;
            this.Location = location;
            this.ShowLocation = showLocation;
            this.IsVerified = isVerified;
            this.WebsiteUri = websiteUri;
            this.AcceptsDirectOffers = acceptsDirectOffers;
            this.AccountCompletionInPercent = accountCompletionInPercent;
            this.MinimalFee = minimalFee;
            this.CategoryIds = categoryIds;
            this.SocialMediaAccounts = socialMediaAccounts;
            this.Keywords = keywords;
            this.LoginToken = loginToken;
        }

        [JsonProperty("id")]
        public string Id { get; }

        [JsonProperty("version")]
        public int Version { get; }

        [JsonProperty("email")]
        public string Email { get; }

        [JsonProperty("type", DefaultValueHandling = DefaultValueHandling.Include)]
        public UserTypeEntity Type { get; }

        [JsonProperty("status", DefaultValueHandling = DefaultValueHandling.Include)]
        public UserStatusEntity Status { get; }

        [JsonProperty("name")]
        public string Name { get; }

        [JsonProperty("description")]
        public string Description { get; }

        [JsonProperty("avatar")]
        public ImageEntity Avatar { get; }

        [JsonProperty("avatarThumbnail")]
        public ImageEntity AvatarThumbnail { get; }

        [JsonProperty("location")]
        public LocationEntity Location { get; }

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

        [JsonProperty("keywords")]
        public ImmutableList<string> Keywords { get; }

        [JsonProperty("loginToken")]
        public string LoginToken { get; }
    }
}
