using System.Linq;
using API.Interfaces;
using Users.Interfaces;

namespace API.Services.Auth
{
    public static class UserDataExtensions
    {
        public static UserDto ToDto(this UserData @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new UserDto
            {
                Id = @this.Id.OptionalOr(null),
                AcceptsDirectOffers = @this.AcceptsDirectOffers,
                AccountCompletionInPercent = @this.AccountCompletionInPercent,
                AccountState = @this.Status.ToDto(),
                Avatar = @this.Avatar?.ToDto(),
                AvatarThumbnail = @this.AvatarThumbnail?.ToDto(),
                Location = @this.Location.ToDto(),
                MinimalFee = @this.MinimalFee,
                ShowLocation = @this.ShowLocation,
                UserType = @this.Type.ToDto(),
                Verified = @this.Verified,
            };

            if (@this.Description != null)
            {
                result.Description = @this.Description;
            }

            if (@this.Email != null)
            {
                result.Email = @this.Email;
            }

            if (@this.Name != null)
            {
                result.Name = @this.Name;
            }

            if (@this.WebsiteUri != null)
            {
                result.WebsiteUrl = @this.WebsiteUri;
            }

            if (@this.CategoryIds != null)
            {
                result.CategoryIds.AddRange(@this.CategoryIds);
            }

            if (@this.SocialMediaAccounts != null)
            {
                result.SocialMediaAccounts.AddRange(@this.SocialMediaAccounts.Select(socialMediaAccount => socialMediaAccount.ToDto()));
            }

            return result;
        }

        public static UserData ToServiceObject(this UserDto @this, string loginToken)
        {
            if (@this == null)
            {
                return null;
            }

            return new UserData(
                @this.Id.ValueOr(null),
                @this.Email,
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
                @this.CategoryIds?.ToList(),
                @this.SocialMediaAccounts?.Select(socialMediaAccount => socialMediaAccount.ToServiceObject())?.ToList(),
                loginToken);
        }
    }
}
