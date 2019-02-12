using System;
using API.Interfaces;
using Mapping.Interfaces;

namespace API.Services.Mapping
{
    public static class MapItemExtensions
    {
        public static MapItemDto ToDto(this MapItem @this)
        {
            if (@this == null)
            {
                return null;
            }

            var result = new MapItemDto
            {
                Status = @this.Status.ToDto(),
                GeoPoint = @this.Location.ToDto(),
            };

            if (@this is OfferMapItem offerMapItem)
            {
                result.Offer = offerMapItem.ToDto();
            }
            else
            {
                throw new NotSupportedException();
            }

            result.ParentClusterId = "TODO";

            return result;
        }

        public static OfferMapItemDto ToDto(this OfferMapItem @this)
        {
            if (@this == null)
            {
                return null;
            }

            return new OfferMapItemDto
            {
                OfferId = @this.OfferId,
                UserId = @this.UserId,
            };
        }
    }
}
