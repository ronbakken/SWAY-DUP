using API.Interfaces;
using Mapping.Interfaces;

namespace API.Services.Mapping
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
                ClusterId = @this.ClusterId,
                OfferId = @this.OfferId,
                UserId = @this.UserId,
            };
        }
    }
}
