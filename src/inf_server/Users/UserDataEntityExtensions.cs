using System.Collections.Immutable;
using System.Linq;
using Users.Interfaces;

namespace Users
{
    public static class UserDataEntityExtensions
    {
        public static UserData ToServiceObject(this UserDataEntity @this)
        {
            if (@this == null)
            {
                return null;
            }

            return new UserData(
                @this.Id,
                @this.Type.ToServiceObject(),
                @this.Status.ToServiceObject(),
                @this.Name,
                @this.Description,
                @this.Avatar.ToServiceObject(),
                @this.AvatarThumbnail.ToServiceObject(),
                @this.Location.ToServiceObject(),
                @this.ShowLocation,
                @this.IsVerified,
                @this.WebsiteUri,
                @this.AcceptsDirectOffers,
                @this.AccountCompletionInPercent,
                @this.MinimalFee,
                @this.CategoryIds?.ToList(),
                @this.SocialMediaAccounts?.Select(socialMediaAccount => socialMediaAccount.ToServiceObject())?.ToList(),
                @this.LoginToken);
        }

        public static UserDataEntity ToEntity(this UserData @this, string userId, ImmutableList<string> keywords)
        {
            if (@this == null)
            {
                return null;
            }

            return new UserDataEntity(
                userId,
                @this.Type.ToEntity(),
                @this.Status.ToEntity(),
                @this.Name,
                @this.Description,
                @this.Avatar.ToEntity(),
                @this.AvatarThumbnail.ToEntity(),
                @this.Location.ToEntity(),
                @this.ShowLocation,
                @this.Verified,
                @this.WebsiteUri,
                @this.AcceptsDirectOffers,
                @this.AccountCompletionInPercent,
                @this.MinimalFee,
                @this.CategoryIds?.ToImmutableList(),
                @this.SocialMediaAccounts?.Select(socialMediaAccount => socialMediaAccount.ToEntity())?.ToImmutableList(),
                keywords,
                @this.LoginToken);
        }
    }
}
