using Microsoft.ServiceFabric.Actors;
using Microsoft.ServiceFabric.Actors.Remoting.FabricTransport;
using Microsoft.ServiceFabric.Services.Remoting;
using System.Threading.Tasks;

[assembly: FabricTransportActorRemotingProvider(RemotingListenerVersion = RemotingListenerVersion.V2_1, RemotingClientVersion = RemotingClientVersion.V2_1)]

namespace Session.Interfaces
{
    /// <summary>
    /// Represents a session, which is identified by a token.
    /// </summary>
    /// <remarks>
    /// <para>
    /// Sessions act as a level of indirection between users and the device from which they're accessing the application.
    /// More specifically, a session <i>optionally</i> associates a user with an opaque token. Clients pass through session
    /// tokens on every relevant request. For any API call, the server is then able to determine whether a session has been
    /// established and, if so, whether a user has been associated with the session. It can use this information to allow
    /// or deny the call.
    /// </para>
    /// <para>
    /// Associating a user with a session is achieved via the <see cref="Login"/> method. Upon successful invocation of this
    /// method, that user remains associated with the session until <see cref="Logout"/> is called.
    /// </para>
    /// <para>
    /// The token identifying a session should be treated as opaque by clients. They simply need to pass it through to the
    /// server with each call (via the <c>Authorization</c> header).
    /// </para>
    /// </remarks>
    public interface ISession : IActor
    {
        /// <summary>
        /// Attempts to associate a user with this session.
        /// </summary>
        /// <param name="userName">
        /// The user name for the user.
        /// </param>
        /// <param name="password">
        /// The password for the user.
        /// </param>
        /// <returns>
        /// <see langword="true"/> if the user is successfully logged in and associated with this session, otherwise
        /// <see langword="false"/>.
        /// </returns>
        Task<bool> Login(string userName, string password);

        /// <summary>
        /// Disassociates the user that is currently attached to this session. If no user is currently associated with the
        /// session, this method will return <see langword="false"/>.
        /// </summary>
        /// <returns>
        /// <see langword="true"/> if the associated user is logged out and disassociated with this session, otherwise
        /// <see langword="false"/>.
        /// </returns>
        Task<bool> Logout();

        /// <summary>
        /// Gets the ID of the user associated with this session.
        /// </summary>
        /// <returns>
        /// The ID of the user associated with this session, or <see langword="null"/> if no user is associated
        /// </returns>
        Task<string> GetAssociatedUserId();
    }
}
