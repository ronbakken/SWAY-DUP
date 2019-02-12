using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.ServiceFabric.Services.Remoting;

namespace Mapping.Interfaces
{
    public interface IMappingService : IService
    {
        Task<List<MapItem>> Search(SearchFilter filter);
    }
}
