using System.Threading.Tasks;
using Microsoft.ServiceFabric.Services.Remoting;

namespace Offers.Interfaces
{
    public interface IOffersService : IService
    {
        Task<Offer> SaveOffer(Offer offer);

        Task<Offer> RemoveOffer(Offer offer);
    }
}
