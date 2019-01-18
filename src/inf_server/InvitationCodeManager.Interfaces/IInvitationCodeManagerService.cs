using System.Threading.Tasks;
using Microsoft.ServiceFabric.Services.Remoting;

namespace InvitationCodeManager.Interfaces
{
    public interface IInvitationCodeManagerService : IService
    {
        Task<string> Generate();

        Task<InvitationCodeStatus> GetStatus(string invitationCode);

        Task<InvitationCodeUseResult> Use(string invitationCode);
    }
}
