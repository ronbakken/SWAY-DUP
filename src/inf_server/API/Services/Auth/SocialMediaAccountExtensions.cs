using API.Interfaces;
using Users.Interfaces;

namespace API.Services.Auth
{
    public static class SocialMediaAccountExtensions
    {
        public static SocialMediaAccountDto ToDto(this SocialMediaAccount @this)
        {
            if (@this == null)
            {
                return null;
            }

            return new SocialMediaAccountDto
            {
                AccessToken = @this.AccessToken,
                AccessTokenSecret = @this.AccessTokenSecret,
                AudienceSize = @this.AudienceSize,
                Description = @this.Description,
                DisplayName = @this.DisplayName,
                Email = @this.Email,
                PostCount = @this.PostCount,
                ProfileUrl = @this.ProfileUri,
                RefreshToken = @this.RefreshToken,
                SocialNetworkProviderId = @this.SocialNetworkProviderId,
                UserId = @this.UserId,
                Verified = @this.Verified,
            };
        }

        public static SocialMediaAccount ToServiceObject(this SocialMediaAccountDto @this)
        {
            if (@this == null)
            {
                return null;
            }

            return new SocialMediaAccount(
                @this.SocialNetworkProviderId,
                @this.DisplayName,
                @this.ProfileUrl,
                @this.Description,
                @this.Email,
                @this.UserId,
                @this.AudienceSize,
                @this.PostCount,
                @this.Verified,
                @this.AccessToken,
                @this.AccessTokenSecret,
                @this.RefreshToken);
        }
    }
}
