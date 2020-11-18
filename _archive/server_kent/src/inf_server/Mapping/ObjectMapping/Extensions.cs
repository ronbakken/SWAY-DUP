using System;
using System.Linq;
using Mapping.Interfaces;
using Offers.Interfaces;
using Users.Interfaces;
using mapping = Mapping.Interfaces;
using offers = Offers.Interfaces;
using users = Users.Interfaces;

namespace Mapping.ObjectMapping
{
    public static class Extensions
    {
        public static MapItemEntity ToMapItemEntity(this Offer @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new MapItemEntity
            {
                SchemaType = "mapItem",
                SchemaVersion = 1,
                GeoPoint = @this.Location?.GeoPoint.ToGeoPointEntity(),
                Id = @this.Id,
                Status = @this.Status.ToStatus(),
            };

            result.CategoryIds.AddRange(@this.CategoryIds);
            result.Keywords.AddRange(@this.Keywords);
            result.Offer = @this.ToOfferEntity();

            return result;
        }

        public static MapItemEntity ToMapItemEntity(this User @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new MapItemEntity
            {
                SchemaType = "mapItem",
                SchemaVersion = 1,
                GeoPoint = @this.Location?.GeoPoint.ToGeoPointEntity(),
                Id = @this.Id,
                Status = @this.Status.ToStatus(),
            };

            result.CategoryIds.AddRange(@this.CategoryIds);
            result.Keywords.AddRange(@this.Keywords);
            result.User = @this.ToUserEntity();

            return result;
        }

        public static MapItem ToMapItem(this MapItemEntity @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new MapItem
            {
                GeoPoint = @this.GeoPoint.ToGeoPoint(),
                Status = @this.Status.ToStatus(),
            };

            switch (@this.DataCase)
            {
                case MapItemEntity.DataOneofCase.Offer:
                    result.Offer = @this.ToOfferMapItem();
                    break;
                case MapItemEntity.DataOneofCase.User:
                    result.User = @this.ToUserMapItem();
                    break;
                default:
                    throw new NotSupportedException();
            }

            return result;
        }

        public static MapItemEntity.Types.OfferEntity ToOfferEntity(this Offer @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new MapItemEntity.Types.OfferEntity
            {
                AcceptancePolicy = @this.AcceptancePolicy.ToAcceptancePolicy(),
                BusinessAccountId = @this.BusinessAccountId,
                CashReward = @this.Terms?.CashValue?.ToMoneyEntity(),
                ServiceReward = @this.Terms?.ServiceValue?.ToMoneyEntity(),
                Status = @this.Status.ToEntityStatus(),
            };

            result.DeliverableTypes.AddRange(@this.Terms.Deliverable.DeliverableTypes.Select(x => x.ToDeliverableType()));
            result.DeliverableSocialNetworkProviderIds.AddRange(@this.Terms.Deliverable.SocialNetworkProviderIds);

            return result;
        }


        public static MapItemEntity.Types.UserEntity ToUserEntity(this User @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new MapItemEntity.Types.UserEntity
            {
                Type = @this.Type.ToUserType(),
                MinimalFee = @this.MinimalFee.ToMoneyEntity(),
            };

            result.SocialMediaNetworkIds.AddRange(@this.SocialMediaAccounts.Select(x => x.SocialNetworkProviderId));

            return result;
        }

        public static MoneyEntity ToMoneyEntity(this offers.Money @this)
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

        public static MoneyEntity ToMoneyEntity(this users.Money @this)
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

        public static GeoPointEntity ToGeoPointEntity(this offers.GeoPoint @this)
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

        public static GeoPointEntity ToGeoPointEntity(this users.GeoPoint @this)
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

        public static mapping.GeoPoint ToGeoPoint(this GeoPointEntity @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new mapping.GeoPoint
            {
                Latitude = @this.Latitude,
                Longitude = @this.Longitude,
            };

            return result;
        }

