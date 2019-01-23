using System.Threading.Tasks;
using Microsoft.ServiceFabric.Services.Remoting;

namespace Users.Interfaces
{
    public interface IUsersService : IService
    {
        Task<UserData> GetUserData(string userId);

        Task SaveUserData(string userId, UserData userData);

        Task<UserSession> GetUserSession(string refreshToken);

        Task SaveUserSession(UserSession userSession);

        Task InvalidateUserSession(string refreshToken);
    }
}
