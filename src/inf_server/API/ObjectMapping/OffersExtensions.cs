using System;
using System.Linq;
using API.Interfaces;
using offers = Offers.Interfaces;

namespace API.ObjectMapping
{
    public static class OffersExtensions
    {
        public static OfferDto ToOfferDto(this offers.Offer @this, OfferDto.DataOneofCase dataDenomination)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new OfferDto
            {
                Id = @this.Id,
                Revision = @this.Revision,
                Location = @this.Location.ToLocationDto(),
                Status = @this.Status.ToStatus(),
                StatusReason = @this.StatusReason.ToStatusReason(),
            };

            switch (dataDenomination)
            {
                case OfferDto.DataOneofCase.Full:
                    result.Full = @this.ToFullDataDto();
                    break;
                case OfferDto.DataOneofCase.List:
                    result.List = @this.ToListDataDto();
                    break;
                default:
                    throw new NotSupportedException();
            }

            return result;
        }

        public static offers.Offer ToOffer(this OfferDto @this)
        {
            if (@this == null)
            {
                return null;
            }

            if (@this.DataCase != OfferDto.DataOneofCase.Full)
            {
                throw new NotSupportedException("Can only convert from full data.");
            }

            var result = new offers.Offer
            {
                AcceptancePolicy = @this.Full.AcceptancePolicy.ToOfferAcceptancePolicy(),
                BusinessAccountId = @this.Full.BusinessAccountId,
                BusinessAvatarThumbnailUrl = @this.Full.BusinessAvatarThumbnailUrl,
                BusinessDescription = @this.Full.BusinessDescription,
                BusinessName = @this.Full.BusinessName,
                Created = @this.Full.Created,
                Description = @this.Full.Description,
                End = @this.Full.End,
                Id = @this.Id,
                Location = @this.Location.ToOffersLocation(),
                MinFollowers = @this.Full.MinFollowers,
                NumberOffered = @this.Full.NumberOffered,
                NumberRemaining = @this.Full.NumberRemaining,
                Revision = @this.Revision,
                Start = @this.Full.Start,
                Status = @this.Status.ToOfferStatus(),
                StatusReason = @this.StatusReason.ToOfferStatusReason(),
                Terms = @this.Full.Terms.ToDealTerms(),
                Thumbnail = @this.Full.Thumbnail.ToOffersImage(),
                Title = @this.Full.Title,
            };

            result.CategoryIds.AddRange(@this.Full.CategoryIds);
            result.Images.AddRange(@this.Full.Images.Select(x => x.ToOffersImage()));

            return result;
        }

        public static OfferDto.Types.FullDataDto ToFullDataDto(this offers.Offer @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new OfferDto.Types.FullDataDto
            {
                AcceptancePolicy = @this.AcceptancePolicy.ToAcceptancePolicy(),
                BusinessAccountId = @this.BusinessAccountId,
                BusinessAvatarThumbnailUrl = @this.BusinessAvatarThumbnailUrl,
                BusinessDescription = @this.BusinessDescription,
                BusinessName = @this.BusinessName,
                Created = @this.Created,
                Description = @this.Description,
                End = @this.End,
                MinFollowers = @this.MinFollowers,
                NumberOffered = @this.NumberOffered,
                NumberRemaining = @this.NumberRemaining,
                Start = @this.Start,
                Terms = @this.Terms.ToDealTermsDto(),
                Thumbnail = @this.Thumbnail.ToImageDto(),
                Title = @this.Title,
            };

            result.CategoryIds.AddRange(@this.CategoryIds);
            result.Images.AddRange(@this.Images.Select(x => x.ToImageDto()));

            return result;
        }

        public static OfferDto.Types.ListDataDto ToListDataDto(this offers.Offer @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new OfferDto.Types.ListDataDto
            {
                BusinessAccountId = @this.BusinessAccountId,
                BusinessAvatarThumbnailUrl = @this.BusinessAvatarThumbnailUrl,
                BusinessDescription = @this.BusinessDescription,
                BusinessName = @this.BusinessName,
                Created = @this.Created,
                Description = @this.Description,
                End = @this.End,
                NumberOffered = @this.NumberOffered,
                NumberRemaining = @this.NumberRemaining,
                Start = @this.Start,
                Title = @this.Title,
            };

            return result;
        }

