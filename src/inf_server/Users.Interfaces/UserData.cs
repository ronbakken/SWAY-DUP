using System.Collections.Immutable;
using System.Runtime.Serialization;
using Optional;

namespace Users.Interfaces
{
    [DataContract]
    public sealed class UserData
    {
        public static readonly UserData Initial = new UserData(
            default,
            default,
            default,
            default,
            default,
            default,
            default,
            default,
            default,
            default,
            default,
            default,
            default,
            default,
            default,
            default);

        public UserData(
            UserType type,
            UserStatus status,
            string name,
            string description,
            Image avatar,
            Image avatarThumbnail,
            Location location,
            bool showLocation,
            bool verified,
            string websiteUri,
            bool acceptsDirectOffers,
            int accountCompletionInPercent,
            int minimalFee,
            ImmutableList<int> categoryIds,
            ImmutableList<SocialMediaAccount> socialMediaAccounts,
            string loginToken)
        {
            this.Type = type;
            this.Status = status;
            this.Name = name;
            this.Description = description;
            this.Avatar = avatar;
            this.AvatarThumbnail = avatarThumbnail;
            this.Location = location;
            this.ShowLocation = showLocation;
            this.Verified = verified;
            this.WebsiteUri = websiteUri;
            this.AcceptsDirectOffers = acceptsDirectOffers;
            this.AccountCompletionInPercent = accountCompletionInPercent;
            this.MinimalFee = minimalFee;
            this.CategoryIds = categoryIds;
            this.SocialMediaAccounts = socialMediaAccounts;
            this.LoginToken = loginToken;
        }

        [DataMember]
        public UserType Type { get; private set; }

        [DataMember]
        public UserStatus Status { get; private set; }

        [DataMember]
        public string Name { get; private set; }

        [DataMember]
        public string Description { get; private set; }

        [DataMember]
        public Image Avatar { get; private set; }

        [DataMember]
        public Image AvatarThumbnail { get; private set; }

        [DataMember]
        public Location Location { get; private set; }

        [DataMember]
        public bool ShowLocation { get; private set; }

        [DataMember]
        public bool Verified { get; private set; }

        [DataMember]
        public string WebsiteUri { get; private set; }

        [DataMember]
        public bool AcceptsDirectOffers { get; private set; }

        [DataMember]
        public int AccountCompletionInPercent { get; private set; }

        [DataMember]
        public int MinimalFee { get; private set; }

        [DataMember]
        public ImmutableList<int> CategoryIds { get; private set; }

        [DataMember]
        public ImmutableList<SocialMediaAccount> SocialMediaAccounts { get; private set; }

        [DataMember]
        public string LoginToken { get; private set; }

        public UserData With(
            Option<UserType> type = default,
            Option<UserStatus> status = default,
            Option<string> name = default,
            Option<string> description = default,
            Option<Image> avatar = default,
            Option<Image> avatarThumbnail = default,
            Option<Location> location = default,
            Option<bool> showLocation = default,
            Option<bool> verified = default,
            Option<string> websiteUri = default,
            Option<bool> acceptsDirectOffers = default,
            Option<int> accountCompletionInPercent = default,
            Option<int> minimalFee = default,
            Option<ImmutableList<int>> categoryIds = default,
            Option<ImmutableList<SocialMediaAccount>> socialMediaAccounts = default,
            Option<string> loginToken = default) =>
            new UserData(
                type.ValueOr(Type),
                status.ValueOr(Status),
                name.ValueOr(Name),
                description.ValueOr(Description),
                avatar.ValueOr(Avatar),
                avatarThumbnail.ValueOr(AvatarThumbnail),
                location.ValueOr(Location),
                showLocation.ValueOr(ShowLocation),
                verified.ValueOr(Verified),
                websiteUri.ValueOr(WebsiteUri),
                acceptsDirectOffers.ValueOr(AcceptsDirectOffers),
                accountCompletionInPercent.ValueOr(AccountCompletionInPercent),
                minimalFee.ValueOr(MinimalFee),
                categoryIds.ValueOr(CategoryIds),
                socialMediaAccounts.ValueOr(SocialMediaAccounts),
                loginToken.ValueOr(LoginToken));
    }
}
