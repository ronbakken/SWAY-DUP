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
                Id = @this.Id.OptionalOr(null),
                GeoPoint = @this.Location.ToDto(),
                Status = @this.Status.ToApi(),
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
                @this.Status.ToService(),
                userId,
                @this.GeoPoint.ToServiceObject());
        }
    }
}
