using System.Threading.Tasks;
using InvitationCode.Interfaces;
using Microsoft.ServiceFabric.Actors;
using Microsoft.ServiceFabric.Actors.Runtime;
using NodaTime;

namespace InvitationCode
{
    [StatePersistence(StatePersistence.Persisted)]
    internal class InvitationCode : Actor, IInvitationCode
    {
        private const string expiryStateKey = "expiry";
        private const string usedStateKey = "used";

        public InvitationCode(ActorService actorService, ActorId actorId)
            : base(actorService, actorId)
        {
        }

        protected override async Task OnActivateAsync()
        {
            this.Log("Actor activated.");
            var expires = SystemClock.Instance.GetCurrentInstant().Plus(Duration.FromDays(14));
            this.Log("Expires at {0}.", expires);
            await this.StateManager.TryAddStateAsync(expiryStateKey, expires);
        }

        public Task<Instant> GetExpiry() =>
            this.StateManager.GetStateAsync<Instant>(expiryStateKey);

        public async Task<bool> IsExpired()
        {
            var expires = await this.GetExpiry();
            var now = SystemClock.Instance.GetCurrentInstant();
            return expires < now;
        }

        public async Task<bool> IsUsed()
        {
            var used = await this.StateManager.TryGetStateAsync<bool>(usedStateKey);

            if (!used.HasValue)
            {
                return false;
            }

            return used.Value;
        }

        public async Task<InvitationCodeUseResult> Use()
        {
            var isUsed = await this.IsUsed();

            if (isUsed)
            {
                return InvitationCodeUseResult.AlreadyUsed;
            }

            var isExpired = await this.IsExpired();

            if (isExpired)
            {
                return InvitationCodeUseResult.Expired;
            }

            await this.StateManager.SetStateAsync(usedStateKey, true);
            this.Log("Used invitation code.");
            return InvitationCodeUseResult.Success;
        }

        private void Log(string message, params object[] args) =>
            ActorEventSource.Current.ActorMessage(this, message, args);
    }
}
