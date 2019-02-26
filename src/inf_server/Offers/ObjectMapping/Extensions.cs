using System.Linq;
using Offers.Interfaces;

namespace Offers.ObjectMapping
{
    public static class Extensions
    {
        public static OfferEntity ToEntity(this Offer @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new OfferEntity
            {
                AcceptancePolicy = @this.AcceptancePolicy.ToEntity(),
                BusinessAccountId = @this.BusinessAccountId,
                BusinessAvatarThumbnailUrl = @this.BusinessAvatarThumbnailUrl,
                BusinessDescription = @this.BusinessDescription,
                BusinessName = @this.BusinessName,
                Created = @this.Created,
                Description = @this.Description,
                End = @this.End,
                Id = @this.Id,
                Location = @this.Location.ToEntity(),
                MinFollowers = @this.MinFollowers,
                NumberOffered = @this.NumberOffered,
                NumberRemaining = @this.NumberRemaining,
                Revision = @this.Revision,
                SchemaVersion = 1,
                Start = @this.Start,
                Status = @this.Status.ToEntity(),
                StatusReason = @this.StatusReason.ToEntity(),
                Terms = @this.Terms.ToEntity(),
                Thumbnail = @this.Thumbnail.ToEntity(),
                Title = @this.Title,
            };

            result.CategoryIds.AddRange(@this.CategoryIds);
            result.Images.AddRange(@this.Images.Select(x => x.ToEntity()));
            result.Keywords.AddRange(@this.Keywords);

            return result;
        }

        public static Offer ToServiceDto(this OfferEntity @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new Offer
            {
                AcceptancePolicy = @this.AcceptancePolicy.ToServiceDto(),
                BusinessAccountId = @this.BusinessAccountId,
                BusinessAvatarThumbnailUrl = @this.BusinessAvatarThumbnailUrl,
                BusinessDescription = @this.BusinessDescription,
                BusinessName = @this.BusinessName,
                Created = @this.Created,
                Description = @this.Description,
                End = @this.End,
                Id = @this.Id,
                Location = @this.Location.ToServiceDto(),
                MinFollowers = @this.MinFollowers,
                NumberOffered = @this.NumberOffered,
                NumberRemaining = @this.NumberRemaining,
                Revision = @this.Revision,
                Start = @this.Start,
                Status = @this.Status.ToServiceDto(),
                StatusReason = @this.StatusReason.ToServiceDto(),
                Terms = @this.Terms.ToServiceDto(),
                Thumbnail = @this.Thumbnail.ToServiceDto(),
                Title = @this.Title,
            };

            result.CategoryIds.AddRange(@this.CategoryIds);
            result.Images.AddRange(@this.Images.Select(x => x.ToServiceDto()));
            result.Keywords.AddRange(@this.Keywords);

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

        public static DealTermsEntity ToEntity(this DealTerms @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new DealTermsEntity
            {
                Deliverable = @this.Deliverable.ToEntity(),
                Reward = @this.Reward.ToEntity(),
            };

            return result;
        }

        public static DealTerms ToServiceDto(this DealTermsEntity @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new DealTerms
            {
                Deliverable = @this.Deliverable.ToServiceDto(),
                Reward = @this.Reward.ToServiceDto(),
            };

            return result;
        }

        public static DeliverableEntity ToEntity(this Deliverable @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new DeliverableEntity
            {
                Description = @this.Description,
                Id = @this.Id,
            };

            result.DeliverableTypes.AddRange(@this.DeliverableTypes.Select(x => x.ToEntity()));
            result.SocialNetworkProviderIds.AddRange(@this.SocialNetworkProviderIds);

            return result;
        }

        public static Deliverable ToServiceDto(this DeliverableEntity @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new Deliverable
            {
                Description = @this.Description,
                Id = @this.Id,
            };

            result.DeliverableTypes.AddRange(@this.DeliverableTypes.Select(x => x.ToServiceDto()));
            result.SocialNetworkProviderIds.AddRange(@this.SocialNetworkProviderIds);

            return result;
        }

        public static RewardEntity ToEntity(this Reward @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new RewardEntity
            {
                BarterValue = @this.BarterValue.ToEntity(),
                CashValue = @this.CashValue.ToEntity(),
                Description = @this.Description,
                Type = @this.Type.ToEntity(),
            };

            return result;
        }

        public static Reward ToServiceDto(this RewardEntity @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new Reward
            {
                BarterValue = @this.BarterValue.ToServiceDto(),
                CashValue = @this.CashValue.ToServiceDto(),
                Description = @this.Description,
                Type = @this.Type.ToServiceDto(),
            };

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

        public static OfferEntity.Types.AcceptancePolicy ToEntity(this OfferAcceptancePolicy @this) =>
            (OfferEntity.Types.AcceptancePolicy)(int)@this;

        public static OfferAcceptancePolicy ToServiceDto(this OfferEntity.Types.AcceptancePolicy @this) =>
            (OfferAcceptancePolicy)(int)@this;

        public static OfferEntity.Types.Status ToEntity(this OfferStatus @this) =>
            (OfferEntity.Types.Status)(int)@this;

        public static OfferStatus ToServiceDto(this OfferEntity.Types.Status @this) =>
            (OfferStatus)(int)@this;

        public static OfferEntity.Types.StatusReason ToEntity(this OfferStatusReason @this) =>
            (OfferEntity.Types.StatusReason)(int)@this;

        public static OfferStatusReason ToServiceDto(this OfferEntity.Types.StatusReason @this) =>
            (OfferStatusReason)(int)@this;

        public static DeliverableEntity.Types.Type ToEntity(this DeliverableType @this) =>
            (DeliverableEntity.Types.Type)(int)@this;

        public static DeliverableType ToServiceDto(this DeliverableEntity.Types.Type @this) =>
            (DeliverableType)(int)@this;

        public static RewardEntity.Types.Type ToEntity(this RewardType @this) =>
            (RewardEntity.Types.Type)(int)@this;

        public static RewardType ToServiceDto(this RewardEntity.Types.Type @this) =>
            (RewardType)(int)@this;
    }
}
