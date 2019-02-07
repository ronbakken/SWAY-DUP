using System;
using Offers.Interfaces;

namespace Offers
{
    public static class OfferStatusEntityExtensions
    {
        public static OfferStatusEntity ToEntity(this OfferStatus @this)
        {
            switch (@this)
            {
                case OfferStatus.Active:
                    return OfferStatusEntity.Active;
                case OfferStatus.Inactive:
                    return OfferStatusEntity.Inactive;
                case OfferStatus.Unknown:
                    return OfferStatusEntity.Unknown;
                default:
                    throw new NotSupportedException();
            }
        }

        public static OfferStatus ToService(this OfferStatusEntity @this)
        {
            switch (@this)
            {
                case OfferStatusEntity.Active:
                    return OfferStatus.Active;
                case OfferStatusEntity.Inactive:
                    return OfferStatus.Inactive;
                case OfferStatusEntity.Unknown:
                    return OfferStatus.Unknown;
                default:
                    throw new NotSupportedException();
            }
        }
    }
}
