using System;
using System.Diagnostics;
using System.Threading.Tasks;
using Microsoft.ServiceFabric.Actors;
using Microsoft.ServiceFabric.Actors.Runtime;
using User.Interfaces;

namespace User
{
    [StatePersistence(StatePersistence.Persisted)]
    internal class User : Actor, IUser
    {
        private const string createdStateKey = "created";
        private const string passwordHashStateKey = "passwordHash";
        private const string dataStateKey = "data";

        public User(ActorService actorService, ActorId actorId)
            : base(actorService, actorId)
        {
        }

        public async Task<bool> IsCreated()
        {
            var created = await this.StateManager.TryGetStateAsync<bool>(createdStateKey);

            if (!created.HasValue)
            {
                return false;
            }

            Debug.Assert(created.Value, $"If set, the '{createdStateKey}' state should always be true.");
            return true;
        }

        public async Task Create(string password, UserData data)
        {
            var created = await this.IsCreated();

            if (created)
            {
                throw new InvalidOperationException("User already created.");
            }

            // NOTE: BCrypt takes care of salting for us.
            var hashedPassword = BCrypt.Net.BCrypt.HashPassword(
                password,
                workFactor: 12,
                enhancedEntropy: true);

            await this.StateManager.SetStateAsync(passwordHashStateKey, hashedPassword);
            await this.StateManager.SetStateAsync(dataStateKey, data);
            await this.StateManager.SetStateAsync(createdStateKey, true);
        }

        public async Task<bool> Authenticate(string password)
        {
            this.Log("Authenticating.");

            var created = await this.IsCreated();

            if (!created)
            {
                throw new InvalidOperationException("User not created.");
            }

            var passwordHash = await this.StateManager.GetStateAsync<string>(passwordHashStateKey);
            var result = BCrypt.Net.BCrypt.EnhancedVerify(password, passwordHash);
            this.Log("Authentication {0}.", result ? "succeeded" : "failed");
            return result;
        }

        public async Task<UserData> GetData()
        {
            this.Log("Getting data.");
            var created = await this.IsCreated();

            if (!created)
            {
                throw new InvalidOperationException("User not created.");
            }

            var data = await this.StateManager.GetStateAsync<UserData>(dataStateKey);
            return data;
        }

        public async Task Update(UserData data)
        {
            this.Log("Updating data.");
            var created = await this.IsCreated();

            if (!created)
            {
                throw new InvalidOperationException("User not created.");
            }

            await this.StateManager.SetStateAsync(dataStateKey, data);
        }

        private void Log(string message, params object[] args) =>
            ActorEventSource.Current.ActorMessage(this, message, args);
    }
}
