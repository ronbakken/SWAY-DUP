using NodaTime;
using Offers.Interfaces;

namespace Offers
{
    public static class OfferEntityExtensions
    {
        public static OfferEntity ToEntity(this Offer @this)
        {
            if (@this == null)
            {
                return null;
            }

            return new OfferEntity(
                @this.Id,
                @this.Status.ToEntity(),
                new ZonedDateTime(),
                @this.UserId,
                @this.Location.ToEntity());
        }

        public static Offer ToServiceObject(this OfferEntity @this)
        {
            if (@this == null)
            {
                return null;
            }

            return new Offer(
                @this.Id,
                @this.Status.ToService(),
                @this.UserId,
                @this.Location.ToServiceObject());
        }
    }
}
