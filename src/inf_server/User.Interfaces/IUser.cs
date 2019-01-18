using System.Threading.Tasks;
using Microsoft.ServiceFabric.Actors;
using Microsoft.ServiceFabric.Actors.Remoting.FabricTransport;
using Microsoft.ServiceFabric.Services.Remoting;

[assembly: FabricTransportActorRemotingProvider(RemotingListenerVersion = RemotingListenerVersion.V2_1, RemotingClientVersion = RemotingClientVersion.V2_1)]

namespace User.Interfaces
{
    /// <summary>
    /// Represents a user, which is identified by their ID (email).
    /// </summary>
    public interface IUser : IActor
    {
        /// <summary>
        /// Gets the user's data.
        /// </summary>
        /// <returns>
        /// The user data.
        /// </returns>
        Task<UserData> GetData();

        /// <summary>
        /// Sets the user's data.
        /// </summary>
        Task SetData(UserData data);
    }
}
