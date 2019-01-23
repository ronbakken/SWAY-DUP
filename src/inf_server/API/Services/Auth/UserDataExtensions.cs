using System.Collections.Immutable;
using System.Linq;
using API.Interfaces;
using Users.Interfaces;

namespace API.Services.Auth
{
    public static class UserDataExtensions
    {
        public static UserDto ToDto(this UserData @this, string userId)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new UserDto
            {
                AcceptsDirectOffers = @this.AcceptsDirectOffers,
                AccountCompletionInPercent = @this.AccountCompletionInPercent,
                AccountState = @this.Status.ToDto(),
                Avatar = @this.Avatar?.ToDto(),
                AvatarThumbnail = @this.AvatarThumbnail?.ToDto(),
                Description = @this.Description,
                Email = userId,
                Location = @this.Location.ToDto(),
                MinimalFee = @this.MinimalFee,
                Name = @this.Name,
                ShowLocation = @this.ShowLocation,
                UserType = @this.Type.ToDto(),
                Verified = @this.Verified,
                WebsiteUrl = @this.WebsiteUri,
            };

            result.CategoryIds.AddRange(@this.CategoryIds);
            result.SocialMediaAccounts.AddRange(@this.SocialMediaAccounts.Select(socialMediaAccount => socialMediaAccount.ToDto()));

            return result;
        }

        public static UserData ToServiceObject(this UserDto @this, string loginToken)
        {
            if (@this == null)
            {
                return null;
            }

            return new UserData(
                @this.UserType.ToServiceObject(),
                @this.AccountState.ToServiceObject(),
                @this.Name,
                @this.Description,
                @this.Avatar.ToServiceObject(),
                @this.AvatarThumbnail.ToServiceObject(),
                @this.Location.ToServiceObject(),
                @this.ShowLocation,
                @this.Verified,
                @this.WebsiteUrl,
                @this.AcceptsDirectOffers,
                @this.AccountCompletionInPercent,
                @this.MinimalFee,
                @this.CategoryIds?.ToImmutableList(),
                @this.SocialMediaAccounts?.Select(socialMediaAccount => socialMediaAccount.ToServiceObject())?.ToImmutableList(),
                loginToken);
        }
    }
}
