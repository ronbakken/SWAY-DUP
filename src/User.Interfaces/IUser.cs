using Microsoft.ServiceFabric.Actors;
using Microsoft.ServiceFabric.Actors.Remoting.FabricTransport;
using Microsoft.ServiceFabric.Services.Remoting;
using System.Threading.Tasks;

[assembly: FabricTransportActorRemotingProvider(RemotingListenerVersion = RemotingListenerVersion.V2_1, RemotingClientVersion = RemotingClientVersion.V2_1)]

namespace User.Interfaces
{
    /// <summary>
    /// Represents a user, which is identified by their user name.
    /// </summary>
    /// <remarks>
    /// <para>
    /// Each user actor represents the potential for a single end user in the system. However, the actor may exist
    /// independently of whether the user has actually been created. In this case, the <see cref="IsCreated"/> method will
    /// return <see langword="false"/>. Once <see cref="Create"/> has been called successfully, <see cref="IsCreated"/>
    /// will return <see langword="true"/>.
    /// </para>
    /// <para>
    /// A user that exists can be authenticated via the <see cref="Authenticate"/> method.
    /// </para>
    /// </remarks>
    public interface IUser : IActor
    {
        /// <summary>
        /// Determines whether the user has been created.
        /// </summary>
        /// <remarks>
        /// <para>
        /// A user actor can exist independently of whether the actual user has been created. However, once the user
        /// <i>has</i> been created (which is achieved by successfully calling <see cref="Create"/>), they will remain
        /// created.
        /// </para>
        /// <para>
        /// Really this is true only due to a limitation of the actor model. Service Fabric does not provide any means
        /// of determining the existence of an actor, since doing so would have dire performance implications.
        /// </para>
        /// </remarks>
        /// <returns>
        /// <see langword="true"/> if the user exists, otherwise <see langword="false"/>.
        /// </returns>
        Task<bool> IsCreated();

        /// <summary>
        /// Creates the user.
        /// </summary>
        /// <param name="password">
        /// The password for the user.
        /// </param>
        /// <param name="data">
        /// The data for the user.
        /// </param>
        /// <exception cref="InvalidOperationException">
        /// If the user has already been created.
        /// </exception>
        Task Create(string password, UserData data);

        /// <summary>
        /// Authenticates the user.
        /// </summary>
        /// <remarks>
        /// Authenticating the user does not change the state of the actor in any way. Specifically, the actor does not
        /// allow or deny method invocations based on whether this method has successfully been called. Authentication is
        /// handled by associating users with a session, which can only be achieved after successful authentication.
        /// </remarks>
        /// <param name="password">
        /// The user's password.
        /// </param>
        /// <returns>
        /// <see langword="true"/> if the user was successfully authenticated, otherwise <see langword="false"/>.
        /// </returns>
        /// <exception cref="InvalidOperationException">
        /// If the user has not yet been created.
        /// </exception>
        Task<bool> Authenticate(string password);

        /// <summary>
        /// Gets information about the user.
        /// </summary>
        /// <returns>
        /// The user data.
        /// </returns>
        /// <exception cref="InvalidOperationException">
        /// If the user has not yet been created.
        /// </exception>
        Task<UserData> GetData();

        /// <summary>
        /// Updates the user's information.
        /// </summary>
        /// <exception cref="InvalidOperationException">
        /// If the user has not yet been created.
        /// </exception>
        Task Update(UserData data);
    }
}