        public static MapItemEntity.Types.Status ToStatus(this OfferStatus @this)
        {
            switch (@this)
            {
                case OfferStatus.Active:
                    return MapItemEntity.Types.Status.Active;
                case OfferStatus.Inactive:
                    return MapItemEntity.Types.Status.Inactive;
                default:
                    return MapItemEntity.Types.Status.Unknown;
            }
        }

        public static MapItemEntity.Types.Status ToStatus(this UserStatus @this)
        {
            switch (@this)
            {
                case UserStatus.Active:
                    return MapItemEntity.Types.Status.Active;
                // TODO: don't think this is correct. We might need a deleted (inactive) flag for users.
                case UserStatus.Disabled:
                    return MapItemEntity.Types.Status.Inactive;
                default:
                    return MapItemEntity.Types.Status.Unknown;
            }
        }

        public static OfferMapItem ToOfferMapItem(this MapItemEntity @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new OfferMapItem
            {
                OfferId = @this.Id,
            };

            return result;
        }

        public static UserMapItem ToUserMapItem(this MapItemEntity @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new UserMapItem
            {
                UserId = @this.Id,
            };

            return result;
        }

        public static MapItem.Types.Status ToStatus(this MapItemEntity.Types.Status @this) =>
            (MapItem.Types.Status)(int)@this;

        public static MapItemEntity.Types.OfferEntity.Types.AcceptancePolicy ToAcceptancePolicy(this OfferAcceptancePolicy @this) =>
            (MapItemEntity.Types.OfferEntity.Types.AcceptancePolicy)(int)@this;

        public static OfferAcceptancePolicy ToAcceptancePolicy(this MapItemEntity.Types.OfferEntity.Types.AcceptancePolicy @this) =>
            (OfferAcceptancePolicy)(int)@this;

        public static MapItemEntity.Types.OfferEntity.Types.Status ToEntityStatus(this OfferStatus @this) =>
            (MapItemEntity.Types.OfferEntity.Types.Status)(int)@this;

        public static MapItemEntity.Types.UserEntity.Types.UserType ToUserType(this UserType @this) =>
            (MapItemEntity.Types.UserEntity.Types.UserType)(int)@this;

        public static UserType ToUserType(this MapItemEntity.Types.UserEntity.Types.UserType @this) =>
            (UserType)(int)@this;

        public static MapItemEntity.Types.OfferEntity.Types.AcceptancePolicy ToAcceptancePolicy(this ListMapItemsRequest.Types.Filter.Types.OfferFilterDto.Types.AcceptancePolicy @this) =>
            (MapItemEntity.Types.OfferEntity.Types.AcceptancePolicy)(int)@this;

        public static MapItemEntity.Types.OfferEntity.Types.DeliverableType ToDeliverableType(this ListMapItemsRequest.Types.Filter.Types.OfferFilterDto.Types.DeliverableType @this) =>
            (MapItemEntity.Types.OfferEntity.Types.DeliverableType)(int)@this;

        public static MapItemEntity.Types.OfferEntity.Types.Status ToStatus(this ListMapItemsRequest.Types.Filter.Types.OfferFilterDto.Types.Status @this) =>
            (MapItemEntity.Types.OfferEntity.Types.Status)(int)@this;

        public static MapItemEntity.Types.UserEntity.Types.UserType ToUserType(this ListMapItemsRequest.Types.Filter.Types.UserFilterDto.Types.Type @this) =>
            (MapItemEntity.Types.UserEntity.Types.UserType)(int)@this;

        public static MapItemEntity.Types.OfferEntity.Types.DeliverableType ToDeliverableType(this DeliverableType @this) =>
            (MapItemEntity.Types.OfferEntity.Types.DeliverableType)(int)@this;

        public static DeliverableType ToDeliverableType(this MapItemEntity.Types.OfferEntity.Types.DeliverableType @this) =>
            (DeliverableType)(int)@this;
    }
}
