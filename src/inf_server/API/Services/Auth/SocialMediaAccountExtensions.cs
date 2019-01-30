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

            var result = new SocialMediaAccountDto
            {
                AudienceSize = @this.AudienceSize,
                PostCount = @this.PostCount,
                SocialNetworkProviderId = @this.SocialNetworkProviderId,
                Verified = @this.Verified,
            };

            if (@this.AccessToken != null)
            {
                result.AccessToken = @this.AccessToken;
            }

            if (@this.AccessTokenSecret != null)
            {
                result.AccessTokenSecret = @this.AccessTokenSecret;
            }

            if (@this.Description != null)
            {
                result.Description = @this.Description;
            }

            if (@this.DisplayName != null)
            {
                result.DisplayName = @this.DisplayName;
            }

            if (@this.Email != null)
            {
                result.Email = @this.Email;
            }

            if (@this.ProfileUri != null)
            {
                result.ProfileUrl = @this.ProfileUri;
            }

            if (@this.RefreshToken != null)
            {
                result.RefreshToken = @this.RefreshToken;
            }

            if (@this.UserId != null)
            {
                result.UserId = @this.UserId;
            }

            return result;
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
