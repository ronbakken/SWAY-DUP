using System;
using API.Interfaces;
using mapping = Mapping.Interfaces;
using offers = Offers.Interfaces;
using users = Users.Interfaces;

namespace API.ObjectMapping
{
    public static class ListExtensions
    {
        public static ItemDto ToItemDto(this mapping.MapItem @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new ItemDto
            {
                MapItem = @this.ToMapItemDto(),
            };

            return result;
        }

        public static ItemDto ToItemDto(this offers.Offer @this, OfferDto.DataOneofCase dataDenomination)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new ItemDto
            {
                Offer = @this.ToOfferDto(dataDenomination),
            };

            return result;
        }

        public static ItemDto ToItemDto(this users.User @this, UserDto.DataOneofCase dataDenomination)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new ItemDto
            {
                User = @this.ToUserDto(dataDenomination),
            };

            return result;
        }

        public static MapItemDto ToMapItemDto(this mapping.MapItem @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new MapItemDto
            {
                GeoPoint = @this.GeoPoint.ToGeoPointDto(),
                Status = @this.Status.ToMapItemStatus(),
            };

            switch (@this.PayloadCase)
            {
                case mapping.MapItem.PayloadOneofCase.Offer:
                    result.Offer = @this.Offer.ToOfferMapItemDto();
                    break;
                case mapping.MapItem.PayloadOneofCase.User:
                    result.User = @this.User.ToUserMapItemDto();
                    break;
                default:
                    throw new NotSupportedException();
            }

            return result;
        }

        public static OfferMapItemDto ToOfferMapItemDto(this mapping.OfferMapItem @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new OfferMapItemDto
            {
                OfferId = @this.OfferId,
            };

            return result;
        }

        public static UserMapItemDto ToUserMapItemDto(this mapping.UserMapItem @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new UserMapItemDto
            {
                UserId = @this.UserId,
            };

            return result;
        }

        public static GeoPointDto ToGeoPointDto(this mapping.GeoPoint @this)
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

        public static mapping.GeoPoint ToMappingGeoPoint(this GeoPointDto @this)
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

        public static mapping.Money ToMappingMoney(this MoneyDto @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new mapping.Money
            {
                CurrencyCode = @this.CurrencyCode,
                Nanos = @this.Nanos,
                Units = @this.Units,
            };

            return result;
        }

        public static offers.Money ToOffersMoney(this MoneyDto @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new offers.Money
            {
                CurrencyCode = @this.CurrencyCode,
                Nanos = @this.Nanos,
                Units = @this.Units,
            };

            return result;
        }

        public static MapItemDto.Types.MapItemStatus ToMapItemStatus(this mapping.MapItem.Types.Status @this) =>
            (MapItemDto.Types.MapItemStatus)(int)@this;

        public static mapping.ListMapItemsRequest.Types.Filter.Types.ItemType ToItemType(this ItemFilterDto.Types.ItemType @this) =>
            (mapping.ListMapItemsRequest.Types.Filter.Types.ItemType)(int)@this;

        public static mapping.ListMapItemsRequest.Types.Filter.Types.OfferFilterDto.Types.AcceptancePolicy ToAcceptancePolicy(this OfferDto.Types.AcceptancePolicy @this) =>
            (mapping.ListMapItemsRequest.Types.Filter.Types.OfferFilterDto.Types.AcceptancePolicy)(int)@this;

        public static mapping.ListMapItemsRequest.Types.Filter.Types.OfferFilterDto.Types.DeliverableType ToListFilterDeliverableType(this DeliverableType @this) =>
            (mapping.ListMapItemsRequest.Types.Filter.Types.OfferFilterDto.Types.DeliverableType)(int)@this;

        public static mapping.ListMapItemsRequest.Types.Filter.Types.OfferFilterDto.Types.Status ToStatus(this OfferDto.Types.Status @this) =>
            (mapping.ListMapItemsRequest.Types.Filter.Types.OfferFilterDto.Types.Status)(int)@this;

        public static mapping.ListMapItemsRequest.Types.Filter.Types.OfferFilterDto.Types.RewardType ToListFilterRewardType(this RewardDto.Types.Type @this) =>
            (mapping.ListMapItemsRequest.Types.Filter.Types.OfferFilterDto.Types.RewardType)(int)@this;

        public static mapping.ListMapItemsRequest.Types.Filter.Types.UserFilterDto.Types.Type ToType(this UserType @this) =>
            (mapping.ListMapItemsRequest.Types.Filter.Types.UserFilterDto.Types.Type)(int)@this;
    }
}
