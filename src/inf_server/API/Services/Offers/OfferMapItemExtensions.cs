using API.Interfaces;
using Mapping.Interfaces;

namespace API.Services.Offers
{
    public static class OfferMapItemExtensions
    {
        public static OfferMapItemDto ToDto(this OfferMapItem @this)
        {
            if (@this == null)
            {
                return null;
            }

            return new OfferMapItemDto
            {
                GeoPoint = @this.Location.ToDto(),
            };
        }
    }
}
