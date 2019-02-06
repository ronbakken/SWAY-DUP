using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.ServiceFabric.Services.Remoting;
using Offers.Interfaces;

namespace Mapping.Interfaces
{
    public interface IMappingService : IService
    {
        Task AddOffer(Offer offer);

        Task RemoveOffer(Offer offer);

        Task<List<OfferMapItem>> Search(OfferSearchFilter filter);
    }
}
