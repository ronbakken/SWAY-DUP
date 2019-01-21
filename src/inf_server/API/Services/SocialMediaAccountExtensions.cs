using API.Interfaces;
using User.Interfaces;

namespace API.Services
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
                //SocialNetworkProviderId = @this.soci
                Type = @this.Type.ToDto(),
                UserId = @this.UserId,
                Verified = @this.Verified,
            };
        }

        public static SocialMediaAccount ToService(this SocialMediaAccountDto @this)
        {
            if (@this == null)
            {
                return null;
            }

            return new SocialMediaAccount(
                @this.Type.ToService(),
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
