using System.Threading.Tasks;
using Microsoft.ServiceFabric.Actors;
using Microsoft.ServiceFabric.Actors.Remoting.FabricTransport;
using Microsoft.ServiceFabric.Services.Remoting;

[assembly: FabricTransportActorRemotingProvider(RemotingListenerVersion = RemotingListenerVersion.V2_1, RemotingClientVersion = RemotingClientVersion.V2_1)]

namespace RefreshToken.Interfaces
{
    public interface IRefreshToken : IActor
    {
        Task<string> GetAssociatedUserId();

        Task<string> GetAssociatedDeviceId();

        Task Associate(string userId, string deviceId);

        Task Invalidate();
    }
}
