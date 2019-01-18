using System.Threading.Tasks;
using Microsoft.ServiceFabric.Actors;
using Microsoft.ServiceFabric.Actors.Remoting.FabricTransport;
using Microsoft.ServiceFabric.Services.Remoting;
using NodaTime;

[assembly: FabricTransportActorRemotingProvider(RemotingListenerVersion = RemotingListenerVersion.V2_1, RemotingClientVersion = RemotingClientVersion.V2_1)]
namespace InvitationCode.Interfaces
{
    /// <summary>
    /// Represents an invitation code.
    /// </summary>
    /// <remarks>
    /// <para>
    /// Invitation codes permit access to a front-end application user. They will be used temporarily to prevent the
    /// general public from using the application.
    /// </para>
    /// </remarks>
    public interface IInvitationCode : IActor
    {
        /// <summary>
        /// Gets the expiry time for the invitation code.
        /// </summary>
        /// <returns>
        /// The expiry, represented as an instant in time.
        /// </returns>
        Task<Instant> GetExpiry();

        /// <summary>
        /// Determines whether the invitation code has expired.
        /// </summary>
        /// <returns>
        /// <see langword="true"/> if expired, otherwise <see langword="false"/>.
        /// </returns>
        Task<bool> IsExpired();

        /// <summary>
        /// Uses the invitation code.
        /// </summary>
        /// <returns>
        /// A value indicating the result of using the invitation code.
        /// </returns>
        Task<InvitationCodeUseResult> Use();

        /// <summary>
        /// Determines whether the invitation code has been used.
        /// </summary>
        /// <returns>
        /// <see langword="true"/> if used, otherwise <see langword="false"/>.
        /// </returns>
        Task<bool> IsUsed();
    }
}
