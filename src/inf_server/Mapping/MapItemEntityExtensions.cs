using Mapping.Interfaces;
using Offers.Interfaces;
using Utility.Mapping;

namespace Mapping
{
    public static class MapItemEntityExtensions
    {
        public static MapItemEntity ToEntity(this Offer @this, QuadKey quadKey)
        {
            if (@this == null)
            {
                return null;
            }

            return new MapItemEntity(
                quadKey.ToString(),
                @this.Id,
                @this.Status.ToEntity(),
                @this.UserId,
                @this.Location.ToEntity());
        }

        public static OfferMapItem ToOfferServiceObject(this MapItemEntity @this)
        {
            if (@this == null)
            {
                return null;
            }

            return new OfferMapItem(
                @this.Status.ToServiceObject(),
                @this.Location.ToServiceObject(),
                @this.Id,
                @this.UserId);
        }
    }
}
