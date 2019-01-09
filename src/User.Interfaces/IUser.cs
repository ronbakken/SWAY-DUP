using Microsoft.ServiceFabric.Actors;
using Microsoft.ServiceFabric.Actors.Remoting.FabricTransport;
using Microsoft.ServiceFabric.Services.Remoting;
using System.Threading;
using System.Threading.Tasks;

[assembly: FabricTransportActorRemotingProvider(RemotingListenerVersion = RemotingListenerVersion.V2_1, RemotingClientVersion = RemotingClientVersion.V2_1)]

namespace User.Interfaces
{
    public interface IUser : IActor
    {
        Task<string> GetName(CancellationToken cancellationToken = default);

        Task SetName(string name, CancellationToken cancellationToken = default);
    }
}
