using System;
using Mapping.Interfaces;
using Offers.Interfaces;

namespace Mapping
{
    public static class MapItemStatusEntityExtensions
    {
        public static MapItemStatusEntity ToEntity(this MapItemStatus @this)
        {
            switch (@this)
            {
                case MapItemStatus.Active:
                    return MapItemStatusEntity.Active;
                case MapItemStatus.Inactive:
                    return MapItemStatusEntity.Inactive;
                default:
                    throw new NotSupportedException();
            }
        }

        public static MapItemStatusEntity ToEntity(this OfferStatus @this)
        {
            switch (@this)
            {
                case OfferStatus.Active:
                    return MapItemStatusEntity.Active;
                case OfferStatus.Inactive:
                    return MapItemStatusEntity.Inactive;
                default:
                    throw new NotSupportedException();
            }
        }

        public static MapItemStatus ToServiceObject(this MapItemStatusEntity @this)
        {
            switch (@this)
            {
                case MapItemStatusEntity.Active:
                    return MapItemStatus.Active;
                case MapItemStatusEntity.Inactive:
                    return MapItemStatus.Inactive;
                default:
                    throw new NotSupportedException();
            }
        }
    }
}
