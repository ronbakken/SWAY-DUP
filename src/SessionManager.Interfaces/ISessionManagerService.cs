using System.Threading.Tasks;
using Microsoft.ServiceFabric.Services.Remoting;

namespace SessionManager.Interfaces
{
    public interface ISessionManagerService : IService
    {
        Task<string> CreateSession();
    }
}
