using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.ServiceFabric.Services.Remoting;

namespace Users.Interfaces
{
    public interface IUsersService : IService
    {
        Task<UserData> GetUserData(string userId);

        Task<UserData> GetUserDataByEmail(string email);

        Task<UserData> SaveUserData(UserData userData);

        Task<UserSession> GetUserSession(string refreshToken);

        Task<UserSession> SaveUserSession(UserSession userSession);

        Task InvalidateUserSession(string refreshToken);

        Task<List<UserData>> Search(SearchFilter filter);
    }
}
