using System.Threading.Tasks;
using Microsoft.ServiceFabric.Services.Remoting;

namespace InvitationCodes.Interfaces
{
    public interface IInvitationCodesService : IService
    {
        Task<string> Generate();

        Task<InvitationCodeStatus> GetStatus(string code);

        Task<InvitationCodeHonorResult> Honor(string code);
    }
}
