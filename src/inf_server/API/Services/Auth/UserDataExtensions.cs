using System.Collections.Immutable;
using System.Linq;
using API.Interfaces;
using User.Interfaces;

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
                LocationAsString = @this.LocationAsString,
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

        public static UserData ToService(this UserDto @this, string loginToken)
        {
            if (@this == null)
            {
                return null;
            }

            return new UserData(
                @this.UserType.ToService(),
                @this.AccountState.ToService(),
                @this.Name,
                @this.Description,
                @this.Avatar.ToService(),
                @this.AvatarThumbnail.ToService(),
                @this.Location.ToService(),
                @this.LocationAsString,
                @this.ShowLocation,
                @this.Verified,
                @this.WebsiteUrl,
                @this.AcceptsDirectOffers,
                @this.AccountCompletionInPercent,
                @this.MinimalFee,
                @this.CategoryIds?.ToImmutableList(),
                @this.SocialMediaAccounts?.Select(socialMediaAccount => socialMediaAccount.ToService())?.ToImmutableList(),
                loginToken);
        }
    }
}
