using System;
using Offers.Interfaces;
using api = API.Interfaces;

namespace API.Services.Offers
{
    public static class OfferStatusExtensions
    {
        public static OfferStatus ToService(this api.OfferStatus @this)
        {
            switch (@this)
            {
                case api.OfferStatus.Active:
                    return OfferStatus.Active;
                case api.OfferStatus.Inactive:
                    return OfferStatus.Inactive;
                case api.OfferStatus.UnknownOfferStatus:
                    return OfferStatus.Unknown;
                default:
                    throw new NotSupportedException();
            }
        }

        public static api.OfferStatus ToApi(this OfferStatus @this)
        {
            switch (@this)
            {
                case OfferStatus.Active:
                    return api.OfferStatus.Active;
                case OfferStatus.Inactive:
                    return api.OfferStatus.Inactive;
                case OfferStatus.Unknown:
                    return api.OfferStatus.UnknownOfferStatus;
                default:
                    throw new NotSupportedException();
            }
        }
    }
}
