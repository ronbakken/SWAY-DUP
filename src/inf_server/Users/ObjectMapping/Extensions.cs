using System.Linq;
using Users.Interfaces;

namespace Users.ObjectMapping
{
    public static class Extensions
    {
        public static UserEntity ToEntity(this User @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new UserEntity
            {
                AcceptsDirectOffers = @this.AcceptsDirectOffers,
                AccountCompletionInPercent = @this.AccountCompletionInPercent,
                Avatar = @this.Avatar.ToEntity(),
                AvatarThumbnail = @this.AvatarThumbnail.ToEntity(),
                Created = @this.Created,
                Description = @this.Description,
                Email = @this.Email,
                Id = @this.Id,
                IsVerified = @this.IsVerified,
                Location = @this.Location.ToEntity(),
                LoginToken = @this.LoginToken,
                MinimalFee = @this.MinimalFee.ToEntity(),
                Name = @this.Name,
                Revision = @this.Revision,
                SchemaVersion = 1,
                ShowLocation = @this.ShowLocation,
                Status = @this.Status.ToEntity(),
                StatusTimestamp = @this.StatusTimestamp,
                Type = @this.Type.ToEntity(),
                WebsiteUrl = @this.WebsiteUrl,
            };

            result.CategoryIds.AddRange(@this.CategoryIds);
            result.Keywords.AddRange(@this.Keywords);
            result.LocationsOfInfluence.AddRange(@this.LocationsOfInfluence.Select(x => x.ToEntity()));
            result.RegistrationTokens.AddRange(@this.RegistrationTokens);
            result.SocialMediaAccounts.AddRange(@this.SocialMediaAccounts.Select(x => x.ToEntity()));

            return result;
        }

        public static User ToServiceDto(this UserEntity @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new User
            {
                AcceptsDirectOffers = @this.AcceptsDirectOffers,
                AccountCompletionInPercent = @this.AccountCompletionInPercent,
                Avatar = @this.Avatar.ToServiceDto(),
                AvatarThumbnail = @this.AvatarThumbnail.ToServiceDto(),
                Created = @this.Created,
                Description = @this.Description,
                Email = @this.Email,
                Id = @this.Id,
                IsVerified = @this.IsVerified,
                Location = @this.Location.ToServiceDto(),
                LoginToken = @this.LoginToken,
                MinimalFee = @this.MinimalFee.ToServiceDto(),
                Name = @this.Name,
                Revision = @this.Revision,
                ShowLocation = @this.ShowLocation,
                Status = @this.Status.ToServiceDto(),
                StatusTimestamp = @this.StatusTimestamp,
                Type = @this.Type.ToServiceDto(),
                WebsiteUrl = @this.WebsiteUrl,
            };

            result.CategoryIds.AddRange(@this.CategoryIds);
            result.Keywords.AddRange(@this.Keywords);
            result.LocationsOfInfluence.AddRange(@this.LocationsOfInfluence.Select(x => x.ToServiceDto()));
            result.RegistrationTokens.AddRange(@this.RegistrationTokens);
            result.SocialMediaAccounts.AddRange(@this.SocialMediaAccounts.Select(x => x.ToServiceDto()));

            return result;
        }

        public static MoneyEntity ToEntity(this Money @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new MoneyEntity
            {
                CurrencyCode = @this.CurrencyCode,
                Nanos = @this.Nanos,
                Units = @this.Units,
            };

            return result;
        }

        public static Money ToServiceDto(this MoneyEntity @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new Money
            {
                CurrencyCode = @this.CurrencyCode,
                Nanos = @this.Nanos,
                Units = @this.Units,
            };

            return result;
        }

        public static ImageEntity ToEntity(this Image @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new ImageEntity
            {
                LowResUrl = @this.LowResUrl,
                Url = @this.Url,
            };

            return result;
        }

        public static Image ToServiceDto(this ImageEntity @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new Image
            {
                LowResUrl = @this.LowResUrl,
                Url = @this.Url,
            };

            return result;
        }

        public static LocationEntity ToEntity(this Location @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new LocationEntity
            {
                GeoPoint = @this.GeoPoint.ToEntity(),
                Name = @this.Name,
            };

            return result;
        }

        public static Location ToServiceDto(this LocationEntity @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new Location
            {
                GeoPoint = @this.GeoPoint.ToServiceDto(),
                Name = @this.Name,
            };

            return result;
        }

        public static GeoPointEntity ToEntity(this GeoPoint @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new GeoPointEntity
            {
                Latitude = @this.Latitude,
                Longitude = @this.Longitude,
            };

            return result;
        }

        public static GeoPoint ToServiceDto(this GeoPointEntity @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new GeoPoint
            {
                Latitude = @this.Latitude,
                Longitude = @this.Longitude,
            };

            return result;
        }

        public static SocialMediaAccountEntity ToEntity(this SocialMediaAccount @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new SocialMediaAccountEntity
            {
                AccessToken = @this.AccessToken,
                AccessTokenSecret = @this.AccessTokenSecret,
                AudienceSize = @this.AudienceSize,
                Description = @this.Description,
                DisplayName = @this.DisplayName,
                Email = @this.Email,
                IsVerified = @this.IsVerified,
                PageId = @this.PageId,
                PostCount = @this.PostCount,
                ProfileUrl = @this.ProfileUrl,
                RefreshToken = @this.RefreshToken,
                SocialNetworkProviderId = @this.SocialNetworkProviderId,
                UserId = @this.UserId,
            };

            return result;
        }

        public static SocialMediaAccount ToServiceDto(this SocialMediaAccountEntity @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new SocialMediaAccount
            {
                AccessToken = @this.AccessToken,
                AccessTokenSecret = @this.AccessTokenSecret,
                AudienceSize = @this.AudienceSize,
                Description = @this.Description,
                DisplayName = @this.DisplayName,
                Email = @this.Email,
                IsVerified = @this.IsVerified,
                PageId = @this.PageId,
                PostCount = @this.PostCount,
                ProfileUrl = @this.ProfileUrl,
                RefreshToken = @this.RefreshToken,
                SocialNetworkProviderId = @this.SocialNetworkProviderId,
                UserId = @this.UserId,
            };

            return result;
        }

        public static UserEntity.Types.Type ToEntity(this UserType @this) =>
            (UserEntity.Types.Type)(int)@this;

        public static UserType ToServiceDto(this UserEntity.Types.Type @this) =>
            (UserType)(int)@this;

        public static UserEntity.Types.Status ToEntity(this UserStatus @this) =>
            (UserEntity.Types.Status)(int)@this;

        public static UserStatus ToServiceDto(this UserEntity.Types.Status @this) =>
            (UserStatus)(int)@this;

        public static UserSessionEntity ToEntity(this UserSession @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new UserSessionEntity
            {
                RefreshToken = @this.RefreshToken,
                SchemaVersion = 1,
            };

            return result;
        }

        public static UserSession ToServiceDto(this UserSessionEntity @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new UserSession
            {
                RefreshToken = @this.RefreshToken,
            };

            return result;
        }
    }
}
