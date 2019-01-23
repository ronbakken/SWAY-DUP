using Users.Interfaces;

namespace Users
{
    public static class SocialMediaAccountEntityExtensions
    {
        public static SocialMediaAccount ToServiceObject(this SocialMediaAccountEntity @this)
        {
            if (@this == null)
            {
                return null;
            }

            return new SocialMediaAccount(
                @this.SocialNetworkProviderId,
                @this.DisplayName,
                @this.ProfileUri,
                @this.Description,
                @this.Email,
                @this.UserId,
                @this.AudienceSize,
                @this.PostCount,
                @this.IsVerified,
                @this.AccessToken,
                @this.AccessTokenSecret,
                @this.RefreshToken);
        }

        public static SocialMediaAccountEntity ToEntity(this SocialMediaAccount @this)
        {
            if (@this == null)
            {
                return null;
            }

            return new SocialMediaAccountEntity(
                @this.SocialNetworkProviderId,
                @this.DisplayName,
                @this.ProfileUri,
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
