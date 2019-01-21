using System;
using System.Threading.Tasks;
using Microsoft.ServiceFabric.Actors;
using Microsoft.ServiceFabric.Actors.Runtime;
using RefreshToken.Interfaces;

namespace RefreshToken
{
    [StatePersistence(StatePersistence.Persisted)]
    internal class RefreshToken : Actor, IRefreshToken
    {
        private const string associatedUserStateKey = "associatedUser";
        private const string associatedDeviceIdStateKey = "associatedDeviceId";

        public RefreshToken(ActorService actorService, ActorId actorId)
            : base(actorService, actorId)
        {
        }

        protected override Task OnActivateAsync()
        {
            ActorEventSource.Current.ActorMessage(this, "Actor activated.");
            return Task.CompletedTask;
        }

        public async Task<string> GetAssociatedUserId()
        {
            var associatedUser = await this.StateManager.TryGetStateAsync<string>(associatedUserStateKey);

            if (!associatedUser.HasValue)
            {
                return null;
            }

            return associatedUser.Value;
        }

        public async Task<string> GetAssociatedDeviceId()
        {
            var associatedDeviceId = await this.StateManager.TryGetStateAsync<string>(associatedDeviceIdStateKey);

            if (!associatedDeviceId.HasValue)
            {
                return null;
            }

            return associatedDeviceId.Value;
        }

        public async Task Associate(string userId, string deviceId)
        {
            if (userId == null)
            {
                throw new ArgumentNullException(nameof(userId));
            }

            if (deviceId == null)
            {
                throw new ArgumentNullException(nameof(deviceId));
            }

            var hasExistingAssociation = await this.StateManager.ContainsStateAsync(associatedUserStateKey);

            if (hasExistingAssociation)
            {
                throw new InvalidOperationException("Already associated.");
            }

            await this.StateManager.SetStateAsync(associatedUserStateKey, userId);
            await this.StateManager.SetStateAsync(associatedDeviceIdStateKey, deviceId);
        }

        public async Task Invalidate()
        {
            await this.StateManager.RemoveStateAsync(associatedUserStateKey);
            await this.StateManager.RemoveStateAsync(associatedDeviceIdStateKey);
        }
    }
}