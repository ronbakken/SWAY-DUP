using System;
using System.Threading.Tasks;
using Microsoft.ServiceFabric.Actors;
using Microsoft.ServiceFabric.Actors.Client;
using Microsoft.ServiceFabric.Actors.Runtime;
using Session.Interfaces;
using User.Interfaces;

namespace Session
{
    [StatePersistence(StatePersistence.Persisted)]
    internal class Session : Actor, ISession
    {
        private const string associatedUserNameStateKey = "user";

        public Session(ActorService actorService, ActorId actorId)
            : base(actorService, actorId)
        {
        }

        protected override Task OnActivateAsync()
        {
            this.Log("Actor activated.");
            return Task.CompletedTask;
        }

        public async Task<bool> Login(string userName, string password)
        {
            this.Log("Logging in with user name '{0}'.", userName);
            var actor = GetUserActor(userName);
            var result = await actor.Authenticate(password);

            if (result)
            {
                this.Log("Successfully authenticated.");
                await this.StateManager.SetStateAsync(associatedUserNameStateKey, userName);
                return true;
            }
            else
            {
                this.Log("Failed to authenticate.");
                return false;
            }
        }

        public async Task<bool> Logout()
        {
            this.Log("Logging out.");
            var existingUserName = await this.StateManager.TryGetStateAsync<string>(associatedUserNameStateKey);

            if (!existingUserName.HasValue)
            {
                this.Log("No user is currently associated with this session.");
                return false;
            }

            await this.StateManager.RemoveStateAsync(associatedUserNameStateKey);
            this.Log("Disassociated user '{0}' from session.", existingUserName);
            return true;
        }

        public async Task<string> GetAssociatedUserId()
        {
            this.Log("Getting associated user ID.");
            var existingUserName = await this.StateManager.TryGetStateAsync<string>(associatedUserNameStateKey);

            if (existingUserName.HasValue)
            {
                this.Log("Associated user ID is '{0}'.", existingUserName.Value);
                return existingUserName.Value;
            }

            this.Log("No user is associated with this session.");
            return null;
        }

        private void Log(string message, params object[] args) =>
            ActorEventSource.Current.ActorMessage(this, message, args);

        private static IUser GetUserActor(string userName) =>
            ActorProxy.Create<IUser>(new ActorId(userName), new Uri("fabric:/server/UserActorService"));
    }
}
