using API.Interfaces;
using Offers.Interfaces;

namespace API.Services.Offers
{
    public static class OfferExtensions
    {
        public static OfferDto ToDto(this Offer @this)
        {
            if (@this == null)
            {
                return null;
            }

            return new OfferDto
            {
                GeoPoint = @this.Location.ToDto(),
            };
        }

        public static Offer ToServiceObject(this OfferDto @this, string userId)
        {
            if (@this == null)
            {
                return null;
            }

            return new Offer(
                @this.Id.ValueOr(null),
                userId,
                @this.GeoPoint.ToServiceObject());
        }
    }
}
