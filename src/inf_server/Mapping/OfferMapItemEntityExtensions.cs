using Mapping.Interfaces;
using Offers.Interfaces;
using Utility.Mapping;

namespace Mapping
{
    public static class OfferMapItemEntityExtensions
    {
        public static OfferMapItemEntity ToEntity(this Offer @this, QuadKey quadKey)
        {
            if (@this == null)
            {
                return null;
            }

            return new OfferMapItemEntity(quadKey.ToString(), @this.Id, @this.UserId, @this.Location.ToEntity());
        }

        public static OfferMapItem ToServiceObject(this OfferMapItemEntity @this)
        {
            if (@this == null)
            {
                return null;
            }

            return new OfferMapItem(
                @this.OfferId,
                @this.UserId,
                @this.Location.ToServiceObject());
        }
    }
}