        public static DealTermsDto ToDealTermsDto(this offers.DealTerms @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new DealTermsDto
            {
                Deliverable = @this.Deliverable.ToDeliverableDto(),
                Reward = @this.Reward.ToRewardDto(),
            };

            return result;
        }

        public static offers.DealTerms ToDealTerms(this DealTermsDto @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new offers.DealTerms
            {
                Deliverable = @this.Deliverable.ToDeliverable(),
                Reward = @this.Reward.ToReward(),
            };

            return result;
        }

        public static DeliverableDto ToDeliverableDto(this offers.Deliverable @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new DeliverableDto
            {
                Description = @this.Description,
                Id = @this.Id,
            };

            result.DeliverableTypes.AddRange(@this.DeliverableTypes.Select(x => x.ToDeliverableType()));
            result.SocialNetworkProviderIds.AddRange(@this.SocialNetworkProviderIds);

            return result;
        }

        public static offers.Deliverable ToDeliverable(this DeliverableDto @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new offers.Deliverable
            {
                Description = @this.Description,
                Id = @this.Id,
            };

            result.DeliverableTypes.AddRange(@this.DeliverableTypes.Select(x => x.ToDeliverableType()));
            result.SocialNetworkProviderIds.AddRange(@this.SocialNetworkProviderIds);

            return result;
        }

        public static RewardDto ToRewardDto(this offers.Reward @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new RewardDto
            {
                BarterValue = @this.BarterValue.ToMoneyDto(),
                CashValue = @this.CashValue.ToMoneyDto(),
                Description = @this.Description,
                Type = @this.Type.ToType(),
            };

            return result;
        }

        public static offers.Reward ToReward(this RewardDto @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new offers.Reward
            {
                BarterValue = @this.BarterValue.ToOffersMoney(),
                CashValue = @this.CashValue.ToOffersMoney(),
                Description = @this.Description,
                Type = @this.Type.ToRewardType(),
            };

            return result;
        }

        public static MoneyDto ToMoneyDto(this offers.Money @this)
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

        public static ImageDto ToImageDto(this offers.Image @this)
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

        public static offers.Image ToOffersImage(this ImageDto @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new offers.Image
            {
                LowResUrl = @this.LowResUrl,
                Url = @this.Url,
            };

            return result;
        }

        public static LocationDto ToLocationDto(this offers.Location @this)
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

        public static offers.Location ToOffersLocation(this LocationDto @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new offers.Location
            {
                GeoPoint = @this.GeoPoint.ToOffersGeoPoint(),
                Name = @this.Name,
            };

            return result;
        }

        public static GeoPointDto ToGeoPointDto(this offers.GeoPoint @this)
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

        public static offers.GeoPoint ToOffersGeoPoint(this GeoPointDto @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new offers.GeoPoint
            {
                Latitude = @this.Latitude,
                Longitude = @this.Longitude,
            };

            return result;
        }

        public static OfferDto.Types.Status ToStatus(this offers.OfferStatus @this) =>
            (OfferDto.Types.Status)(int)@this;

        public static offers.OfferStatus ToOfferStatus(this OfferDto.Types.Status @this) =>
            (offers.OfferStatus)(int)@this;

        public static OfferDto.Types.StatusReason ToStatusReason(this offers.OfferStatusReason @this) =>
            (OfferDto.Types.StatusReason)(int)@this;

        public static offers.OfferStatusReason ToOfferStatusReason(this OfferDto.Types.StatusReason @this) =>
            (offers.OfferStatusReason)(int)@this;

        public static OfferDto.Types.AcceptancePolicy ToAcceptancePolicy(this offers.OfferAcceptancePolicy @this) =>
            (OfferDto.Types.AcceptancePolicy)(int)@this;

        public static offers.OfferAcceptancePolicy ToOfferAcceptancePolicy(this OfferDto.Types.AcceptancePolicy @this) =>
            (offers.OfferAcceptancePolicy)(int)@this;

        public static DeliverableType ToDeliverableType(this offers.DeliverableType @this) =>
            (DeliverableType)(int)@this;

        public static offers.DeliverableType ToDeliverableType(this DeliverableType @this) =>
            (offers.DeliverableType)(int)@this;

        public static RewardDto.Types.Type ToType(this offers.RewardType @this) =>
            (RewardDto.Types.Type)(int)@this;

        public static offers.RewardType ToRewardType(this RewardDto.Types.Type @this) =>
            (offers.RewardType)(int)@this;
    }
}
