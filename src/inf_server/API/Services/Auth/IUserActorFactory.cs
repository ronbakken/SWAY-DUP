using User.Interfaces;

namespace API.Services.Auth
{
    public interface IUserActorFactory
    {
        IUser Get(string userId);
    }
}
