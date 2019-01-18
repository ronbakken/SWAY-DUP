using System.Threading.Tasks;
using Microsoft.ServiceFabric.Actors;
using Microsoft.ServiceFabric.Actors.Runtime;
using User.Interfaces;

namespace User
{
    [StatePersistence(StatePersistence.Persisted)]
    internal class User : Actor, IUser
    {
        private const string dataStateKey = "data";

        public User(ActorService actorService, ActorId actorId)
            : base(actorService, actorId)
        {
        }

        protected override async Task OnActivateAsync()
        {
            this.Log("Activating.");
            await this.StateManager.TryAddStateAsync(dataStateKey, UserData.Initial);
        }

        public async Task<UserData> GetData()
        {
            this.Log("Getting data.");
            var data = await this.StateManager.GetStateAsync<UserData>(dataStateKey);
            return data;
        }

        public async Task SetData(UserData data)
        {
            this.Log("Setting data.");
            await this.StateManager.SetStateAsync(dataStateKey, data);
        }

        private void Log(string message, params object[] args) =>
            ActorEventSource.Current.ActorMessage(this, message, args);
    }
}
