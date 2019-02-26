using System;
using System.Linq;
using API.Interfaces;
using users = Users.Interfaces;

namespace API.ObjectMapping
{
    public static class UsersExtensions
    {
        public static UserDto ToUserDto(this users.User @this, UserDto.DataOneofCase dataDenomination)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new UserDto
            {
                Id = @this.Id,
                Revision = @this.Revision,
                Status = @this.Status.ToStatus(),
            };

            switch (dataDenomination)
            {
                case UserDto.DataOneofCase.Full:
                    result.Full = @this.ToFullDataDto();
                    break;
                case UserDto.DataOneofCase.List:
                    result.List = @this.ToListDataDto();
                    break;
                case UserDto.DataOneofCase.Handle:
                    result.Handle = @this.ToHandleDataDto();
                    break;
                default:
                    throw new NotSupportedException();
            }

            return result;
        }

        public static users.User ToUser(this UserDto @this)
        {
            if (@this == null)
            {
                return null;
            }

            if (@this.DataCase != UserDto.DataOneofCase.Full)
            {
                throw new NotSupportedException("Can only convert from full data.");
            }

            var result = new users.User
            {
                AcceptsDirectOffers = @this.Full.AcceptsDirectOffers,
                AccountCompletionInPercent = @this.Full.AccountCompletionInPercent,
                Avatar = @this.Full.Avatar.ToUsersImage(),
                AvatarThumbnail = @this.Full.AvatarThumbnail.ToUsersImage(),
                Description = @this.Full.Description,
                Email = @this.Full.Email,
                Id = @this.Id,
                IsVerified = @this.Full.IsVerified,
                Location = @this.Full.Location.ToUsersLocation(),
                MinimalFee = @this.Full.MinimalFee.ToMoney(),
                Name = @this.Full.Name,
                Revision = @this.Revision,
                ShowLocation = @this.Full.ShowLocation,
                Status = @this.Status.ToUserStatus(),
                Type = @this.Full.Type.ToUserType(),
                WebsiteUrl = @this.Full.WebsiteUrl,
            };

            return result;
        }

        public static UserDto.Types.FullDataDto ToFullDataDto(this users.User @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new UserDto.Types.FullDataDto
            {
                AcceptsDirectOffers = @this.AcceptsDirectOffers,
                AccountCompletionInPercent = @this.AccountCompletionInPercent,
                Avatar = @this.Avatar.ToImageDto(),
                AvatarThumbnail = @this.AvatarThumbnail.ToImageDto(),
                Description = @this.Description,
                Email = @this.Email,
                IsVerified = @this.IsVerified,
                Location = @this.Location.ToLocationDto(),
                MinimalFee = @this.MinimalFee.ToMoneyDto(),
                Name = @this.Name,
                ShowLocation = @this.ShowLocation,
                Type = @this.Type.ToUserType(),
                WebsiteUrl = @this.WebsiteUrl,
            };

            result.CategoryIds.AddRange(@this.CategoryIds);
            result.RegistrationTokens.AddRange(@this.RegistrationTokens);
            result.SocialMediaAccounts.AddRange(@this.SocialMediaAccounts.Select(x => x.ToSocialMediaAccount()));

            return result;
        }

        public static UserDto.Types.ListDataDto ToListDataDto(this users.User @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new UserDto.Types.ListDataDto
            {
                Avatar = @this.Avatar.ToImageDto(),
                AvatarThumbnail = @this.AvatarThumbnail.ToImageDto(),
                Description = @this.Description,
                Location = @this.Location.ToLocationDto(),
                Name = @this.Name,
                ShowLocation = @this.ShowLocation,
                Type = @this.Type.ToUserType(),
            };

            result.CategoryIds.AddRange(@this.CategoryIds);

            return result;
        }

        public static UserDto.Types.HandleDataDto ToHandleDataDto(this users.User @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new UserDto.Types.HandleDataDto
            {
                Name = @this.Name,
            };

            return result;
        }

        public static MoneyDto ToMoneyDto(this users.Money @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new MoneyDto
            {
                CurrencyCode = @this.CurrencyCode,
                Nanos = @this.Nanos,
                Units = @this.Units,
            };

            return result;
        }

        public static users.Money ToMoney(this MoneyDto @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new users.Money
            {
                CurrencyCode = @this.CurrencyCode,
                Nanos = @this.Nanos,
                Units = @this.Units,
            };

            return result;
        }

        public static ImageDto ToImageDto(this users.Image @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new ImageDto
            {
                LowResUrl = @this.LowResUrl,
                Url = @this.Url,
            };

            return result;
        }

        public static users.Image ToUsersImage(this ImageDto @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new users.Image
            {
                LowResUrl = @this.LowResUrl,
                Url = @this.Url,
            };

            return result;
        }

        public static LocationDto ToLocationDto(this users.Location @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new LocationDto
            {
                GeoPoint = @this.GeoPoint.ToGeoPointDto(),
                Name = @this.Name,
            };

            return result;
        }

        public static users.Location ToUsersLocation(this LocationDto @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new users.Location
            {
                GeoPoint = @this.GeoPoint.ToUsersGeoPoint(),
                Name = @this.Name,
            };

            return result;
        }

        public static GeoPointDto ToGeoPointDto(this users.GeoPoint @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new GeoPointDto
            {
                Latitude = @this.Latitude,
                Longitude = @this.Longitude,
            };

            return result;
        }

        public static users.GeoPoint ToUsersGeoPoint(this GeoPointDto @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new users.GeoPoint
            {
                Latitude = @this.Latitude,
                Longitude = @this.Longitude,
            };

            return result;
        }

        public static SocialMediaAccountDto ToSocialMediaAccount(this users.SocialMediaAccount @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new SocialMediaAccountDto
            {
                AccessToken = @this.AccessToken,
                AccessTokenSecret = @this.AccessTokenSecret,
                AudienceSize = @this.AudienceSize,
                Description = @this.Description,
                DisplayName = @this.DisplayName,
                Email = @this.Email,
                PageId = @this.PageId,
                PostCount = @this.PostCount,
                ProfileUrl = @this.ProfileUrl,
                RefreshToken = @this.RefreshToken,
                SocialNetworkProviderId = @this.SocialNetworkProviderId,
                UserId = @this.UserId,
                IsVerified = @this.IsVerified,
            };

            return result;
        }

        public static users.SocialMediaAccount ToSocialMediaAccount(this SocialMediaAccountDto @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new users.SocialMediaAccount
            {
                AccessToken = @this.AccessToken,
                AccessTokenSecret = @this.AccessTokenSecret,
                AudienceSize = @this.AudienceSize,
                Description = @this.Description,
                DisplayName = @this.DisplayName,
                Email = @this.Email,
                PageId = @this.PageId,
                PostCount = @this.PostCount,
                ProfileUrl = @this.ProfileUrl,
                RefreshToken = @this.RefreshToken,
                SocialNetworkProviderId = @this.SocialNetworkProviderId,
                UserId = @this.UserId,
                IsVerified = @this.IsVerified,
            };

            return result;
        }

        public static UserType ToUserType(this users.UserType @this) =>
            (UserType)(int)@this;

        public static users.UserType ToUserType(this UserType @this) =>
            (users.UserType)(int)@this;

        public static UserDto.Types.Status ToStatus(this users.UserStatus @this) =>
            (UserDto.Types.Status)(int)@this;

        public static users.UserStatus ToUserStatus(this UserDto.Types.Status @this) =>
            (users.UserStatus)(int)@this;
    }
}
